# docker-bake.hcl
variable "VERSION" {
}

variable "ORGANIZATION" {
  default = "cnts4sci"
}

variable "REGISTRY" {
  default = "ghcr.io"
}

variable "PLATFORMS" {
  default = ["linux/amd64"]
}

variable "BASE_IMAGE" {
  default = "ubuntu:20.04"
}

variable "RUNTIME_BASE_IMAGE" {
  default = "ubuntu:20.04"
}

variable "TARGETS" {
  default = ["openmpi"]
}

# TAGS for softwares
variable "OPENMPI_VERSION" {
}

function "tags" {
  params = [image]
  result = [
    "${REGISTRY}/${ORGANIZATION}/${image}"
  ]
}

group "default" {
  targets = "${TARGETS}"
}

target "openmpi" {
  tags = tags("openmpi")
  context = "openmpi"
  platforms = "${PLATFORMS}"
  args = {
    BASE_IMAGE = "${BASE_IMAGE}" 
    RUNTIME_BASE_IMAGE = "${RUNTIME_BASE_IMAGE}"
    OPENMPI_VERSION = "${OPENMPI_VERSION}"
  }
}

