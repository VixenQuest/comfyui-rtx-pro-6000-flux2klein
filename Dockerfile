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

# IMPORTANT: Do NOT install ComfyUI into /workspace at build time.
# RunPod mounts a volume over /workspace at runtime, which would hide
# anything baked there. We install to /ComfyUI and sync at startup.
WORKDIR /

# System dependencies (ninja needed if flash-attn has to compile)
RUN apt-get update && apt-get install -y --no-install-recommends \
    aria2 git curl wget unzip ninja-build && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Upgrade pip (don't use the /workspace pip cache at build time)
RUN PIP_CACHE_DIR= python -m pip install --no-cache-dir --upgrade pip setuptools wheel packaging ninja

# Ensure Blackwell-compatible PyTorch stack
RUN PIP_CACHE_DIR= pip install --no-cache-dir \
    torch torchvision torchaudio --index-url https://download.pytorch.org/whl/cu128 && \
    PIP_CACHE_DIR= pip install --no-cache-dir \
    triton \
    bitsandbytes \
    transformers accelerate \
    xformers || true

# SageAttention
RUN PIP_CACHE_DIR= pip install --no-cache-dir sageattention==2.2.0 || \
    echo "⚠️ SageAttention install failed — use KJNodes Patch node"

# Flash Attention (optional — may take a long time if no prebuilt wheel)
RUN PIP_CACHE_DIR= pip install --no-cache-dir flash-attn --no-build-isolation || true

# ComfyUI + Core Nodes → installed to /ComfyUI (synced to /workspace at boot)
RUN git clone https://github.com/comfyanonymous/ComfyUI.git /ComfyUI && \
    cd /ComfyUI && PIP_CACHE_DIR= pip install --no-cache-dir -r requirements.txt && \
    git clone https://github.com/ltdrdata/ComfyUI-Manager.git custom_nodes/ComfyUI-Manager && \
    git clone https://github.com/kijai/ComfyUI-KJNodes.git custom_nodes/ComfyUI-KJNodes && \
    git clone https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git custom_nodes/ComfyUI-VideoHelperSuite && \
    PIP_CACHE_DIR= pip install --no-cache-dir -r custom_nodes/ComfyUI-Manager/requirements.txt && \
    PIP_CACHE_DIR= pip install --no-cache-dir -r custom_nodes/ComfyUI-KJNodes/requirements.txt && \
    PIP_CACHE_DIR= pip install --no-cache-dir -r custom_nodes/ComfyUI-VideoHelperSuite/requirements.txt

# Supporting scripts
# NOTE: copied as /custom_start.sh so we do NOT overwrite RunPod's /start.sh,
# which is what launches JupyterLab, nginx, and SSH.
COPY start.sh /custom_start.sh
COPY post_start.sh /post_start.sh
RUN chmod +x /custom_start.sh /post_start.sh

EXPOSE 8188 8888 22

CMD ["/custom_start.sh"]
