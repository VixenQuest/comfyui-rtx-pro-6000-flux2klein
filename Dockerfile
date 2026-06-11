# ==============================================================================
# ComfyUI-Blackwell — RTX PRO 6000 Optimized Template
# Base: runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404
# ==============================================================================

ARG BASE_IMAGE=runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404
FROM ${BASE_IMAGE}

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV DEBIAN_FRONTEND=noninteractive \
    PYTHONUNBUFFERED=True \
    HF_HOME="/workspace/.cache/huggingface" \
    PIP_CACHE_DIR="/workspace/.cache/pip" \
    WORKSPACE=/workspace \
    TORCH_CUDA_ARCH_LIST="8.0;8.6;8.9;9.0;12.0" \
    PYTORCH_CUDA_ALLOC_CONF="expandable_segments:True"

WORKDIR ${WORKSPACE}

# System dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    aria2 git curl wget unzip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip
RUN python -m pip install --upgrade pip setuptools wheel

# Ensure Blackwell-compatible PyTorch
RUN pip install --no-cache-dir \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128 \
    triton \
    bitsandbytes \
    transformers accelerate \
    xformers || true

# SageAttention
RUN pip install --no-cache-dir sageattention==2.2.0 || \
    echo "⚠️ SageAttention install failed — use KJNodes Patch node"

# Flash Attention (optional)
RUN pip install --no-cache-dir flash-attn --no-build-isolation || true

# ComfyUI + Core Nodes
RUN git clone https://github.com/comfyanonymous/ComfyUI.git && \
    cd ComfyUI && pip install -r requirements.txt && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git custom_nodes/ComfyUI-KJNodes && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git custom_nodes/ComfyUI-VideoHelperSuite && \
    cd custom_nodes/ComfyUI-Manager && pip install -r requirements.txt && \
    cd ../ComfyUI-KJNodes && pip install -r requirements.txt

# Supporting scripts
COPY start.sh /start.sh
COPY post_start.sh /post_start.sh
RUN chmod +x /start.sh /post_start.sh

EXPOSE 8188 8888 22

CMD ["/start.sh"]
