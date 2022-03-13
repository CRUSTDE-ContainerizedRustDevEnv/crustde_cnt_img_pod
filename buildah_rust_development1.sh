#!/usr/bin/env bash

# image with rust and git

# run in bash with
# sh buildah_rust_development1.sh

# The name for the image/container: `rust_development1`
# First I remove the image/container if it already exists.
# Be carefull, this container is not meant to have persistent data.
# the `|| :`` means that the error is ignored if the container does not exist.

echo ""
echo "Removing container and image if exists"
set -e
buildah rm rust_dev || :
buildah rmi -f rust_development1 || :

echo ""
echo "Create new container named rust_development1"
set -o errexit
buildah from --name rust_development1 docker.io/library/rust:slim

echo "apk update and upgrade"
buildah run rust_development1 /bin/sh -c 'apt -y update'
buildah run rust_development1 /bin/sh -c 'apt -y upgrade'
echo "install git"
buildah run rust_development1 /bin/sh -c 'apt -y install git'

echo ""
echo "Finally save/commit the image named rust_development1"
buildah commit rust_development1 rust_development1

echo ""
echo "To list images use"
echo "$ buildah images"

echo ""
echo "To run the container with podman"
echo "$ podman run -ti --name rust_dev1 rust_development1"
echo "and later exit the container with"
echo "$ exit"
