group "default" {
  targets = ["comfyui"]
}

target "comfyui" {
  context    = "."
  dockerfile = "Dockerfile"
  tags       = ["vixenquest/comfyui-rtx-pro-6000-flux2klein:latest"]
  platforms  = ["linux/amd64"]
}
