library(SeuratData)
library(here)

#ad <- AvailableData()
#ad

InstallData('pbmcsca')
seu <- LoadData('pbmcsca')
seu <- UpdateSeuratObject(seu)
seu <- seu |>
  NormalizeData() |>
  FindVariableFeatures() |>
  ScaleData() |>
  RunPCA()
seu <- seu |> RunUMAP(dims = 1:10)
saveRDS(seu, here('pbmcsca.rds'))

InstallData('pbmc3k')
InstallData('hcabm40k')