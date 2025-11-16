#!/bin/bash
set -e

DOCKER=true
for arg in "$@"; do
  if [ "$arg" == "--host" ]; then
    DOCKER=false
    break
  fi
done

if [ "$DOCKER" == true ]; then
  root="/"
fi
source $root/workspace/vllm_v9_2/bin/activate 
python3 $root/workspace/hidet/examples/cute/tablegen.py
mkdir -p ../hexcute_results
cp ./matmul_a100.pdf ../hexcute_results/figure_24.pdf
cp ./attn_forward.pdf ../hexcute_results/figure_25.pdf
cp ./decoding_a100.pdf ../hexcute_results/figure_26.pdf
cp ./warp_specialized_gemm_expt.pdf ../hexcute_results/figure_27.pdf
cp ./w8a8_scaled_mm.pdf ../hexcute_results/figure_28.pdf
cp ./attention_flash3.pdf ../hexcute_results/figure_29.pdf
cp ./Table_II.tex ../hexcute_results/Table_II.tex
cp ./cost_model_accuracy.pdf ../hexcute_results/figure_20.pdf
cp ./moewna16_performance_plot.pdf ../hexcute_results/figure_11.pdf
cp ./ablation_study.pdf ../hexcute_results/figure_12.pdf
cp ./mamba_scan.pdf ../hexcute_results/figure_21.pdf
