rule run_epest:
    input:
        b="results/filtered/{sample}.bam",
        i="results/filtered/{sample}.bam.bai",
    output:
        directory("results/epest/{sample}/"),
    params:
        args=lambda wildcards: "-D True -pv 1e-8 -R 25 -C chr{1..22} chr{X,Y}"
    threads: 46
    conda:
        "../envs/epest.yaml"
    shell:
        """
        python workflow/scripts/ePEST/ePEST.py {params.args} -t {threads} -o {output} {input.b}
        """
