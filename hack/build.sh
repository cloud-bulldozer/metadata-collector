#!/bin/bash

REGISTRY=${REGISTRY:-quay.io}
ORG=${ORG:-cloud-bulldozer}
REPOSITORY=${REPOSITORY:-backpack}
TAG=${TAG:-latest}
IMAGE=${REGISTRY}/${ORG}/${REPOSITORY}:${TAG}
ARCHS=linux/amd64,linux/arm64


echo "Building backpack into ${IMAGE}"
podman build --pull-always --jobs=2 --platform=${ARCHS} --manifest ${IMAGE} .
echo "Pushing backpack to ${IMAGE}"
podman manifest push ${IMAGE} ${IMAGE}
