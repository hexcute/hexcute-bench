FROM nvcr.io/nvidia/pytorch:24.10-py3

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    build-essential \
    net-tools \
    vim \
    curl \
    git \
    tmux \
    mc \
    zsh \
    python3.10-venv \
    apt-transport-https \
    ca-certificates \
    openssh-server \
    gnupg && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN apt update && \
    apt-get install -y --no-install-recommends \
    texlive-latex-base \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-latex-extra \
    && apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl https://packages.cloud.google.com/apt/doc/apt-key.gpg \
    | gpg --dearmor -o /usr/share/keyrings/cloud.google.gpg && \
    echo "deb [signed-by=/usr/share/keyrings/cloud.google.gpg] https://packages.cloud.google.com/apt cloud-sdk main" \
    | tee -a /etc/apt/sources.list.d/google-cloud-sdk.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    google-cloud-cli && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*


WORKDIR /workspace

RUN git clone https://github.com/hexcute/vllm.git /workspace/vllm_v8.2
RUN git clone https://github.com/hexcute/vllm.git /workspace/vllm_v9.2
RUN git clone https://github.com/hexcute/hidet.git /workspace/hidet

RUN python3 -m venv /workspace/vllm_v8_2
RUN python3 -m venv /workspace/vllm_v9_2

RUN rm -rf /workspace/hidet/build
WORKDIR /workspace/hidet/build
RUN cmake .. && make -j$(nproc)

WORKDIR /workspace/hidet
RUN git checkout cgorebuttal
RUN source /workspace/vllm_v8_2/bin/activate && pip install pytest numpy matplotlib
RUN source /workspace/vllm_v8_2/bin/activate && pip install -e .

WORKDIR /workspace/vllm_v8.2
RUN git checkout cgoae_v8.2
RUN source /workspace/vllm_v8_2/bin/activate && \
    export VLLM_COMMIT=10b34e36b9be7f68e236ec9c78425b6304be4cd1 && \
    export VLLM_PRECOMPILED_WHEEL_LOCATION=https://wheels.vllm.ai/${VLLM_COMMIT}/vllm-1.0.0.dev-cp38-abi3-manylinux1_x86_64.whl && \
    pip install -e .

RUN source /workspace/vllm_v8_2/bin/activate && \
    pip install wheel setuptools && \
    pip install flash-attn==2.7.3 && \
    pip install flashinfer-python==0.2.10

RUN source /workspace/vllm_v8_2/bin/activate && pip install xformers==0.0.29.post2
    
WORKDIR /workspace/hidet
RUN source /workspace/vllm_v9_2/bin/activate && pip install -e .
RUN source /workspace/vllm_v9_2/bin/activate && pip install pytest numpy matplotlib

WORKDIR /workspace/vllm_v9.2
RUN git checkout cgoae_v9.2
RUN source /workspace/vllm_v9_2/bin/activate && \
    export VLLM_COMMIT=9fb52e523abf7bdaf7e60cf2971edb5a1b13dc08 && \
    export VLLM_PRECOMPILED_WHEEL_LOCATION=https://wheels.vllm.ai/${VLLM_COMMIT}/vllm-1.0.0.dev-cp38-abi3-manylinux1_x86_64.whl && \
    pip install -e .

WORKDIR /workspace
RUN source /workspace/vllm_v9_2/bin/activate && \
    pip install wheel setuptools && \
    pip install flash-attn==2.8.2 --no-build-isolation && \
    pip install flashinfer-python==0.2.10

# build for flash-attention3
RUN git clone https://github.com/Dao-AILab/flash-attention.git /workspace/flash-attention
WORKDIR /workspace/flash-attention/hopper
RUN git checkout v2.8.2
RUN source /workspace/vllm_v9_2/bin/activate && \
    export FLASH_ATTENTION_DISABLE_FP8=TRUE && \
    export FLASH_ATTENTION_DISABLE_SM80=TRUE && \ 
    export FLASH_ATTENTION_DISABLE_BACKWARD=TRUE && \
    export FLASH_ATTENTION_DISABLE_PAGEDKV=TRUE && \
    export FLASH_ATTENTION_DISABLE_APPENDKV=TRUE && \
    export FLASH_ATTENTION_DISABLE_SOFTCAP=TRUE && \
    export MAX_JOBS=10 && \ 
    python3 setup.py install

# install transformers 4.50.1 for vllm_v9.2 to avoid the transformer error
WORKDIR /workspace
RUN source /workspace/vllm_v9_2/bin/activate && \
    pip install transformers==4.50.1