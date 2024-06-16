#!/bin/bash

set -euo pipefail

# Extract image names together with their sha256 digests
# from the docker/bake-action metadata output.
# These together uniquely identify newly built images.

# The input to this script is a JSON string passed via BAKE_METADATA env variable
# Here's example input (trimmed to relevant bits):
# BAKE_METADATA: {
#    "bm": {
#      "containerimage.descriptor": {
#        "mediaType": "application/vnd.docker.distribution.manifest.v2+json",
#        "digest": "sha256:8e57a52b924b67567314b8ed3c968859cad99ea13521e60bbef40457e16f391d",
#        "size": 6170,
#      },
#      "containerimage.digest": "sha256:8e57a52b924b67567314b8ed3c968859cad99ea13521e60bbef40457e16f391d",
#      "image.name": "ghcr.io/containers4hpc/bm"
#    },
#    "bm-openmpi": {
#      "image.name": "ghcr.io/containers4hpc/bm-openmpi"
#      "containerimage.digest": "sha256:85ee91f61be1ea601591c785db038e5899d68d5fb89e07d66d9efbe8f352ee48",
#      "...": ""
#    },
#    "bm-lapack": {
#      "image.name": "ghcr.io/containers4hpc/bm-lapack"
#      "containerimage.digest": "sha256:778a87878eu601591c785db038e5899d68d5fb89e07d66d9efbe8f352ee48",
#      "...": ""
#    }
#  }
#
# Example output (real output is on one line):
#
# images={
#   "BM_IMAGE": "ghcr.io/cnts4sci/bm@sha256:8e57a52b924b67567314b8ed3c968859cad99ea13521e60bbef40457e16f391d",
#   "BM_OPENMPI_IMAGE": "ghcr.io/cnts4sci/bm-openmpi@sha256:85ee91f61be1ea601591c785db038e5899d68d5fb89e07d66d9efbe8f352ee48",
#   "BM_LAPACK_IMAGE": "ghcr.io/cnts4sci/bm-lapack@sha256:85ee91f61be1ea601591c785db038e5899d68d5fb89e07d66d9efbe8f352ee48",
# }
#
# This json output is later turned to environment variables using fromJson() GHA builtin
# (e.g. BASE_IMAGE=ghcr.io/containers4hpc/base@sha256:8e57a52b...)
# and these are in turn read in the docker-compose.<target>.yml files for tests.

if [[ -z ${BAKE_METADATA-} ]];then
    echo "ERROR: Environment variable BAKE_METADATA is not set!"
    exit 1
fi

images=$(echo "${BAKE_METADATA}" | jq -c '. as $base |[to_entries[] |{"key": (.key|ascii_upcase|sub("-"; "_"; "g") + "_IMAGE"), "value": [(.value."image.name"|split(",")[0]),.value."containerimage.digest"]|join("@")}] |from_entries')
echo "images=$images"
