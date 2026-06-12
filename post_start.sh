#!/bin/bash
# Runs in the background from /custom_start.sh.

echo "========================================
✅ Blackwell Setup Verification
========================================"

mkdir -p /workspace
python -c "
import torch
print('Torch:', torch.__version__)
print('CUDA:', torch.version.cuda)
print('Device:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'No GPU')
print('Arch list:', torch.cuda.get_arch_list() if torch.cuda.is_available() else 'N/A')
print('sm_120 supported:', any('12.0' in arch for arch in (torch.cuda.get_arch_list() if torch.cuda.is_available() else [])))
" 2>&1 | tee /workspace/setup.log

# --- Sync ComfyUI from the image into the (volume-mounted) workspace ---
# RunPod mounts a volume over /workspace, so the baked-in copy lives at /ComfyUI.
if [ ! -d /workspace/ComfyUI ]; then
    if [ -d /ComfyUI ]; then
        echo "📦 First boot: copying ComfyUI into /workspace (persistent volume)..."
        cp -a /ComfyUI /workspace/ComfyUI
    else
        echo "❌ /ComfyUI not found in image — cannot continue."
        exit 1
    fi
else
    echo "📂 Existing /workspace/ComfyUI found — keeping it (models/outputs preserved)."
fi

cd /workspace/ComfyUI || { echo "ComfyUI not found"; exit 1; }

# --- Actually launch ComfyUI ---
# NOTE: no --use-sage-attention flag on Blackwell; use KJNodes 'Patch Sage Attention' node.
echo "🚀 Launching ComfyUI on port 8188..."
nohup python main.py --listen 0.0.0.0 --port 8188 \
    > /workspace/comfyui.log 2>&1 &

echo "
🚀 ComfyUI starting on port 8188 (log: /workspace/comfyui.log)
Jupyter on 8888
→ Use KJNodes 'Patch Sage Attention' node (NO --use-sage-attention flag on Blackwell)
"
