#!/bin/bash
set -euo pipefail

# ===== Config =====
MAJOR=10
UBI_IMAGE="registry.access.redhat.com/ubi${MAJOR}/ubi"
IMAGE_PREFIX="build-rhsm:ol${MAJOR}"

# find latest upstream version of subcription-manager RPM
RHSM_NVR=$(docker run --rm -i "${UBI_IMAGE}" \
  rpm -q --queryformat="%{VERSION}:%{RELEASE}" subscription-manager)

RHSM_CERTS_VERSION=$(docker run --rm -i "${UBI_IMAGE}" \
  rpm -q --queryformat="%{VERSION}" subscription-manager-rhsm-certificates)

RHSM_VERSION=${RHSM_NVR%%:*}
RHSM_REL=${RHSM_NVR#*:}
RHSM_RELEASE=${RHSM_REL%%.*}
RHSM_DIST=${RHSM_REL#*.}

# find build tag
if IMG_VER=$(git rev-parse --short=12 HEAD 2>/dev/null); then
  :
else
  IMG_VER=$(date -u +%Y%m%d%H%M%S)
fi

BUILD_IMAGE="${IMAGE_PREFIX}-${IMG_VER}"
CONTAINER_NAME="build-rhsm-ol${MAJOR}-${IMG_VER}"

# build image
if ! docker image inspect "${BUILD_IMAGE}" &>/dev/null; then
  docker build -t "${BUILD_IMAGE}" .
fi

# build packages in a container
docker run --rm -it \
  --name "${CONTAINER_NAME}" \
  -v "$PWD/gpg:/gpg" \
  -v "$PWD/output:/output" \
  -e RHSM_VERSION="$RHSM_VERSION" \
  -e RHSM_RELEASE="$RHSM_RELEASE" \
  -e RHSM_CERTS_VERSION="$RHSM_CERTS_VERSION" \
  -e RHSM_DIST="$RHSM_DIST" \
  -e GPG_NAME_EMAIL \
  "${BUILD_IMAGE}"
