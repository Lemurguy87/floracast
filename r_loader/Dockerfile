FROM --platform=linux/arm64 bioconductor/bioconductor_docker:RELEASE_3_21-R-4.5.2

# System dependencies
RUN apt-get update && apt-get install -y \
    libpq-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libxml2-dev \
    && rm -rf /var/lib/apt/lists/*

# Step 1: CRAN packages that Bioc packages silently depend on
RUN R -e "install.packages(c('ggrepel', 'ggplot2', 'reshape2'), repos='https://cloud.r-project.org')"

# Step 2: Low-level Bioc infrastructure
RUN R -e "BiocManager::install(c('S4Vectors', 'IRanges', 'GenomicRanges', 'SummarizedExperiment'), ask=FALSE, update=TRUE)"

# Step 3: TreeSummarizedExperiment explicitly, with hard failure
RUN R -e " \
    BiocManager::install('TreeSummarizedExperiment', ask=FALSE, update=TRUE); \
    library(TreeSummarizedExperiment)"

# Step 4: scater (needs ggrepel from Step 1)
RUN R -e " \
    BiocManager::install('scater', ask=FALSE, update=TRUE); \
    library(scater)"

# Step 5: mia (needs both TreeSummarizedExperiment + scater)
RUN R -e " \
    BiocManager::install('mia', ask=FALSE, update=TRUE); \
    library(mia)"

# Step 6: Final target package
RUN R -e " \
    BiocManager::install('curatedMetagenomicData', ask=FALSE, update=TRUE); \
    library(curatedMetagenomicData)"

WORKDIR /data