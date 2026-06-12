#!/bin/bash
LOCK_FILE="/workspace/.post_start_completed"

if [ -f "$LOCK_FILE" ]; then
    exit 0
fi

echo "========================================
✅ Blackwell Setup Verification
========================================"

# Wait for ComfyUI
for i in {1..30}; do
    if [ -d "/workspace/ComfyUI" ] && [ -f "/workspace/ComfyUI/main.py" ]; then
        break
    fi
    sleep 10
done

cd /workspace/ComfyUI 2>/dev/null || {
    echo "❌ ComfyUI directory not found"
    touch "$LOCK_FILE"
    exit 0
}

python -c "
import torch
print('Torch:', torch.__version__)
print('CUDA:', torch.version.cuda)
print('Device:', torch.cuda.get_device_name(0))
arch = torch.cuda.get_arch_list() if torch.cuda.is_available() else []
print('Arch list:', arch)
print('sm_120 supported:', any('sm_120' in a or '12.0' in a for a in arch))
" 2>&1 | tee /workspace/setup.log

echo "
🚀 ComfyUI ready on port 8188
Jupyter on 8888
→ Use KJNodes 'Patch Sage Attention' node
"

touch "$LOCK_FILE"
