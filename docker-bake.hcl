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
  default = ["bm", "bm-openmpi", "bm-lapack"]
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

target "bm" {
  tags = tags("bm")
  context = "bm"
  contexts = {
      base-image = "docker-image://${SYSTEM_BASE_IMAGE}"
  }
  platforms = "${PLATFORMS}"
}

target "bm-openmpi" {
  tags = tags("bm-openmpi")
  context = "bm-openmpi"
  contexts = {
    base-image = "target:bm"
  }
  platforms = "${PLATFORMS}"
  args = {
    OPENMPI_VERSION = "${OPENMPI_VERSION}"
  }
}

target "bm-lapack" {
  tags = tags("bm-lapack")
  context = "bm-lapack"
  contexts = {
    base-image = "target:bm"
  }
  platforms = "${PLATFORMS}"
  args = {
    LAPACK_VERSION = "${LAPACK_VERSION}"
  }
}

