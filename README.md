# metagenomics-workflows


This repository provides workflows, scripts, and examples for metagenomic data analysis, including assembly-based and reads-based approaches.

## This Workflow will perform:

* Pre-processing of reads
* Metagenomic Assembly with spades
* Metagenome binning
* Gene Prediction
* Taxonomic Classification


# 1. Quality Control

This step will remove host reads.
* Requirements:
- Path to directory with paired shotgun sequencing files. 


# 2. Assemble Contigs 
This step assembles high-quality contigs from preprocessed paired-end metagenomic reads using MetaSPAdes v3.15.5. The script is written for execution in an HPC environment (SGE scheduler) and supports parallelized job arrays for processing multiple samples simultaneously.

* Reads sample names from a sample_list.txt file
* Retrieves R1 and R2 paths from a tab-delimited mapping_file.tsv (columns: SampleID, R1, R2)
* Runs metaspades.py on each sample using scratch space
* Saves final assembled contigs to an output directory



# 3. Multi-Contig Genome Binning

This step clusters assembled contigs into draft metagenome-assembled genomes (MAGs) using three complementary binning tools: MetaBAT2, MaxBin2, and CONCOCT. Binning is performed per sample using high-performance job arrays with local scratch storage for I/O efficiency.

* Retrieves filtered contigs and cleaned reads for each sample
* Builds Bowtie2 indices and maps reads to contigs
* Calculates contig coverage depth across samples
* Performs genome binning with:


## Input Requirements

* Filtered contig files (*_contigs.m500.fasta) for each sample
* Cleaned paired-end reads (*_R1_clean.fastq.gz, *_R2_clean.fastq.gz)
* Sample list: one sample ID per line (used with SGE_TASK_ID)


















