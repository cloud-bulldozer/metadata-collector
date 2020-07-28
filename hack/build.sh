#!/bin/bash

REGISTRY=quay.io
ORG=cloud-bulldozer
REPOSITORY=backpack
TAG=latest

IMAGE=${REGISTRY}/${ORG}/${REPOSITORY}:${TAG}
podman build --pull-always --no-cache -f Dockerfile -t ${IMAGE}
podman push ${IMAGE}
