#!/bin/bash
set -e

echo "🚀 Starting official Runpod services..."
/start.sh &

echo "⏳ Waiting for ComfyUI to be ready..."
for i in {1..40}; do
    if [ -d "/workspace/ComfyUI" ] && [ -f "/workspace/ComfyUI/main.py" ]; then
        echo "✅ ComfyUI directory found"
        break
    fi
    sleep 8
done

echo "🔄 Running post-start setup once..."
/post_start.sh &

echo "✅ Container startup completed - keeping alive"
wait
