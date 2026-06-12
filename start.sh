#!/bin/bash
set -e

echo "🚀 Starting official Runpod services (nginx, SSH, Jupyter)..."

# Run the original Runpod entrypoint in background
/start.sh &

echo "🔄 Running ComfyUI post-start setup..."
/post_start.sh &

# Keep the container alive
wait
