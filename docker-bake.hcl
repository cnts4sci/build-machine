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

variable "SYSTEM_BASE_IMAGE" {
  default = "ubuntu:20.04"
}

variable "TARGETS" {
  default = ["openmpi", "lapack"]
}

# TAGS for softwares
variable "OPENMPI_VERSION" {

}
variable "LAPACK_VERSION" {
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

target "build-machine" {
  tags = tags("bm")
  context = "build-machine"
  contexts = {
      base-image = "docker-image://${SYSTEM_BASE_IMAGE}"
  }
  platforms = "${PLATFORMS}"
}

target "openmpi" {
  tags = tags("bm-openmpi")
  context = "openmpi"
  contexts = {
    base-image = "target:build-machine"
  }
  platforms = "${PLATFORMS}"
  args = {
    OPENMPI_VERSION = "${OPENMPI_VERSION}"
  }
}

target "lapack" {
  tags = tags("bm-lapack")
  context = "lapack"
  contexts = {
    base-image = "target:build-machine"
  }
  platforms = "${PLATFORMS}"
  args = {
    LAPACK_VERSION = "${LAPACK_VERSION}"
  }
}

