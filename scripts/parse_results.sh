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
if [ -f ./matmul_a100.pdf ]; then
  cp ./matmul_a100.pdf ../hexcute_results/figure_24.pdf
fi
if [ -f ./attn_forward.pdf ]; then
  cp ./attn_forward.pdf ../hexcute_results/figure_25.pdf
fi
if [ -f ./decoding_a100.pdf ]; then
  cp ./decoding_a100.pdf ../hexcute_results/figure_26.pdf
fi
if [ -f ./warp_specialized_gemm_expt.pdf ]; then
  cp ./warp_specialized_gemm_expt.pdf ../hexcute_results/figure_27.pdf
fi
if [ -f ./w8a8_scaled_mm.pdf ]; then
  cp ./w8a8_scaled_mm.pdf ../hexcute_results/figure_28.pdf
fi
if [ -f ./attention_flash3.pdf ]; then
  cp ./attention_flash3.pdf ../hexcute_results/figure_29.pdf
fi
if [ -f ./Table_II.tex ]; then
  cp ./Table_II.tex ../hexcute_results/Table_II.tex
fi
if [ -f ./cost_model_accuracy.pdf ]; then
  cp ./cost_model_accuracy.pdf ../hexcute_results/figure_20.pdf
fi
if [ -f ./moewna16_performance_plot.pdf ]; then
  cp ./moewna16_performance_plot.pdf ../hexcute_results/figure_11.pdf
fi
if [ -f ./ablation_study.pdf ]; then
  cp ./ablation_study.pdf ../hexcute_results/figure_12.pdf
fi
if [ -f ./mamba_scan.pdf ]; then
  cp ./mamba_scan.pdf ../hexcute_results/figure_21.pdf
fi      