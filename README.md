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
- Blackwell-specific optimizations (`TORCH_CUDA_ARCH_LIST` incl. `12.0`, memory settings)
- ComfyUI auto-launches on port 8188 at pod start
- RunPod services (JupyterLab, nginx, SSH) preserved — the template does **not**
  overwrite RunPod's `/start.sh`

---

### How startup works

1. `CMD ["/custom_start.sh"]` runs our entrypoint.
2. `/custom_start.sh` backgrounds `/post_start.sh`, then `exec`s RunPod's
   original `/start.sh` (Jupyter, nginx, SSH) in the foreground.
3. `/post_start.sh`:
   - Prints Torch/CUDA/sm_120 verification to `/workspace/setup.log`
   - **First boot only**: copies the baked-in install from `/ComfyUI` to
     `/workspace/ComfyUI` (your volume), so models/outputs/custom nodes persist
     across restarts. Existing installs are left untouched.
   - Launches ComfyUI: `python main.py --listen 0.0.0.0 --port 8188`
     (log: `/workspace/comfyui.log`)

> **Why `/ComfyUI` in the image?** RunPod mounts your volume over `/workspace`
> at runtime, hiding anything baked there. The image keeps a pristine copy at
> `/ComfyUI` and syncs it into the volume on first boot.

---

### Deployment on Runpod

1. **Build & Push** the image:
   ```bash
   docker buildx bake
   # or:
   docker build -t vixenquest/comfyui-rtx-pro-6000-flux2klein:latest .
   docker push vixenquest/comfyui-rtx-pro-6000-flux2klein:latest
   ```

2. **Create a Runpod template** pointing to the image. Expose HTTP ports
   `8188, 8888` and TCP port `22`.

3. **Deploy a pod** (RTX PRO 6000 Blackwell). On first boot, allow a minute
   or two for the ComfyUI copy before port 8188 responds. Check
   `/workspace/comfyui.log` if it seems slow.

---

### Notes

- **SageAttention on Blackwell**: do NOT use the `--use-sage-attention` launch
  flag. Use the KJNodes **Patch Sage Attention** node inside your workflow.
- **Updating ComfyUI/nodes after a rebuild**: the workspace copy persists, so a
  new image won't replace `/workspace/ComfyUI`. Either update in place via
  ComfyUI-Manager, or delete `/workspace/ComfyUI` to re-sync the fresh copy
  (back up models first — keep them in `/workspace/ComfyUI/models`).
- Verification output is written to `/workspace/setup.log` on every boot.
