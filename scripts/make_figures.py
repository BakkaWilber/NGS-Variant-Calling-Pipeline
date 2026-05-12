import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch
import pandas as pd

# -----------------------------------
# Figure 1: Workflow Diagram
# -----------------------------------

fig = plt.figure(figsize=(6, 10))
ax = fig.add_axes([0, 0, 1, 1])
ax.axis("off")

steps = [
    "Raw FASTQ Reads",
    "FastQC Quality Assessment",
    "fastp Read Trimming",
    "BWA MEM Alignment",
    "SAMtools BAM Processing",
    "BCFtools Variant Calling",
    "BEDTools + GENCODE Annotation",
    "Biological Interpretation"
]

y = 0.92

for step in steps:

    box = FancyBboxPatch(
        (0.15, y - 0.05),
        0.7,
        0.07,
        boxstyle="round,pad=0.02"
    )

    ax.add_patch(box)

    ax.text(
        0.5,
        y - 0.015,
        step,
        ha="center",
        va="center",
        fontsize=11
    )

    if y > 0.14:

        ax.annotate(
            "",
            xy=(0.5, y - 0.10),
            xytext=(0.5, y - 0.07),
            arrowprops=dict(arrowstyle="->")
        )

    y -= 0.11

ax.set_title(
    "End-to-End NGS Variant Calling Pipeline",
    fontsize=15
)

plt.tight_layout()
plt.savefig("../results/figures/workflow.png", dpi=300)
plt.close()

# -----------------------------------
# Figure 2: QC Comparison
# -----------------------------------

metrics = [
    "Reads Retained (x1000)",
    "Read1 Q30 (%)",
    "Read2 Q30 (%)"
]

before = [500, 87.47, 88.74]
after = [463.6, 90.48, 92.13]

fig = plt.figure(figsize=(8, 5))

ax = fig.add_axes([0.12, 0.15, 0.8, 0.75])

x = range(len(metrics))
width = 0.35

ax.bar(
    [i - width/2 for i in x],
    before,
    width,
    label="Before"
)

ax.bar(
    [i + width/2 for i in x],
    after,
    width,
    label="After"
)

ax.set_xticks(list(x))
ax.set_xticklabels(metrics)

ax.set_title(
    "Quality Metrics Before vs After Trimming"
)

ax.legend()

plt.tight_layout()
plt.savefig("../results/figures/qc_comparison.png", dpi=300)
plt.close()

# -----------------------------------
# Figure 3: Summary Table
# -----------------------------------

summary = [
    ["Dataset", "SRR062634 (1000 Genomes subset)"],
    ["Region", "chr1 (~500 kb)"],
    ["Reads processed", "100,000"],
    ["Variant-gene overlaps", "1,934"],
    ["Unique genes/features", "24"]
]

fig, ax = plt.subplots(figsize=(8, 3))

ax.axis("off")

table = ax.table(
    cellText=summary,
    colLabels=["Metric", "Value"],
    loc="center"
)

table.auto_set_font_size(False)
table.set_fontsize(10)
table.scale(1, 2)

plt.title("Project Output Summary")

plt.tight_layout()
plt.savefig("../results/figures/project_summary.png", dpi=300)
plt.close()

# -----------------------------------
# Figure 4: Gene Categories
# -----------------------------------

labels = [
    "Pseudogenes",
    "lncRNA/non-coding",
    "microRNAs",
    "Protein-coding"
]

sizes = [10, 9, 3, 1]

fig = plt.figure(figsize=(6, 6))

ax = fig.add_axes([0.1, 0.1, 0.8, 0.8])

ax.pie(
    sizes,
    labels=labels,
    autopct="%1.0f%%"
)

ax.set_title("Gene Feature Categories")

plt.tight_layout()
plt.savefig("../results/figures/gene_categories.png", dpi=300)
plt.close()

print("Figures generated successfully.")
