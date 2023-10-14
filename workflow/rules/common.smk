import pandas as pd

samples = pd.read_csv(config["SAMPLES"], sep="\t", comment="#").set_index(
    ["sample", "unit"], drop=False
)
samples.index.names = ["sample_id", "unit_id"]
samples.index = samples.index.set_levels([i.astype(str) for i in samples.index.levels])

def get_raw_data(wildcards):
    return list(samples.loc[(wildcards.sample, wildcards.unit), ["fq1", "fq2"]])

def get_technical_replicates(wildcards):
    treps = list(samples[samples["sample"] == wildcards.sample]["unit"])
    return expand(
        f"results/mapped/{wildcards.sample}_{{trep}}.bam", trep=treps
    )

outputs = []
outputs.extend(
    expand(
        ["results/signal/{sample}_{signaltype}.bw", "results/epest/{sample}"],
        sample=samples["sample"],
        signaltype=["R2_rd_plus", "R2_5p_plus", "R1_5p_plus", "R1_5p_minus", "R2_5p_minus", "R2_rd_minus"],
    )
)