+++
title = "Accurate ethnicity prediction from placental DNA methylation data"

# Date first published.
date = "2019-08-09"

# Authors. Comma separated list, e.g. `["Bob Smith", "David Jones"]`.
authors = ["**Yuan, Victor**", "Price, E Magda", "Del Gobbo, Giulia F", "Mostafavi, Sara", "Cox, Brian", "Binder, Alexandra M", "Michels, Karin B", "Marsit, Carmen", "Robinson, Wendy P"]

# Publication type.
# Legend:
# 0 = Uncategorized
# 1 = Conference proceedings
# 2 = Journal
# 3 = Work in progress
# 4 = Technical report
# 5 = Book
# 6 = Book chapter
publication_types = ["2"]

# Publication name and optional abbreviated version.
publication = "[*Epigenetics & Chromatin*](https://epigeneticsandchromatin.biomedcentral.com/)*"
publication_short = "Epi. & Chrom."

# Abstract and optional shortened version.
abstract = """
**Background:** The influence of genetics on variation in DNA methylation (DNAme) is well documented. Yet confounding from population stratification is often unaccounted for in DNAme association studies. Existing approaches to address confounding by population stratification using DNAme data may not generalize to populations or tissues outside those in which they were developed. To aid future placental DNAme studies in assessing population stratification, we developed an ethnicity classifier, PlaNET (Placental DNAme Elastic Net Ethnicity Tool), using five cohorts with Infinium Human Methylation 450k BeadChip array (HM450k) data from placental samples that is also compatible with the newer EPIC platform.

**Results:** Data from 509 placental samples were used to develop PlaNET and show that it accurately predicts (accuracy = 0.938, kappa = 0.823) major classes of self-reported ethnicity/race (African: n = 58, Asian: n = 53, Caucasian: n = 389), and produces ethnicity probabilities that are highly correlated with genetic ancestry inferred from genome-wide SNP arrays (> 2.5 million SNP) and ancestry informative markers (n = 50 SNPs). PlaNET’s ethnicity classification relies on 1860 HM450K microarray sites, and over half of these were linked to nearby genetic polymorphisms (n = 955). Our placental-optimized method outperforms existing approaches in assessing population stratification in placental samples from individuals of Asian, African, and Caucasian ethnicities.

**Conclusion:** PlaNET provides an improved approach to address population stratification in placental DNAme association studies. The method can be applied to predict ethnicity as a discrete or continuous variable and will be especially useful when self-reported ethnicity information is missing and genotyping markers are unavailable.
"""
abstract_short = "A short version of the abstract."

# Featured image thumbnail (optional)
image_preview = ""

# Is this a selected publication? (true/false)
selected = true

# Projects (optional).
#   Associate this publication with one or more of your projects.
#   Simply enter the filename (excluding '.md') of your project file in `content/project/`.
#   E.g. `projects = ["deep-learning"]` references `content/project/deep-learning.md`.
projects = []

# Links (optional).
url_pdf = "https://epigeneticsandchromatin.biomedcentral.com/track/pdf/10.1186/s13072-019-0296-3"
url_preprint = ""
url_code = "https://github.com/wvictor14/Ethnicity_Inference_450k"
url_dataset = "https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE128827"
url_project = ""
url_slides = ""
url_video = ""
url_poster = ""
url_source = "https://epigeneticsandchromatin.biomedcentral.com/articles/10.1186/s13072-019-0296-3"

# Custom links (optional).
#   Uncomment line below to enable. For multiple links, use the form `[{...}, {...}, {...}]`.
url_custom = [{name = "Software", url = "https://www.github.com/wvictor14/planet/"}]

# Does the content use math formatting?
math = false

# Does the content use source code highlighting?
highlight = false

# Featured image
# Place your image in the `static/img/` folder and reference its filename below, e.g. `image = "example.jpg"`.
[header]
image = ""
caption = ""

+++
