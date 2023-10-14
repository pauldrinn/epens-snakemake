rule bamtobed:
    input:
        "results/filtered/{sample}.bam"
    output:
        temp("results/fragments/{sample}.bed")
    params:
        extra=""
    wrapper:
        "v2.6.1/bio/bedtools/bamtobed"

rule get_signals:
    input:
        "results/fragments/{sample}.bed"
    output:
        r2_rd_p=temp("results/signal/{sample}_R2_rd_plus.bg"),
        r2_5p_p=temp("results/signal/{sample}_R2_5p_plus.bg"),
        r1_5p_p=temp("results/signal/{sample}_R1_5p_plus.bg"),
        r1_5p_m=temp("results/signal/{sample}_R1_5p_minus.bg"),
        r2_5p_m=temp("results/signal/{sample}_R2_5p_minus.bg"),
        r2_rd_m=temp("results/signal/{sample}_R2_rd_minus.bg"),
    params:
        chrsizes=config['CHR_SIZES']
    shell:
        """
        cat {input} | awk '$4 ~ /\/2$/ && $6 == "+"' | sort -k 1,1 | bedtools genomecov -bg -g {params.chrsizes} -i - | sort -k1,1 -k2,2n > {output.r2_rd_p} &
        cat {input} | awk '$4 ~ /\/2$/ && $6 == "+"' | sort -k 1,1 | bedtools genomecov -5 -bg -g {params.chrsizes} -i - | sort -k1,1 -k2,2n > {output.r2_5p_p} &
        cat {input} | awk '$4 ~ /\/1$/ && $6 == "+"' | sort -k 1,1 | bedtools genomecov -5 -bg -g {params.chrsizes} -i - | sort -k1,1 -k2,2n > {output.r1_5p_p} &
        cat {input} | awk '$4 ~ /\/1$/ && $6 == "-"' | sort -k 1,1 | bedtools genomecov -5 -bg -g {params.chrsizes} -i - | sort -k1,1 -k2,2n > {output.r1_5p_m} &
        cat {input} | awk '$4 ~ /\/2$/ && $6 == "-"' | sort -k 1,1 | bedtools genomecov -5 -bg -g {params.chrsizes} -i - | sort -k1,1 -k2,2n > {output.r2_5p_m} &
        cat {input} | awk '$4 ~ /\/2$/ && $6 == "-"' | sort -k 1,1 | bedtools genomecov -bg -g {params.chrsizes} -i - | sort -k1,1 -k2,2n > {output.r2_rd_m}
        """

rule convert_to_bw:
    input:
        bedGraph="results/signal/{anything}.bg",
        chromsizes=config["CHR_SIZES"]
    output:
        "results/signal/{anything}.bw"
    wrapper:
        "v2.6.1/bio/ucsc/bedGraphToBigWig"
