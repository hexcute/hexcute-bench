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

Hexcute provides:

- A tile-level GPU programming model with explicit control over shared memory and registers  
- Automated layout synthesis for register tensors and shared-memory tensors  
- Constraint-based instruction selection and layout propagation  
- Compatibility with warp specialization and modern GPU collective instructions  

This artifact enables reproduction of:

- Kernel performance benchmarks (GEMM, Attention, FP8 GEMM, warp-specialized kernels)  
- Mixed-type MoE evaluation  
- Mamba selective scan evaluation  
- Analytical cost model accuracy tests  
- All plots in Figures 11, 12, 20, 21, and 24–29 of the paper  

---

## 📋 System Requirements

### Hardware
- x86-64 Linux host  
- ≥ 20 CPU cores  
- ≥ 100 GB RAM  
- ≥ 100 GB free disk space  
- NVIDIA A100 PCIe (80 GB)  
- NVIDIA H100 PCIe (80 GB)

### Software
- CUDA Toolkit ≥ 12.6  
- CMake ≥ 3.19  
- Python ≥ 3.10 (Python 3.12 recommended)  
- Ubuntu 20.04+ (24.04 recommended)  
- NVIDIA driver ≥ 550  
- Optional: Docker 24+  

---

## 📥 Getting the Artifact

1. Clone the repository:

```bash
git clone https://github.com/hexcute/hexcute-bench
cd hexcute-bench
```
## ⚙️ Installation
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
(Docker users may build the provided Docker image instead.)

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
Note: These scripts lock GPU frequency for reproducibility and require `sudo` privileges.

3. Run the benchmarks
A100 kernel performance (≈ 5 hours)
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
## 📊 Generating Final Results
After all benchmarks finish:

```bash
bash parse_results.sh
```
This script collects all raw logs and plots and moves them into the `hexcute_results/` directory.

Outputs include:
- Latex source code for kernel performance table (equivalent to Table II)
To convert the source code into the `.pdf` format, run the command below (`pdflatex` is required).

```bash
pdflatex performance_and_programmability.tex
```
- Kernel performance plots (Figures 24–29)

- Mixed-type MoE evaluation (Figures 11 and 12)

- Mamba scan evaluation (Figure 21)

- Cost model accuracy evaluation (Figure 20)

Results may vary slightly due to system noise, but relative performance trends should match the paper.
