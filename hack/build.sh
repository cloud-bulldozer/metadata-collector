#!/bin/bash

REGISTRY=${REGISTRY:-quay.io}
ORG=${ORG:-cloud-bulldozer}
REPOSITORY=${REPOSITORY:-backpack}
TAG=${TAG:-latest}

IMAGE=${REGISTRY}/${ORG}/${REPOSITORY}:${TAG}
echo "Building backpack into ${IMAGE}"
podman build --pull-always --no-cache -f Dockerfile -t ${IMAGE}
echo "Pushing backpack to ${IMAGE}"
podman push ${IMAGE}
