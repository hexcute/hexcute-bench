#!/bin/bash
source $root/workspace/vllm_v9_2/bin/activate 
python3 $root/workspace/hidet/examples/cute/tablegen.py
mkdir -p $root/hexcute_results
cp ./*.txt $root/hexcute_results
cp ./*.pdf $root/hexcute_results
