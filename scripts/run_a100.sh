#!/bin/bash
# run on a100

set -e

DOCKER=false
for arg in "$@"; do
  if [ "$arg" == "--docker" ]; then
    DOCKER=true
    break
  fi
done

if [ "$DOCKER" = false ]; then
  sudo nvidia-smi -pm 1
  sudo nvidia-smi -lgc 1410
else
  nvidia-smi -pm 1
  nvidia-smi -lgc 1410
  root="/"
fi
source $root/workspace/vllm_v9_2/bin/activate
python3 $root/workspace/hidet/examples/cute/benchmark_attention.py --batch-size 1 --num-heads 32 --num-heads-k 32 --head-size 64 --seqlen-q 2048 --seqlen-k 2048 --cache-dir attn_forward --debug --output attn_forward.txt 
deactivate
source $root/workspace/vllm_v8_2/bin/activate
python3 $root/workspace/hidet/examples/cute/benchmark_matmul_hidet_cublas.py
python3 $root/workspace/hidet/examples/cute/benchmark_flash_decoding.py --batch-size 1 --num-heads 16 --num-heads-k 16 --head-size 128 --seqlen-k 1024 --cache-dir decoding_a100 --output decoding_a100.txt
python3 $root/workspace/hidet/examples/cute/benchmark_matmul_hidet_cost_model_accuracy.py
deactivate
if [ "$DOCKER" = false ]; then
  sudo nvidia-smi -rgc
else
  nvidia-smi -rgc
fi
