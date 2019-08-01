## ----setup, include=FALSE------------------------------------------------
options(htmltools.dir.version = FALSE)
knitr::opts_chunk$set(echo = F, warning = F, message = F)



## ----xaringan-themer, include = FALSE------------------------------------
library(xaringanthemer)
mono_accent(
  base_color = "#43418A",
  header_font_google = google_font("Josefin Sans"),
  text_font_google   = google_font("Montserrat", "300", "300i"),
  code_font_google   = google_font("Droid Mono")
)

library(RefManageR)

BibOptions(
  check.entries = FALSE, 
  bib.style = "authoryear", 
  cite.style = "authoryear", 
  style = "markdown",
  hyperlink = FALSE, 
  dashed = FALSE)
myBib = ReadBib("20190412_lab_meeting.bib")


## ------------------------------------------------------------------------
library(printr)


## ---- out.height = 400, fig.align='center'-------------------------------
knitr::include_graphics("img/pipeline_diagram.png", dpi = NA)



## ----scRNA_analysis, out.height=450, out.width=300-----------------------
knitr::include_graphics("img/single_cell_pipeline_flowchart.png")


## ----hierarch, echo=FALSE,out.width=900,fig.align='center'---------------
knitr::include_graphics("img/Capture.PNG")


## ----corr_genes, echo=FALSE,out.width="900px"----------------------------
knitr::include_graphics("img/spearman_corr_1.PNG")

knitr::include_graphics("img/spearman_corr_2.PNG")


## ---- out.height=400-----------------------------------------------------
knitr::include_graphics("img/pca.gif", dpi = NA)



## ---- out.height = 400, fig.align='center'-------------------------------
knitr::include_graphics("img/phenograph.jpg", dpi = NA)



## ---- out.width = 960, out.height = 480----------------------------------
knitr::include_graphics("img/tsne_v_umap.gif")



## ---- out.width = 900----------------------------------------------------
knitr::include_graphics("img/stuart_integration_diagram.png", dpi = NA)



## ---- eval = F-----------------------------------------------------------
## install.packages("BiocManager")


## ---- eval = F-----------------------------------------------------------
## ## the command below is a one-line shortcut for:
## ## library(BiocManager)
## ## install("SingleCellExperiment")
## BiocManager::install("SingleCellExperiment")


## ---- echo = T, eval = F-------------------------------------------------
## ?data.frame
## ?SingleCellExperiment
## ?iris
## ?BiocManager


## ------------------------------------------------------------------------
knitr::include_graphics("img/r4ds.png", dpi = NA)



## ---- results = 'asis'---------------------------------------------------
# pander::pander(purrr::possibly(RefManageR::PrintBibliography(myBib)))
RefManageR::PrintBibliography(myBib, start = 1, end = 4)

