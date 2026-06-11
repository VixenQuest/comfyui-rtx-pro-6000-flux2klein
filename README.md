# ComfyUI RTX PRO 6000 Blackwell Template

**Optimized Docker template for Runpod on RTX PRO 6000 Blackwell (sm_120) with CUDA 12.8 + Python 3.12**

## Features
- Base: Official Runpod PyTorch cu1281-torch280-ubuntu2404
- Pre-installed: ComfyUI + Manager + KJNodes + VideoHelperSuite
- SageAttention, Triton, Flash Attention (Blackwell compatible)
- JupyterLab + Terminal + SSH + nginx ready
- Optimized env vars for Blackwell stability

## Deployment on Runpod
1. Build and push this image to Docker Hub
2. Create custom template using your image
3. Set filters: CUDA 12.8, RTX PRO 6000
4. Container Disk: 500GB+

## Usage
- ComfyUI: Port 8188
- Jupyter: Port 8888
- Use KJNodes Patch Sage Attention node for best performance

Later extensions will include Klein models/LoRAs.
