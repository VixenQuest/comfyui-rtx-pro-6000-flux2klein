# ComfyUI RTX PRO 6000 Blackwell + Flux2-Klein Template

Optimized Docker template for **RTX PRO 6000 Blackwell** (sm_120) on Runpod.

### Features
- **Base**: `runpod/pytorch:1.0.2-cu1281-torch280-ubuntu2404`
- **CUDA**: 12.8.1
- **Python**: 3.12
- Pre-installed:
  - SageAttention 2.2.0
  - Triton, bitsandbytes, xformers
  - Flash Attention (optional)
  - ComfyUI + Manager + KJNodes + VideoHelperSuite
- Blackwell-specific optimizations (`TORCH_CUDA_ARCH_LIST`, memory settings)
- Proper Runpod startup (JupyterLab, nginx, SSH)

---

### Deployment on Runpod

1. **Build & Push** the image:
   ```bash
   docker build -t vixenquest/comfyui-rtx-pro-6000-flux2klein:latest .
   docker push vixenquest/comfyui-rtx-pro-6000-flux2klein:latest
