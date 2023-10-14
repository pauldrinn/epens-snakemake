rule bwa_mem_samblaster:
    input:
        reads=get_raw_data,
        idx=multiext(config["BWA_INDEX"], ".amb", ".ann", ".bwt", ".pac", ".sa"),
    output:
        bam=temp("results/mapped/{sample}_{unit}.bam"),
        index=temp("results/mapped/{sample}_{unit}.bam.bai"),
    params:
        extra=r"-R '@RG\tID:{sample}\tSM:{sample}'",
        sort_extra="",  # Extra args for sambamba.
    threads: 64
    wrapper:
        "v2.6.1/bio/bwa/mem-samblaster"

rule merge_DNA_treplicates:
    input:
        get_technical_replicates,
    output:
        "results/mapped/{sample}.bam",
    conda:
        "../envs/samtools.yaml"
    shell:
        """
        if [[ "{input}" = *" "* ]]; then
            samtools merge -o {output} {input}
        else
            cp {input} {output}
        fi
        """

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
