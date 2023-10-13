rule prefetch:
    output:
        temp("data/{accession}.sra")
    conda: 
        "../envs/sra.yaml"
    shell:
        """
        prefetch -O data/ {wildcards.accession}
        """

rule dump_fastq:
    input:
        "data/{accession}.sra"
    output:
        "data/{accession}_1.fastq.gz",
        "data/{accession}_2.fastq.gz",
    threads: 64
    params:
        name="data/{accession}_*.fastq"
    conda:
        "../envs/sra.yaml"
    shell:
        """
        fasterq-dump --temp data/ --threads {threads} -O data/ -m {resources.mem_mb}MB {input};
        pigz {params.name}
        """
