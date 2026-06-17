# Render a single Quarto .qmd in an isolated tempdir, to allow quarto render in parallel
DEFAULT_SYMLINKS <- c(
  "_quarto.yml",
  "_brand.yml",
  ".Rprofile",
  "R",
  "DESCRIPTION",
  "NAMESPACE",
  "renv",
  "renv.lock",
  "brand",
  "data",
  "includes",
  "img",
  "figures",
  "figure",
  "styles.css",
  "scripts",
  "references.bib"
)

#' Find all _*.qmd and _*.Rmd templates at the root of project_dir.
.list_root_templates <- function(project_dir) {
  list.files(project_dir, pattern = "^_.*\\.(qmd|Rmd)$", full.names = FALSE)
}

#' Symlink one source path under project_dir to the same relative location
#' under tempdir_path. Silently skips sources that don't exist.
.symlink_if_exists <- function(rel_path, project_dir, tempdir_path) {
  src <- fs::path(project_dir, rel_path)
  if (!fs::file_exists(src) && !fs::dir_exists(src)) {
    return(invisible(FALSE))
  }
  dest <- fs::path(tempdir_path, rel_path)
  fs::dir_create(fs::path_dir(dest), recurse = TRUE)
  fs::link_create(fs::path_abs(src), dest)
  invisible(TRUE)
}

#' Copy _freeze/<qmd-no-ext>/ from tempdir back to project_dir, replacing
#' any existing content at the destination.
.copy_freeze_back <- function(qmd_path, tempdir_path, project_dir) {
  qmd_no_ext <- sub("\\.qmd$", "", qmd_path)
  src <- fs::path(tempdir_path, "_freeze", qmd_no_ext)
  if (!fs::dir_exists(src)) {
    cli::cli_abort(
      "Render completed but no freeze produced at {.path {src}}"
    )
  }
  dest <- fs::path(project_dir, "_freeze", qmd_no_ext)
  if (fs::dir_exists(dest)) {
    fs::dir_delete(dest)
  }
  fs::dir_create(fs::path_dir(dest), recurse = TRUE)
  fs::dir_copy(src, dest)
}

#' Copy rendered output files from tempdir back to project_dir.
#' Handles Quarto website projects where output lands in `_site/`.
.copy_output_back <- function(
  qmd_path,
  tempdir_path,
  project_dir,
  output_dir = "_site"
) {
  qmd_no_ext <- sub("\\.qmd$", "", qmd_path)
  output_src <- fs::path(tempdir_path, output_dir)
  if (!fs::dir_exists(output_src)) {
    return(invisible(FALSE))
  }

  # HTML file
  html_rel <- paste0(qmd_no_ext, ".html")
  html_src <- fs::path(output_src, html_rel)
  if (fs::file_exists(html_src)) {
    html_dest <- fs::path(project_dir, output_dir, html_rel)
    fs::dir_create(fs::path_dir(html_dest), recurse = TRUE)
    fs::file_copy(html_src, html_dest, overwrite = TRUE)
  }

  # Associated files directory (figures, libs, etc.)
  files_dir <- paste0(qmd_no_ext, "_files")
  files_src <- fs::path(output_src, files_dir)
  if (fs::dir_exists(files_src)) {
    files_dest <- fs::path(project_dir, output_dir, files_dir)
    if (fs::dir_exists(files_dest)) {
      fs::dir_delete(files_dest)
    }
    fs::dir_copy(files_src, files_dest)
  }

  invisible(TRUE)
}

