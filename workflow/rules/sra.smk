rule prefetch:
    output:
        temp("data/{accession}.sra")
    log:
        "logs/{accession}.sra.log"
    conda: 
        "../envs/sra.yaml"
    shell:
        "prefetch -O data/ {wildcards.accession}"
