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

#' Find all underscore-prefixed files at the root of project_dir (templates,
#' shared includes, etc). Uses the same rule as the sibling-file scan in
#' render_in_isolation() so a file like `_metadata.yml` is picked up
#' consistently regardless of whether the render target lives at the project
#' root or in a subdirectory.
list_root_templates <- function(project_dir) {
  files <- fs::dir_ls(project_dir, type = "file")
  names <- fs::path_file(files)
  names[startsWith(names, "_")]
}

#' Symlink one source path under project_dir to the same relative location
#' under tempdir_path. Silently skips sources that don't exist.
symlink_if_exists <- function(rel_path, project_dir, tempdir_path) {
  src <- fs::path(project_dir, rel_path)
  if (!fs::file_exists(src) && !fs::dir_exists(src)) {
    return(invisible(FALSE))
  }
  dest <- fs::path(tempdir_path, rel_path)
  fs::dir_create(fs::path_dir(dest), recurse = TRUE)
  fs::link_create(fs::path_abs(src), dest)
  invisible(TRUE)
}

#' Copy `src` to `dest`, replacing any existing content at `dest`. Whether
#' `src` is a file or a directory is detected automatically.
copy_replacing <- function(src, dest) {
  fs::dir_create(fs::path_dir(dest), recurse = TRUE)
  if (fs::is_dir(src)) {
    if (fs::dir_exists(dest)) {
      fs::dir_delete(dest)
    }
    fs::dir_copy(src, dest)
  } else {
    fs::file_copy(src, dest, overwrite = TRUE)
  }
}

#' Copy _freeze/<qmd-no-ext>/ from tempdir back to project_dir. A no-op if
#' the page doesn't use freeze (e.g. `execute: freeze: false`).
copy_freeze_back <- function(qmd_path, tempdir_path, project_dir) {
  qmd_no_ext <- fs::path_ext_remove(qmd_path)
  src <- fs::path(tempdir_path, "_freeze", qmd_no_ext)
  if (!fs::dir_exists(src)) {
    return(invisible(FALSE))
  }
  dest <- fs::path(project_dir, "_freeze", qmd_no_ext)
  copy_replacing(src, dest)
  invisible(TRUE)
}

#' Copy rendered output files from tempdir back to project_dir.
#' Handles Quarto website projects where output lands in `_site/`.
copy_output_back <- function(
  qmd_path,
  tempdir_path,
  project_dir,
  output_dir = "_site"
) {
  qmd_no_ext <- fs::path_ext_remove(qmd_path)
  output_src <- fs::path(tempdir_path, output_dir)
  if (!fs::dir_exists(output_src)) {
    cli::cli_warn(
      "No output found at {.path {output_src}} - does {.arg output_dir} match the project's {.field output-dir}?"
    )
    return(invisible(FALSE))
  }

  # HTML file
  html_rel <- paste0(qmd_no_ext, ".html")
  html_src <- fs::path(output_src, html_rel)
  if (fs::file_exists(html_src)) {
    copy_replacing(html_src, fs::path(project_dir, output_dir, html_rel))
  }

  # Associated files directory (figures, libs, etc.)
  files_dir <- paste0(qmd_no_ext, "_files")
  files_src <- fs::path(output_src, files_dir)
  if (fs::dir_exists(files_src)) {
    copy_replacing(files_src, fs::path(project_dir, output_dir, files_dir))
  }

  invisible(TRUE)
}

#' Render a Quarto file in an isolated temporary directory
#'
#' Renders `qmd_path` inside a fresh tempdir populated with symlinks to
#' project-level resources, then copies the resulting `_freeze/` entry and
#' rendered output back to `project_dir`. Intended for use in a `targets`
#' pipeline (or interactively) where parallel renders must not share a
#' working directory.
#'
#' @param qmd_path Character. Path to the `.qmd` file to render, relative to
#'   `project_dir` (e.g. `"reports/page1.qmd"`).
#' @param project_dir Character. Absolute or relative path to the project root.
#'   Defaults to `"."`.
#' @param symlinks Character vector of paths relative to `project_dir` to
#'   symlink into the tempdir. Defaults to `DEFAULT_SYMLINKS` plus all
#'   underscore-prefixed files at the project root.
#' @param keep_failed Logical. If `TRUE`, the tempdir is preserved on render
#'   failure to aid debugging. The returned list's `$tempdir` field gives the
#'   path. Default `FALSE`.
#' @param output_dir Character. Output directory relative to tempdir (e.g.
#'   `"_site"`). Rendered HTML and associated files are copied from here back
#'   to `project_dir`. Default `"_site"`.
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
#' @export
render_in_isolation <- function(
  qmd_path,
  project_dir = ".",
  symlinks = NULL,
  keep_failed = FALSE,
  output_dir = "_site",
  ...
) {
  start <- Sys.time()
  project_dir <- fs::path_abs(project_dir)
  tempdir_path <- tempfile("render-", tmpdir = "/tmp")
  fs::dir_create(tempdir_path)

  render_ok <- FALSE
  original_wd <- getwd()

  on.exit(
    {
      setwd(original_wd)
      if (fs::dir_exists(tempdir_path) && !(keep_failed && !render_ok)) {
        fs::dir_delete(tempdir_path)
      }
    },
    add = TRUE
  )

  links <- if (is.null(symlinks)) DEFAULT_SYMLINKS else symlinks
  links <- c(links, list_root_templates(project_dir))

  # Sibling "_*" files next to the target qmd (e.g. a shared template used
  # via includes) also need to be symlinked in. A missing qmd_dir is reported
  # as a normal render failure below rather than crashing here.
  qmd_dir <- fs::path_dir(qmd_path)
  if (qmd_dir != ".") {
    qmd_dir_files <- tryCatch(
      fs::dir_ls(fs::path(project_dir, qmd_dir), type = "file", all = FALSE),
      error = function(e) character(0)
    )
    for (file_path in qmd_dir_files) {
      file_name <- fs::path_file(file_path)
      if (startsWith(file_name, "_")) {
        links <- c(links, fs::path(qmd_dir, file_name))
      }
    }
  }

  # The render target itself may already be one of the underscore-prefixed
  # templates symlinked above; dedupe so it's only linked once.
  links <- unique(links)
  links <- links[links != qmd_path]
  for (link in links) {
    symlink_if_exists(link, project_dir, tempdir_path)
  }

  setwd(tempdir_path)

  result <- tryCatch(
    {
      target_src <- fs::path(project_dir, qmd_path)
      if (!fs::file_exists(target_src)) {
        cli::cli_abort("Target qmd does not exist: {.path {target_src}}")
      }
      target_dest <- fs::path(tempdir_path, qmd_path)
      fs::dir_create(fs::path_dir(target_dest), recurse = TRUE)
      if (fs::link_exists(target_dest)) {
        fs::file_delete(target_dest)
      }
      fs::link_create(fs::path_abs(target_src), target_dest)

      quarto::quarto_render(qmd_path, ...)
      copy_freeze_back(qmd_path, tempdir_path, project_dir)
      copy_output_back(qmd_path, tempdir_path, project_dir, output_dir)
      list(error = NULL, success = TRUE)
    },
    error = function(e) list(error = conditionMessage(e), success = FALSE)
  )
  render_ok <- isTRUE(result$success)

  list(
    qmd = qmd_path,
    success = result$success,
    error = result$error,
    tempdir = if (keep_failed && !result$success) tempdir_path else NULL,
    duration_sec = as.numeric(difftime(Sys.time(), start, units = "secs"))
  )
}
