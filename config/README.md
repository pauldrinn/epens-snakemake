Edit these files:

1. `config.yaml`: The config file. Only used parameters are:

`SAMPLES` which points to `samples.tsv`
`BWA_INDEX` which points to the BWA index prefix
`CHR_SIZES` which points to the chrom.sizes file (formatted as tab-separated; chrom name in the 1st column, size in the 2nd)

2. `samples.tsv`: A tab-separated file with the following example should be provided to specify the units (technical replicates or lanes):

| sample  | unit | fq1                               | fq2                               |
|---------|------|-----------------------------------|-----------------------------------|
| N1_rep1 | 1    | data/SRR653223_1.fastq.gz         | data/SRR653223_2.fastq.gz         |
| N1_rep2 | 1    | data/SRR653224_1.fastq.gz         | data/SRR653224_2.fastq.gz         |

sample: Sample name (same as in samples.tsv)

unit: Unit (tech. rep such as sequencing lane) no

fq1: Path to the 1st FASTQ file

fq2: Path to the 2nd FASTQ file

IF THE FILE DOESN'T EXIST, IT WILL TRY TO DOWNLOAD FROM SRA USING PREFETCH