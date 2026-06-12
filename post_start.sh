#!/bin/bash
# Prevent multiple runs
if [ -f /workspace/.post_start_completed ]; then
    exit 0
fi

cd /workspace/ComfyUI 2>/dev/null || { echo "ComfyUI directory not found"; exit 0; }

echo "========================================
✅ Blackwell Setup Verification
========================================"

python -c "
import torch
print('Torch:', torch.__version__)
print('CUDA:', torch.version.cuda)
print('Device:', torch.cuda.get_device_name(0))
arch_list = torch.cuda.get_arch_list() if torch.cuda.is_available() else []
print('Arch list:', arch_list)
print('sm_120 supported:', any('sm_120' in arch or '12.0' in arch for arch in arch_list))
"

echo "
🚀 ComfyUI ready on port 8188
Jupyter on 8888
→ Use KJNodes 'Patch Sage Attention' node (NO --use-sage-attention flag on Blackwell)
"

# Mark as completed
touch /workspace/.post_start_completed
