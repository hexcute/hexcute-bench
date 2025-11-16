#!/bin/bash
# run on a100
set -e

DOCKER=true
for arg in "$@"; do
  if [ "$arg" == "--host" ]; then
    DOCKER=false
    break
  fi
done

if [ "$DOCKER" == false ]; then
  sudo nvidia-smi -pm 1
  sudo nvidia-smi -lgc 1410
else
  nvidia-smi -pm 1
  nvidia-smi -lgc 1410
  root="/"
fi
source $root/workspace/vllm_v8_2/bin/activate
python3 $root/workspace/hidet/examples/cute/benchmark_mamba_scan.py --cache-dir ./demo_mamba_scan --output ./mamba_scan.txt
deactivate
if [ "$DOCKER" == false ]; then
  sudo nvidia-smi -rgc
else
  nvidia-smi -rgc
fi
