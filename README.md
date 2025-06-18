
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
```

**Input:**
- `--vcf`: VCF file generated from mapping and variant calling.
- `--geno`: Tab-delimited file with SNP positions, expected base, and associated genotype.
- `--output`: Output file to save the determined genotype and confidence score.

**Output:**
A tab-separated file with:
```
Sample_Name   Genotype   Confidence
```

**Logic:**
- Matches VCF SNPs with genotype-defining positions.
- If all/most SNPs for one genotype are found, that genotype is assigned.
- If SNPs from multiple genotypes are detected, a "mixed" genotype is reported.

---

### 3. `TPRV_mafft_raxml_Preonath.sh`

**Purpose:**  
Performs multiple sequence alignment and phylogenetic tree construction for *Parv4* sequences using MAFFT and RAxML.

**Steps:**
1. **Merge** sequences into a single FASTA (`TPRV_57_merged.fa`).
2. **Clean/Format** sequence names with `sed`.
3. **Align** sequences using `mafft --localpair --maxiterate 1000`.
4. **Convert** FASTA to PHYLIP format using a custom `fasta2phylip.py` script.
5. **Run RAxML**:
   - Infer best tree topology.
   - Generate bootstrap replicates.
   - Combine for final support tree with bipartitions.

**Output:**
- Aligned FASTA and PHYLIP files.
- RAxML trees: `RAxML_bestTree`, `RAxML_bootstrap`, `RAxML_bipartitionsBranchLabels`.

**Supports:** multiple datasets (TPRV_57, TPRV_71, TPRV_72, TPRV_111), each having its own RAxML output.

---

## 🛠 Requirements

### Tools:
- [`minimap2`](https://github.com/lh3/minimap2)
- [`samtools`](http://www.htslib.org/)
- [`bcftools`](http://samtools.github.io/bcftools/)
- [`mafft`](https://mafft.cbrc.jp/alignment/software/)
- [`RAxML`](https://cme.h-its.org/exelixis/web/software/raxml/)
- Python 3 with `argparse` (standard library)

---

## 📁 Folder Structure

Expected structure for `genotyping.sh`:
```
TPRV/
├── Tanmoy_Recheck_tetratype/
│   ├── raw_assembled_data/
│   ├── Reference_Sequences/TPRV/NC007018.1.fasta
│   ├── Parv4_genotype_definition.txt
│   └── Tetratype.py
```

Expected output folders:
- `Genotype/`
- `Genotype/SAM/`

---

## 📌 Notes

- Make sure `Tetratype.py` is executable or run with `python`.
- High-performance computing resources are assumed (threads: 80–92 used).
- MAFFT and RAxML output tree files can be visualized using tools like FigTree or iTOL.
