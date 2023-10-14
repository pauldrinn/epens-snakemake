rule run_epest:
    input:
        b="results/filtered/{sample}.bam",
        i="results/filtered/{sample}.bam.bai",
    output:
        o=directory("results/epest/{sample}/"),
        b=directory("results/epest/{sample}/Border"),
        d=directory("results/epest/{sample}/Peak"),
        p=directory("results/epest/{sample}/Dedup"),
    params:
        args=lambda wildcards: "-D True -pv 1e-8 -R 25 -C chr{1..22} chr{X,Y}"
    threads: 46
    conda:
        "../envs/epest.yaml"
    shell:
        """
        python workflow/scripts/ePEST/ePEST.py {params.args} -t {threads} -o {output.o} {input.b}
        """
