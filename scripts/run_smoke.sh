#!/bin/bash

set -e

DOCKER=true
for arg in "$@"; do
  if [ "$arg" == "--host" ]; then
    DOCKER=false
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
python3 $root/workspace/hidet/examples/cute/benchmark_attention.py --batch-size 1 --num-heads 32 --num-heads-k 32 --head-size 128 --seqlen-q 4096 --seqlen-k 4096 --cache-dir attention --debug
deactivate
if [ "$DOCKER" = false ]; then
  sudo nvidia-smi -rgc
else
  nvidia-smi -rgc
fi