#' Render a Quarto file in an isolated temporary directory (programmatic)
#'
#' Renders `qmd_path` inside a fresh tempdir populated with symlinks to
#' project-level resources, then copies the resulting `_freeze/` entry back to
#' `project_dir`. Optionally logs the render event to a SQLite database with
#' pin provenance metadata. Intended for use in the `targets` pipeline where
#' parallel renders must not share a working directory.
#'
#' @param qmd_path Character. Path to the `.qmd` file to render, relative to
#'   `project_dir` (e.g. `"reports_RA/Cohort 1/S01-101-001/flow.qmd"`).
#' @param project_dir Character. Absolute or relative path to the project root.
#'   Defaults to `"."`.
#' @param symlinks Character vector of paths relative to `project_dir` to
#'   symlink into the tempdir. Defaults to `DEFAULT_SYMLINKS` plus all
#'   root-level `_*.qmd` / `_*.Rmd` templates.
#' @param keep_failed Logical. If `TRUE`, the tempdir is preserved on render
#'   failure to aid debugging. The returned list's `$tempdir` field gives the
#'   path. Default `FALSE`.
#' @param db Character path to the render-history SQLite database, or `NULL`
#'   (default) to skip logging.
#' @param pin_name,pin_dataset,pin_indication,pin_hash Pin provenance fields
#'   written to the database row when `db` is non-`NULL`. All default to
#'   `NULL`.
#' @param output_dir Character. Output directory relative to tempdir (e.g. `"_site"`).
#'   Rendered HTML and associated files are copied from here back to `project_dir`.
#'   Default `"_site"`.
#' @param ... Additional arguments forwarded to [quarto::quarto_render()].
#'
#' @return A named list with fields:
#'   \describe{
#'     \item{`qmd`}{The input `qmd_path`.}
#'     \item{`success`}{Logical; `TRUE` if the render completed without error.}
#'     \item{`error`}{Character error message, or `NULL` on success.}
#'     \item{`tempdir`}{Path to the preserved tempdir when `keep_failed = TRUE`
#'       and the render failed; otherwise `NULL`.}
#'     \item{`duration_sec`}{Elapsed render time in seconds.}
#'   }
.render_in_isolation <- function(
  qmd_path,
  project_dir = ".",
  symlinks = NULL,
  keep_failed = FALSE,
  db = NULL,
  pin_name = NULL,
  pin_dataset = NULL,
  pin_indication = NULL,
  pin_hash = NULL,
  output_dir = "_site",
  ...
) {
  start <- Sys.time()
  project_dir <- fs::path_abs(project_dir)
  db <- if (!is.null(db)) fs::path_abs(db)
  tempdir_path <- tempfile("render-", tmpdir = "/tmp")
  dir.create(tempdir_path)

  render_ok <- FALSE

  on.exit(
    {
      if (fs::dir_exists(tempdir_path)) {
        if (!render_ok && keep_failed) {
          # Leave tempdir for debugging
        } else {
          fs::dir_delete(tempdir_path)
        }
      }
    },
    add = TRUE
  )

  original_wd <- getwd()
  on.exit(setwd(original_wd), add = TRUE, after = FALSE)

  links <- if (is.null(symlinks)) DEFAULT_SYMLINKS else symlinks
  links <- c(links, .list_root_templates(project_dir))

  for (link in links) {
    .symlink_if_exists(link, project_dir, tempdir_path)
  }

  qmd_dir <- fs::path_dir(qmd_path)
  if (qmd_dir != ".") {
    qmd_dir_files <- fs::dir_ls(
      fs::path(project_dir, qmd_dir),
      type = "file",
      all = FALSE
    )
    for (file_path in qmd_dir_files) {
      file_name <- fs::path_file(file_path)
      if (startsWith(file_name, "_")) {
        rel_path <- fs::path(qmd_dir, file_name)
        .symlink_if_exists(rel_path, project_dir, tempdir_path)
      }
    }
  }

  setwd(tempdir_path)

  result <- tryCatch(
    {
      target_src <- fs::path(project_dir, qmd_path)
      if (!fs::file_exists(target_src)) {
        stop("Target qmd does not exist: ", target_src)
      }
      target_dest <- fs::path(tempdir_path, qmd_path)
      fs::dir_create(fs::path_dir(target_dest), recurse = TRUE)
      fs::link_create(fs::path_abs(target_src), target_dest)

      quarto::quarto_render(qmd_path, ...)
      .copy_freeze_back(qmd_path, tempdir_path, project_dir)
      .copy_output_back(qmd_path, tempdir_path, project_dir, output_dir)
      render_ok <<- TRUE
      list(error = NULL, ok = TRUE)
    },
    error = function(e) list(error = conditionMessage(e), ok = FALSE)
  )

  elapsed <- as.numeric(difftime(Sys.time(), start, units = "secs"))

  if (!is.null(db)) {
    tryCatch(
      log_render_event(
        db_path = db,
        page = qmd_path,
        rendered_at = format(
          start,
          "%Y-%m-%dT%H:%M:%S",
          tz = "America/Los_Angeles"
        ),
        pin_name = pin_name,
        pin_dataset = pin_dataset,
        pin_indication = pin_indication,
        pin_hash = pin_hash,
        success = result$ok,
        duration_sec = elapsed
      ),
      error = function(e) {
        warning(
          "Failed to log render event for ",
          qmd_path,
          ": ",
          conditionMessage(e)
        )
      }
    )
  }

  list(
    qmd = qmd_path,
    success = result$ok,
    error = result$error,
    tempdir = if (keep_failed && !result$ok) tempdir_path else NULL,
    duration_sec = elapsed
  )
}

#' Render a Quarto file in an isolated temporary directory (interactive)
#'
#' Convenience wrapper around [.render_in_isolation()] for interactive use.
#' Renders `qmd_path` inside a fresh tempdir and copies the resulting
#' `_freeze/` entry back to `project_dir`. Does not write to the render-history
#' database or record pin provenance. Use [.render_in_isolation()] directly
#' when those fields are needed (e.g. from the `targets` pipeline).
#'
#' @inheritParams .render_in_isolation
#' @export
#' @return A named list with fields `qmd`, `success`, `error`, `tempdir`, and
#'   `duration_sec`. See [.render_in_isolation()] for details.
render_in_isolation <- function(
  qmd_path,
  project_dir = ".",
  symlinks = NULL,
  keep_failed = FALSE,
  output_dir = "_site",
  ...
) {
  .render_in_isolation(
    qmd_path = qmd_path,
    project_dir = project_dir,
    symlinks = symlinks,
    keep_failed = keep_failed,
    output_dir = output_dir,
    ...
  )
}
