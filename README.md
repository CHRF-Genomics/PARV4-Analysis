# TPRV Genotyping and Phylogenetic Analysis Pipeline

This repository contains scripts and tools for:
1. **Genotyping** *Parv4* virus sequences based on SNP patterns from VCF files.
2. **Performing multiple sequence alignment** using MAFFT.
3. **Inferring phylogenetic trees** using RAxML from aligned sequences.

---

## 📁 Scripts Overview

### 1. `genotyping.sh`

**Purpose:**  
Automates genotyping of assembled viral genomes against a reference sequence using `minimap2`, `samtools`, and `bcftools`. It then calls a custom Python script `Tetratype.py` to identify *Parv4* genotypes.

**Steps:**
- Align contigs using `minimap2` to reference genome `NC007018.1.fasta`.
- Sort and index the resulting BAM files.
- Call SNPs using `samtools mpileup` + `bcftools call`.
- Extract SNPs and pass the VCF file to `Tetratype.py` for genotype calling.
- Aggregates genotyping results into `.genotype` files.

**Output:**
- BAM files with indexes.
- VCF files with raw SNP calls.
- Genotype calls in tabular format (`*.genotype`, and combined into `CHRF_57.genotype`, `NCBI30.genotype`, etc.).

---

### 2. `Tetratype.py`

**Purpose:**  
Parses a VCF file and compares it against a genotype definition file to determine the most likely *Parv4* genotype and confidence score.

**Usage:**
```bash
python Tetratype.py --vcf input.vcf --geno genotype_definition.txt --output result.txt
