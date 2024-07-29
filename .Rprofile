source("renv/activate.R")
# in .Rprofile of the website project
if (file.exists("~/.Rprofile")) {
  base::sys.source("~/.Rprofile", envir = environment())
}

options(
  blogdown.hugo.version = "0.119.0",
  blogdown.author = "Victor Yuan",
  blogdown.ext = ".Rmd",
  blogdown.subdir = "post",
  blogdown.yaml.empty = TRUE,
  blogdown.new_bundle = TRUE,
  blogdown.title_case = TRUE
)

#library(blogdown)
renv::settings$ignored.packages(
  c("devtools", 'HDF5Array', 'hdf5r', 'scRNAseq'), 
  persist = TRUE)


