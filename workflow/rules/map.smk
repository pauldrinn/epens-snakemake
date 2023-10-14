rule bwa_mem_samblaster:
    input:
        reads=["data/{sample}_1.fastq.gz", "data/{sample}_2.fastq.gz"],
        idx=multiext(config["BWA_INDEX"], ".amb", ".ann", ".bwt", ".pac", ".sa"),
    output:
        bam="results/mapped/{sample}.bam",
        index="results/mapped/{sample}.bam.bai",
    params:
        extra=r"-R '@RG\tID:{sample}\tSM:{sample}'",
        sort_extra="",  # Extra args for sambamba.
    threads: 64
    wrapper:
        "v2.6.1/bio/bwa/mem-samblaster"

rule filter:
    input:
        "results/mapped/{sample}.bam",
    output:
        b="results/filtered/{sample}.bam",
        i="results/filtered/{sample}.bam.bai",
    threads: 64
    conda:
        "../envs/samtools.yaml"
    shell:
        """
        samtools view -@4 -b -q30 -f2 -F3852 {input} | samtools collate -Ou -@{threads} - | samtools fixmate -mu - - | samtools view -b -f2 -F3852 | samtools sort -@{threads} > {output.b} \
        && samtools index {output.b}        
        """
