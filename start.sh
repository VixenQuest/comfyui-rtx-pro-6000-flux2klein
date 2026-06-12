#!/bin/bash
set -e

echo "🚀 Starting official Runpod services (nginx, SSH, Jupyter)..."
/start.sh &

echo "🔄 Running ComfyUI post-start setup (once)..."
/post_start.sh &

wait
