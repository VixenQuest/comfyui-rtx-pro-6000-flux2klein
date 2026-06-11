target "default" {
  dockerfile = "Dockerfile"
  tags = ["yourusername/comfyui-rtx-pro-6000-blackwell:latest"]
  platforms = ["linux/amd64"]
}
