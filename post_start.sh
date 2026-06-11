#!/bin/bash
cd /workspace/ComfyUI 2>/dev/null || { echo "ComfyUI not found"; exit 0; }

echo "========================================
✅ Blackwell Setup Verification
========================================"

python -c "
import torch
print('Torch:', torch.__version__)
print('CUDA:', torch.version.cuda)
print('Device:', torch.cuda.get_device_name(0) if torch.cuda.is_available() else 'No GPU')
print('Arch list:', torch.cuda.get_arch_list() if torch.cuda.is_available() else 'N/A')
print('sm_120 supported:', any('12.0' in arch for arch in (torch.cuda.get_arch_list() if torch.cuda.is_available() else [])))
" 2>&1 | tee /workspace/setup.log

echo "
🚀 ComfyUI ready on port 8188
Jupyter on 8888
→ Use KJNodes 'Patch Sage Attention' node (NO --use-sage-attention flag on Blackwell)
"
