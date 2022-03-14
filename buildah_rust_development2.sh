#!/usr/bin/env bash

# image with rust, git, vscode-server and extensions

# run in bash with
# sh buildah_rust_development2.sh

# The name for the image/container: `rust_development2`
# First I remove the image/container if it already exists.
# Be carefull, this container is not meant to have persistent data.
# the `|| :`` means that the error is ignored if the container does not exist.

echo ""
echo "removing container and image if exists"
set -e
buildah rm rust_dev || :
buildah rmi -f rust_development2 || :

echo ""
echo "create new container named rust_development2"
set -o errexit
buildah from --name rust_development2 docker.io/library/rust:slim

echo "apk update and upgrade"
buildah run rust_development2 /bin/sh -c 'apt -y update'
buildah run rust_development2 /bin/sh -c 'apt -y upgrade'
echo "install git"
buildah run rust_development2 /bin/sh -c 'apt -y install git'
buildah run rust_development2 /bin/sh -c 'apt install -y rsync'
buildah run rust_development2 /bin/sh -c 'rustup component add rustfmt'
buildah run rust_development2 /bin/sh -c 'cargo install basic-http-server'
buildah run rust_development2 /bin/sh -c 'cargo install cargo-auto'
buildah run rust_development2 /bin/sh -c 'apt install -y curl'
buildah run rust_development2 /bin/sh -c 'curl https://rustwasm.github.io/wasm-pack/installer/init.sh -sSf | sh'

buildah run rust_development2 /bin/sh -c 'mkdir -vp ~/rustprojects'

echo "download vscode-server. Be sure the commit_sha of the server and client is the same:"
echo "In VSCode client open Help-About."
echo "c722ca6c7eed3d7987c0d5c3df5c45f6b15e77d1"
buildah run rust_development2 /bin/sh -c 'apt -y install wget'
buildah run rust_development2 /bin/sh -c 'wget -nv -O /tmp/vscode-server-linux-x64.tar.gz https://update.code.visualstudio.com/commit:c722ca6c7eed3d7987c0d5c3df5c45f6b15e77d1/server-linux-x64/stable'
buildah run rust_development2 /bin/sh -c 'mkdir -vp ~/.vscode-server/bin/c722ca6c7eed3d7987c0d5c3df5c45f6b15e77d1'
buildah run rust_development2 /bin/sh -c 'mkdir -vp ~/.vscode-server/extensions'
buildah run rust_development2 /bin/sh -c 'tar --no-same-owner -xzv --strip-components=1 -C ~/.vscode-server/bin/c722ca6c7eed3d7987c0d5c3df5c45f6b15e77d1 -f /tmp/vscode-server-linux-x64.tar.gz'
buildah run rust_development2 /bin/sh -c '~/.vscode-server/bin/c722ca6c7eed3d7987c0d5c3df5c45f6b15e77d1/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension streetsidesoftware.code-spell-checker'
buildah run rust_development2 /bin/sh -c '~/.vscode-server/bin/c722ca6c7eed3d7987c0d5c3df5c45f6b15e77d1/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension matklad.rust-analyzer'
buildah run rust_development2 /bin/sh -c '~/.vscode-server/bin/c722ca6c7eed3d7987c0d5c3df5c45f6b15e77d1/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension davidanson.vscode-markdownlint'
buildah run rust_development2 /bin/sh -c '~/.vscode-server/bin/c722ca6c7eed3d7987c0d5c3df5c45f6b15e77d1/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension 2gua.rainbow-brackets'
buildah run rust_development2 /bin/sh -c '~/.vscode-server/bin/c722ca6c7eed3d7987c0d5c3df5c45f6b15e77d1/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension dotjoshjohnson.xml'
buildah run rust_development2 /bin/sh -c '~/.vscode-server/bin/c722ca6c7eed3d7987c0d5c3df5c45f6b15e77d1/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension jebbs.plantuml'
buildah run rust_development2 /bin/sh -c '~/.vscode-server/bin/c722ca6c7eed3d7987c0d5c3df5c45f6b15e77d1/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension lonefy.vscode-js-css-html-formatter'
buildah run rust_development2 /bin/sh -c '~/.vscode-server/bin/c722ca6c7eed3d7987c0d5c3df5c45f6b15e77d1/bin/code-server --extensions-dir ~/.vscode-server/extensions --install-extension serayuzgur.crates'

echo "Installing cargo tools"
buildah run rust_development2 /bin/sh -c 'cargo install dev_bestia_cargo_completion'
buildah run rust_development2 /bin/sh -c 'complete -C "dev_bestia_cargo_completion" cargo'



echo ""
echo "finally save/commit the image named rust_development2"
buildah commit rust_development2 rust_development2

echo ""
echo "To list images use:"
echo "$ buildah images"

echo ""
echo "To run the container with podman:"
echo "$ podman run -ti --name rust_dev2 rust_development2"
echo "and later exit the container with"
echo "$ exit"
