target "default" {
  dockerfile = "Dockerfile"
  tags = [
    "aptauyan/comfyui-rtx-pro-6000-flux2klein:latest",
    "aptauyan/comfyui-rtx-pro-6000-flux2klein:${TAG:-latest}"
  ]
  platforms = ["linux/amd64"]
}
