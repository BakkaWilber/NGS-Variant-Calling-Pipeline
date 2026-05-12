### Step 1: Data Acquisition

Downloaded human whole genome sequencing data (SRR062634) from the European Nucleotide Archive (ENA).

The ENA was used instead of NCBI SRA due to SSL and compatibility issues encountered with the SRA toolkit.

The dataset was decompressed and subsetted (~500,000 reads) to ensure computational feasibility on a low-memory system.

The subset FASTQ files will be used for downstream analysis.

### Step 1: Data Subsetting

Due to the large size of the original FASTQ files, a subset of reads (~500,000 reads) was extracted.

For compressed files, streaming decompression (zcat) was used to avoid full file extraction and reduce computational load.

This approach ensures efficient data handling while maintaining paired-end read structure.

### Step 2: Quality Control (FastQC)

Performed quality control on the subset FASTQ files using FastQC.

FastQC provides metrics on:
- Per base sequence quality
- GC content distribution
- Sequence duplication levels
- Adapter contamination

This step ensures that the sequencing data is suitable for downstream analysis such as alignment and variant calling.

### Step 3: Read Trimming (fastp)

Performed read trimming using fastp to improve sequencing quality.

This step removes:
- Low-quality bases at the ends of reads
- Reads below quality thresholds
- Potential adapter contamination (if present)

The trimming process improves the reliability of downstream steps such as alignment and variant calling.

Output files:
- clean_1.fastq
- clean_2.fastq

A quality report (HTML and JSON) was generated for evaluation.

### Step 3: Read Trimming Results

After trimming, approximately 92.7% of reads were retained, indicating minimal data loss.

Quality scores improved:
- Q30 increased from ~87–88% to ~90–92%

Adapter sequences were detected and trimmed in a small proportion of reads.

Duplication rate was extremely low (~0.06%), indicating minimal PCR bias.

Overall, the dataset is high quality and suitable for downstream alignment and variant analysis.

### Step 4: Reference Genome Preparation

Downloaded the human reference genome (GRCh38).

To reduce computational load, only chromosome 1 was extracted and used as the reference.

The reference genome was indexed using BWA to enable efficient alignment of sequencing reads.

### Step 4: Alignment Execution

Alignment was performed using a reduced dataset (~100,000 reads) and a 1 Mb region of chromosome 1.

This configuration ensured successful execution within limited computational resources.

The output SAM file contains mapped reads with genomic coordinates and alignment quality information.

## Step 5: BAM Processing

The SAM file generated from alignment was converted into BAM format using samtools.  
BAM is a compressed binary format that allows efficient storage and processing.

The BAM file was then sorted by genomic coordinates to prepare it for downstream analysis such as variant calling.

An index (.bai) file was created to enable rapid access to specific genomic regions.


## Step 6: Variant Calling

Variant calling was performed using bcftools.

Instead of generating an intermediate BCF file, a direct pipeline was used:

bcftools mpileup → bcftools call

This approach ensures correct formatting and avoids file-type inconsistencies.

The output is a VCF (Variant Call Format) file containing detected variants such as SNPs and indels.

Due to the use of a reduced dataset and a limited genomic region, the detected variants are primarily for demonstration of the workflow rather than biological interpretation.

## Step 7: Variant Annotation (Gene Mapping)

Variants identified in the VCF file were converted into BED format to enable genomic interval comparisons.

Gene annotations were extracted from the GENCODE GTF file, focusing on gene-level features within chromosome 1.

Bedtools was used to intersect variant positions with gene coordinates, producing a list of variants that fall within annotated genes.

This step enables mapping of raw genomic variants to biologically meaningful gene regions.


## Step 8: Variant Summary and Interpretation

A total of ~1934 variant-gene overlaps were identified.

Most overlapping genes included:

- Pseudogenes (e.g., WASH7P, CICP family)
- Non-coding RNAs (e.g., DDX11L family, FAM138A)
- MicroRNAs (e.g., MIR1302-2, MIR6859-1)
- Limited protein-coding genes (e.g., OR4F5)

### Biological Interpretation

The analyzed genomic region (chr1:10–10.5 Mb) is not enriched for classical immune-related genes.

However, several identified elements (especially microRNAs and lncRNAs) may play regulatory roles in gene expression and immune signaling.

### Limitations

- Reduced dataset size (~100k reads)
- Partial genome region (~500 kb)
- Lack of functional annotation databases
- No variant filtering (depth, quality thresholds)

### Conclusion

This project demonstrates a complete and functional NGS variant calling and annotation pipeline.

While the selected genomic region showed limited direct relevance to infectious disease pathways, the workflow is scalable and can be applied to biologically relevant regions (e.g., immune gene loci) in future analyses.
