# Step 1: Download dataset from ENA (reliable alternative)
cd ~/NGS_Project/data
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR062/SRR062634/SRR062634_1.fastq.gz
wget ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR062/SRR062634/SRR062634_2.fastq.gz

# Unzip files
gunzip SRR062634_1.fastq.gz
gunzip SRR062634_2.fastq.gz

# Subset reads for computational feasibility
head -n 2000000 SRR062634_1.fastq > sub_1.fastq
head -n 2000000 SRR062634_2.fastq > sub_2.fastq

ls -lh

# Step 1: Subset FASTQ files without full decompression
head -n 2000000 SRR062634_1.fastq > sub_1.fastq
zcat SRR062634_2.fastq.gz | head -n 2000000 > sub_2.fastq

# Verify subset files
ls -lh sub_*

# Step 2: Quality Control using FastQC
fastqc sub_1.fastq sub_2.fastq -o ~/NGS_Project/results

# Step 3: Read trimming using fastp
fastp \
-i sub_1.fastq \
-I sub_2.fastq \
-o clean_1.fastq \
-O clean_2.fastq \
-h ~/NGS_Project/results/fastp.html \
-j ~/NGS_Project/results/fastp.json

# Step 4: Prepare reference genome (chr1 subset)
cd ~/NGS_Project/reference
wget https://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/001/405/GCF_000001405.40_GRCh38.p14/GCF_000001405.40_GRCh38.p14_genomic.fna.gz

gunzip GCF_000001405.40_GRCh38.p14_genomic.fna.gz

awk '/^>chr1/{flag=1} /^>chr/{if(flag && !/^>chr1/) exit} flag' GCF_000001405.40_GRCh38.p14_genomic.fna > chr1.fa

bwa index chr1.fa

# Step 4: Alignment using reduced dataset
cd ~/NGS_Project
bwa mem -t 1 reference/chr1_1Mb.fa data/sub_small_1.fastq data/sub_small_2.fastq > results/aligned.sam

# Step 5: BAM Processing

cd ~/NGS_Project/results

# Convert SAM to BAM
samtools view -b aligned_fixed.sam > aligned_fixed.bam

# Sort BAM
samtools sort aligned_fixed.bam -o aligned_fixed_sorted.bam

# Index BAM
samtools index aligned_fixed_sorted.bam

# Step 6: Variant Calling

# Generate variants using bcftools pipeline
bcftools mpileup -f ~/NGS_Project/reference/chr1_fixed.fa \
aligned_fixed_sorted.bam | \
bcftools call -mv -Ov -o variants.vcf

# Step 7: Variant Annotation (Gene Mapping)

# Create BED file from VCF
cd ~/NGS_Project/results
awk '!/^#/ {print "chr1\t"$2-1"\t"$2"\t"$4">"$5}' variants.vcf > variants.bed

# Create BED file of genes from GTF
cd ~/NGS_Project/reference
awk -F'\t' '$3=="gene" {
  if (match($9, /gene_name "[^"]+"/)) {
    gene=substr($9, RSTART+11, RLENGTH-12);
    print $1"\t"$4-1"\t"$5"\t"gene
  }
}' gencode.v44.annotation.gtf > genes.bed

# Find overlaps between variants and genes
bedtools intersect \
-a ~/NGS_Project/results/variants.bed \
-b ~/NGS_Project/reference/genes.bed \
-wa -wb > ~/NGS_Project/results/variant_gene_overlap.txt

# Step 8: Variant Summary

# Count total variants
grep -v "^#" ~/NGS_Project/results/variants.vcf | wc -l

# Count overlaps
wc -l ~/NGS_Project/results/variant_gene_overlap.txt

# Extract unique genes
cut -f8 ~/NGS_Project/results/variant_gene_overlap.txt | sort | uniq
