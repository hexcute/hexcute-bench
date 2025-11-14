#!/bin/bash
root=$(pwd)
mkdir -p $root/workspace

git clone https://github.com/hexcute/vllm.git $root/workspace/vllm_v8.2
git clone https://github.com/hexcute/vllm.git $root/workspace/vllm_v9.2
# TODO: replace this with open source hidet
git clone git@github.com:hexcute/hidet.git $root/workspace/hidet

cd $root/workspace

python3 -m venv vllm_v8_2
python3 -m venv vllm_v9_2

source $root/workspace/vllm_v8_2/bin/activate
pip install pytest numpy matplotlib
cd $root/workspace/hidet
git checkout cgorebuttal
mkdir -p build
cd build
cmake ..
make -j$(nproc)
cd ..
pip install -e .
pip install flash-attn==2.7.3 --no-build-isolation
pip install flashinfer-python==0.2.10

cd $root/workspace/vllm_v8.2
git checkout cgoae_v8.2
export VLLM_COMMIT=10b34e36b9be7f68e236ec9c78425b6304be4cd1
export VLLM_PRECOMPILED_WHEEL_LOCATION=https://wheels.vllm.ai/${VLLM_COMMIT}/vllm-1.0.0.dev-cp38-abi3-manylinux1_x86_64.whl
pip install -e .

pip install xformers==0.0.29.post2
deactivate

source $root/workspace/vllm_v9_2/bin/activate
pip install pytest numpy matplotlib
cd $root/workspace/hidet
git checkout cgorebuttal
mkdir -p build
cd build
cmake ..
make -j$(nproc)
cd ..
pip install -e .

cd $root/workspace/vllm_v9.2
git checkout cgoae_v9.2
export VLLM_COMMIT=9fb52e523abf7bdaf7e60cf2971edb5a1b13dc08
export VLLM_PRECOMPILED_WHEEL_LOCATION=https://wheels.vllm.ai/${VLLM_COMMIT}/vllm-1.0.0.dev-cp38-abi3-manylinux1_x86_64.whl
pip install -e .

pip install pytest numpy matplotlib

pip install flash-attn==2.8.2 --no-build-isolation
pip install flashinfer-python==0.2.10

# build for flash-attention3
git clone git@github.com:Dao-AILab/flash-attention.git $root/workspace/flash-attention
cd $root/workspace/flash-attention/hopper
git checkout v2.8.2
export FLASH_ATTENTION_DISABLE_FP8=TRUE 
export FLASH_ATTENTION_DISABLE_SM80=TRUE 
export FLASH_ATTENTION_DISABLE_BACKWARD=TRUE 
export FLASH_ATTENTION_DISABLE_PAGEDKV=TRUE
export FLASH_ATTENTION_DISABLE_APPENDKV=TRUE
export FLASH_ATTENTION_DISABLE_SOFTCAP=TRUE
export MAX_JOBS=10 
python3 setup.py install

pip install transformers==4.50.1
deactivate

mkdir hexcute_results
