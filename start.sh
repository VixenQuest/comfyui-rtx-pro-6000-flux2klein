#!/bin/bash
# Custom entrypoint. RunPod's original /start.sh (Jupyter, nginx, SSH) is
# intact because our Dockerfile copies this file as /custom_start.sh.

echo "🔄 Running ComfyUI post-start setup in background..."
/post_start.sh &

echo "🚀 Starting RunPod services (nginx, SSH, Jupyter)..."
# exec in the FOREGROUND — this keeps the container alive.
exec /start.sh
