library(SeuratData)
library(here)

#ad <- AvailableData()
#ad

DATASET_ID <- 'ifnb'
FILE_RDS <- paste0(DATASET_ID, '.rds')
FILE_RDS <- here(FILE_RDS)

if (fs::file_exists(FILE_RDS)) {
  cli::cli_alert_info('{FILE_RDS} exists. Skipping installing {DATASET_ID}')
} else {
  InstallData(DATASET_ID)
  seu <- LoadData(DATASET_ID)
  seu <- UpdateSeuratObject(seu)
  
  cli::cli_alert_info("Processing {DATASET_ID}")
  seu <- seu |>
    NormalizeData() |>
    FindVariableFeatures() |>
    ScaleData() |>
    RunPCA()
  #seu <- seu |> RunUMAP(dims = 1:10)
  
  cli::cli_alert_info("Integrating {DATASET_ID}...")
  seu[["RNA"]] <- split(seu[["RNA"]], f = seu$stim)
  seu <- IntegrateLayers(
    object = seu, 
    method = CCAIntegration, 
    orig.reduction = "pca", 
    new.reduction = "integrated.cca",
    verbose = FALSE
  )
  seu <- RunUMAP(seu, dims = 1:10, reduction = "integrated.cca")
  
  # re-join layers after integration
  seu[["RNA"]] <- JoinLayers(seu[["RNA"]])
  seu
  
  #  DimPlot(seu, reduction = "umap", group.by = c("stim", "seurat_annotations"))
  cli::cli_alert_info('Filtering to features')
  features <-  unique(c(
    "CD3D", "CREM", "HSPH1", "SELL", "GIMAP5", "CACYBP", "GNLY", "NKG7", "CCL5",
    "CD8A", "MS4A1", "CD79A", "MIR155HG", "NME1", "FCGR3A", "VMO1", "CCL2", "S100A9", "HLA-DQA1",
    "GPR183", "PPBP", "GNG11", "HBA2", "HBB", "TSPAN13", "IL3RA", "IGJ", "PRSS57",
    c(
      "MS4A1", # B cell
      "CD14",  # monocytes
      "LYZ",   # monocytes
      "GNLY",  # NK
      "FCER1A",  # dc
      "CD3E",  # T cell
      "CD4",   # CD4
      "CD8B",  # CD8
      "FOXP3"  # Treg 
    )))
  seu <- seu[features,]
  
  cli::cli_alert_info('Writing seurat object {DATASET_ID} to disk as {FILE_RDS}')
  saveRDS(seu, here(FILE_RDS))
}


features <- intersect(
  c(
    "MS4A1", # B cell
    "CD14",  # monocytes
    "LYZ",   # monocytes
    "GNLY",  # NK
    "FCER1A",  # dc
    "CD3E",  # T cell
    "CD4",   # CD4
    "CD8B",  # CD8
    "FOXP3"  # Treg 
  ),
  c("LYZ", "CCL5", "IL32", "PTPRCAP", "FCGR3A", "FCGR3B", "CSFR3", "PF4")
)

InstallData('pbmc3k')
InstallData('hcabm40k')