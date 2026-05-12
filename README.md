# NGS Variant Calling Pipeline

## Overview
This project demonstrates an end-to-end Next Generation Sequencing (NGS) analysis pipeline, from raw sequencing reads to variant identification and gene-level annotation.

The pipeline was implemented on a local Linux environment with constrained computational resources, requiring optimization strategies such as read subsetting and reference genome reduction.


## Objectives
- Perform quality control on sequencing data
- Trim and preprocess reads
- Align reads to a reference genome
- Process alignment files (SAM/BAM)
- Call genomic variants
- Map variants to gene regions
- Interpret biological relevance-

## Tools Used
- FastQC
- fastp
- BWA
- SAMtools
- BCFtools
- BEDTools
- SeqKit

## Workflow

1. Quality Control (FastQC)
2. Read Trimming (fastp)
3. Alignment (BWA)
4. BAM Processing (SAMtools)
5. Variant Calling (BCFtools)
6. Variant Annotation (BEDTools + GENCODE)

## Key Results

- Successfully generated VCF file with detected variants
- Identified ~1934 variant-gene overlaps
- Variants mapped primarily to:
  - Non-coding RNAs
  - Pseudogenes
  - MicroRNAs

## Reference Data

The full GENCODE annotation file is not included due to size limitations.

Download it from:
https://ftp.ebi.ac.uk/pub/databases/gencode/Gencode_human/

File used:
gencode.v44.annotation.gtf

## Biological Insight

The selected genomic region (chr1:10–10.5 Mb) is not enriched for classical immune genes but contains regulatory elements such as microRNAs and lncRNAs that may influence gene expression.

## Limitations

- Reduced dataset size
- Partial genome reference
- No functional annotation tools (e.g., VEP, ANNOVAR)

## Future Work

- Apply pipeline to immune-related genomic regions
- Integrate functional annotation tools
- Use larger datasets and full genome alignment
- Link variants to disease-associated genes


## Author
Bakka Wilber 
Biomedical Researcher | Bioinformatician 
Infectious Diseases Institute, Uganda
