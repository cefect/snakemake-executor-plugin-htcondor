"""Checkpoint proof loaded through Snakemake's include statement."""

import os


checkpoint discover_checkpoint_items:
    output:
        directory("checkpoint/{sample}")
    resources:
        universe="vanilla",
        request_disk="1GB",
        request_memory="512MB",
        job_wrapper="wrapper.sh"
    shell:
        """
        mkdir -p {output}
        for item in alpha beta; do
            (
                printf "item=%s\\n" "$item"
                printf "checkpoint_condor_scratch=%s\\n" "${{_CONDOR_SCRATCH_DIR:-absent}}"
                if [ -e /etc/torture-ep-marker ]; then echo "checkpoint_ep_marker=present"; else echo "checkpoint_ep_marker=absent"; fi
            ) > "{output}/$item.txt"
        done
        """


def checkpoint_item_input(wildcards):
    """Resolve one runtime-discovered checkpoint item."""
    checkpoint_dir = checkpoints.discover_checkpoint_items.get(
        sample=wildcards.sample
    ).output[0]
    return os.path.join(checkpoint_dir, f"{wildcards.item}.txt")


def checkpoint_processed_inputs(wildcards):
    """Expand processing jobs only after the checkpoint reveals its item names."""
    checkpoint_dir = checkpoints.discover_checkpoint_items.get(
        sample=wildcards.sample
    ).output[0]
    items = glob_wildcards(os.path.join(checkpoint_dir, "{item}.txt")).item
    return expand(
        "checkpoint_processed/{sample}/{item}.txt",
        sample=wildcards.sample,
        item=items,
    )


rule process_checkpoint_item:
    input:
        checkpoint_item_input
    output:
        "checkpoint_processed/{sample}/{item}.txt"
    resources:
        universe="vanilla",
        request_disk="1GB",
        request_memory="512MB",
        job_wrapper="wrapper.sh"
    shell:
        """
        mkdir -p "$(dirname {output})"
        cat {input} > {output}
        printf "process_item=%s\\n" "{wildcards.item}" >> {output}
        printf "process_condor_scratch=%s\\n" "${{_CONDOR_SCRATCH_DIR:-absent}}" >> {output}
        if [ -e /etc/torture-ep-marker ]; then echo "process_ep_marker=present" >> {output}; else echo "process_ep_marker=absent" >> {output}; fi
        """


rule collect_checkpoint_items:
    input:
        checkpoint_processed_inputs
    output:
        "output/{sample}_checkpoint.txt"
    resources:
        universe="vanilla",
        request_disk="1GB",
        request_memory="512MB",
        job_wrapper="wrapper.sh"
    shell:
        """
        cat {input} > {output}
        printf "collect_condor_scratch=%s\\n" "${{_CONDOR_SCRATCH_DIR:-absent}}" >> {output}
        if [ -e /etc/torture-ap-marker ]; then echo "collect_ap_marker=present" >> {output}; else echo "collect_ap_marker=absent" >> {output}; fi
        """


# Avoid a third HTCondor negotiation cycle while retaining remote checkpoint and
# runtime-discovered processing jobs inside the focused proof budget.
localrules: collect_checkpoint_items
