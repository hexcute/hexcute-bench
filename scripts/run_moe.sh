#!/bin/bash
# run on hopper
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
  sudo nvidia-smi -lgc 2000
else
  nvidia-smi -pm 1
  nvidia-smi -lgc 2000
  root="/"
fi
# run moe
source $root/workspace/vllm_v9_2/bin/activate
python3 $root/workspace/hidet/examples/cute/test_moe.py
deactivate
# run moe v8.2
source $root/workspace/vllm_v8_2/bin/activate
python3 $root/workspace/hidet/examples/cute/test_moe_v8.2.py
deactivate
if [ "$DOCKER" == false ]; then
  sudo nvidia-smi -rgc
else
  nvidia-smi -rgc
fi
