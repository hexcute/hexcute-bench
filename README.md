# hexcute-bench

This repository contains the benchmark scripts for our paper:

**Hexcute: A Compiler Framework for Automating Layout Synthesis in GPU Programs**  


The repository structure is organized as follows:

- `docker`: Contains the Dockerfiles for building the Docker containers needed for the runtime environment.
- `hidet`: Contains the source code of Hexcute.
- `scripts`: Includes the scripts to run the experiments presented in the paper.
- `hexcute_results_demo`: Provides example figures generated during the artifact evaluation process.

---

## 📦 Artifact Overview

This artifact enables reproducibility of:

- Kernel performance benchmarks (GEMM, Attention, FP8 GEMM, warp-specialized kernels)  
- Mixed-type MoE evaluation  
- Mamba selective scan evaluation  
- Analytical cost model accuracy tests  
- Plots in Figures 11, 12, 20, 21, and 24–29 of the paper  

---

## 📋 System Requirements

### Hardware
- x86-64 Linux host  
- $\ge$ 20 CPU cores  
- $\ge$ 100 GB RAM  
- $\ge$ 100 GB free disk space  
- NVIDIA A100 PCIe (80 GB)  
- NVIDIA H100 PCIe or SXM (80GB)  
  (Benchmarks were conducted on H100 PCIe GPUs; results on H100 SXM (80 GB) may differ slightly.)

### Software
**Option 1 — Build using the provided Docker image**
- Docker (validated with Docker 29)

**Option 2 — Build locally using `build.sh`**
- CUDA Toolkit $\ge$ 12.6  
- CMake $\ge$ 3.19  
- Python $\ge$ 3.10 (validated with Python 3.12 )  
- Ubuntu 22.04+ (validated with Ubuntu 24.04)  
- NVIDIA Driver $\ge$ 550 (validated with Driver 580)

---

## 📥 Getting the Artifact

1. Clone the repository:

```bash
git clone https://github.com/hexcute/hexcute-bench
cd hexcute-bench
```
## ⚙️ Installation
**Option 1 — Using the provided Docker image**

1. Pull the container image
```bash
docker pull ghcr.io/hexcute/hexcute-bench/hexcute:latest
```

2. Run inside the container
```bash
docker run --privileged \
    -v /path/to/hexcute-bench:/workspace/hexcute-bench \
    --gpus all -it \
    ghcr.io/hexcute/hexcute-bench/hexcute:latest /bin/bash
```

> Note: `--privileged` is required because the benchmark scripts lock the GPU's frequency.

**Option 1' — Building the Docker image locally**

1. Navigate to the `docker` directory:
```bash
cd docker
```
2. Build the Docker image:

```bash
docker build -f Dockerfile -t hexcute:latest .
```
Note: Building the image takes approximately 20 minutes.

**Option 2 - Building locally**
1. Set environment variables
```bash
export CUDA_HOME=/path/to/cuda
export PATH=$CUDA_HOME/bin:$PATH
```
2. Build the runtime environment
```bash
bash build.sh
```
This script installs dependencies and prepares the benchmark environment.

## ▶️ Running Experiments
1. Set environment variables
```bash
export CUDA_HOME=/path/to/cuda
export PATH=$CUDA_HOME/bin:$PATH
export root=/absolute/path/to/hexcute-bench
```
2. Enter the scripts directory
```bash
cd scripts
```
> Note: These scripts lock GPU frequencies for reproducibility and require the `sudo` privilege when run on the host machine. Inside the container, the privilege is granted via the --privileged option.

3. Run the benchmarks  
A100 kernel performance (approximately 5 hours)
```bash
bash run_a100.sh
```
H100 kernel performance
```bash
bash run_h100.sh
```
Mixed-type MoE evaluation + ablation
```bash
bash run_moe.sh
```
Mamba selective scan evaluation
```bash
bash run_scan.sh
```
> Note: When running outside Docker (i.e., on the host machine), you must provide the `--host` argument to the benchmark scripts. When using the provided Docker image, `--host` is **not** needed since the scripts default to the container environment.

## 📊 Generating Final Results
After all benchmarks finish:

```bash
bash parse_results.sh
```
This script moves the plots into the `hexcute_results/` directory.

Outputs include:
- LaTeX source code for kernel performance table (equivalent to Table II)
To convert the source code into the `.pdf` format, run the command below (`pdflatex` is required).

```bash
pdflatex Table_II.tex
```
- Kernel performance plots (Figures 24–29)

- Mixed-type MoE evaluation (Figures 11 and 12)

- Mamba scan evaluation (Figure 21)

- Cost model accuracy evaluation (Figure 20)

Results may vary slightly due to system noise, but relative performance trends should match the paper.
