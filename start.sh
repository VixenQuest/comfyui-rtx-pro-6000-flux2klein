#!/bin/bash
set -e

echo "🚀 Starting Runpod services (nginx, SSH, Jupyter)..."
exec /start.sh &

echo "🔄 Running ComfyUI post-start setup..."
/post_start.sh &
