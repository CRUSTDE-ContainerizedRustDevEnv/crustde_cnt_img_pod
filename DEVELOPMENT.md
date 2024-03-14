# Development details

## Install Podman in Debian 12(Bookworm) (on bare metal or in Win10 + WSL2)

[Podman](https://podman.io/) is a **daemonless**, open-source, Linux native tool designed to work with Open Containers Initiative (OCI) Containers and Container Images. Containers under the control of Podman can be run by a **non-privileged user**. The CLI commands of the Podman ***"Container Engine"*** are practically identical to the Docker CLI. Podman relies on an OCI-compliant ***"Container Runtime"*** (runc, crun, runv, etc) to interface with the operating system and create the running containers.

I already wrote some information on how to install and use the combination of Win10 + WSL2 + Debian12(Bookworm):

<https://github.com/bestia-dev/win10_wsl2_debian11>

Podman is available from the Debian12 package manager.

<https://podman.io/getting-started/installation>

Let's install it. Open the `WSL2 terminal` and type:

```bash
lsb_release -d
# Description:    Debian GNU/Linux 12 (bookworm)
cat /etc/debian_version
# 12.5
sudo apt update
sudo apt-get install -y podman
podman version
# Client:       Podman Engine
# Version:      4.3.1
```

In WSL2 we see some errors, that don't exist on bare metal.  
Wsl2 has a special kernel and Podman needs a small trick to work.  
<https://www.redhat.com/sysadmin/podman-windows-wsl2>  
<https://www.youtube.com/watch?v=fWFNGxJNZ8Y>  

```bash
mkdir -p $HOME/.config
mkdir -p $HOME/.config/containers
nano $HOME/.config/containers/containers.conf
```

In this empty new file `containers.conf` write just these 3 lines and save:

```conf
[engine]
cgroup_manager = "cgroupfs"
events_logger = "file"
```

Now you can command again and the result has no errors:

```bash
podman version
# Client:       Podman Engine
# Version:      4.3.1
```

## Using Podman

Using the Podman CLI is just the same as using Docker CLI.  
<https://podman.io/getting-started/>  
Inside the `WSL2 terminal` type:  

```bash
podman images
```

We have no images for now.  
The words "image" and "container" are somewhat confusing. Super simplifying: When it runs it is a "container". If it does not run it is an "image". The image is just an "installation file". The containers can be `started` and `stopped` or `attached` and `detached`, but they are `run` only one time.  
For a test, run a sample container. It is a web server.  

-d means it is run in a detached mode  
-t adds a pseudo-tty to run arbitrary commands in an interactive shell  
-p stays for publish port

The run command will download/pull the image if needed.

```bash
podman run -dt --name sample_cnt -p 8001:80/tcp docker.io/library/httpd
```

List all containers:

```bash
podman ps -a
# it will list also closed container. To clean all the closed container:
podman container cleanup -a --rm
```

Testing the httpd container:

```bash
curl http://localhost:8001
```

That should print the HTML page.

Finally, you can remove the `sample_cnt` container we used:

```bash
podman rm sample_cnt
```

You can also remove the image because this was just practiced for learning:

```bash
podman rmi docker.io/library/httpd
```

## Buildah for CRDE Rust development images

Buildah is a replacement for the `docker build` command. It is easier to incorporate into scripts. It is pronounced exactly as Builder but with a Bostonian accent ;-)

<https://opensource.com/article/18/6/getting-started-buildah>

The Rust official images are on the Docker hub: <https://hub.docker.com/_/rust>

I was surprised by the size of the image. It is big from 500 MB compressed to 1.4 GB uncompressed. But this is the size of Rust development tools.

I don't like that these images have only the `root` user. I will start from the Debian-12 image and install all I need as a non-privileged user `rustdevuser`.

In the bash terminal pull the image from the Docker hub:

```bash
podman pull docker.io/library/debian:bookworm-slim
```

I wrote the bash script `rust_dev_cargo_img.sh`

Run it with

```bash
cd ~/rustprojects/docker_rust_development/create_and_push_container_images 
sh rust_dev_cargo_img.sh
```

This will create the image `rust_dev_cargo_img`.

The scripts are just bash scripts and are super easy to read, follow, learn and modify. Much easier than Dockerfile. You can even run the commands one by one in the `bash terminal` and inspect the container to debug the building process.

## CRDE - Containerized Rust Development Environment

There are a lot of benefits to making a development environment in a container.  
We want that everything is isolated/sandboxed and cannot affect our host system (Debian on bare metal or in WSL2 in Win10).  
We also don't want to make any changes to our system because of Rust tools or our project needs.  
We can have simultaneously more containers, each with a different version of Rust or a different toolchain with all the necessary configuration and tools. We can easily transfer the container to another system or another developer and use it exactly as it is configured. Effortlessly.  
We can save/export the container into an image with the source code and the exact state of all developer tools for a particular app version. Then years later we can still work on it for some security patches without the fear that new tools will break the old source code.  
You will see that everybody uses `podman run`, but this is essentially 4 commands in one: `pull` the image from a repository, `create` the container, `start` or `attach` to the container and exec the bash in interactive mode. I like to use these commands separately because it makes more sense for learning.  
Create the container with a fixed name `rust_dev_cargo_cnt`:

--name - the container name will be `rust_dev_cargo_cnt`  
-ti - we will use the container interactively in the terminal  

```bash
podman create -ti --name rust_dev_cargo_cnt docker.io/bestiadev/rust_dev_cargo_img:latest
```

We can list the existing containers with:

```bash
podman ps -a
```

Now we can start the container:

```bash
podman start rust_dev_cargo_cnt
```

Open the bash to interact with the `container terminal`:  
-it - interactive terminal

```bash
podman exec -it rust_dev_cargo_cnt bash
```

We are now inside the `container terminal` and we can use `cargo`, `rustup` and other rust tools. The files we create will be inside the container. We are `rustdevuser` inside this container, so we will put our rustprojects in the `/home/rustdevuser/rustprojects` directory.  
This container is started from Podman without `root access` to the host system !  
This is a small, but important difference between Docker and Podman.  
First let's find the rustc version:

```bash
rustc --version
  rustc 1.76.0 
```

Let's create and run a small Rust program:

```bash
cd ~/rustprojects
cargo new rust_dev_hello
cd rust_dev_hello
cargo run
```

That should work fine and greet you with "Hello, world!"  
We can exit the container now with the command

```bash
exit
```

When we exited the container we returned to the `host terminal` of the Debian host.  
The container still exists and is still running. Check with `podman ps -a`.  
To interact with it again, repeat the previous command `podman exec -it rust_dev_cargo_cnt bash`.  
This container does not work with VSCode and we will not need it anymore. If you use another editor, you can use this image/container as a base for your image/container for your editor.

Remove the container with:

```bash
podman rm rust_dev_cargo_cnt -f
```

## How to install the "mold linker"

I discovered later that my compile times are bad and that could be better using the "mold linker". It is experimental, but that is ok for me.  
<https://github.com/rui314/mold>  

Download mold from:  
<https://github.com/rui314/mold/releases/download/v2.1.0/mold-2.1.0-x86_64-linux.tar.gz>
and extract only the `mold` binary executable into `~`.  
Copy it as root into `/usr/bin` and adjust ownership and permissions:

```bash
podman exec --user=root rust_dev_vscode_cnt  curl -L https://github.com/rui314/mold/releases/download/v2.4.0/mold-2.4.0-x86_64-linux.tar.gz --output /tmp/mold.tar.gz
podman exec --user=root rust_dev_vscode_cnt  tar --no-same-owner -xzv --strip-components=2 -C /usr/bin -f /tmp/mold.tar.gz --wildcards */bin/mold
podman exec --user=root rust_dev_vscode_cnt rm /tmp/mold.tar.gz
podman exec --user=root rust_dev_vscode_cnt    chown root:root /usr/bin/mold
podman exec --user=root rust_dev_vscode_cnt    chmod 755 /usr/bin/mold
```

Create or modify the global `config.toml` file that will be used for all rust builds:

```bash
nano ~/.cargo/config.toml
```

with GCC advice to use a workaround to -fuse-ld

```toml
[target.x86_64-unknown-linux-gnu]
rustflags = ["-C", "link-arg=-B/home/rustdevuser/.cargo/bin/mold"]
```

## Linux Oci image for cross-compile to Linux, Windows, WASI and WASM

I wrote the bash script `rust_dev_cross_img.sh`

Run it with

```bash
cd ~/rustprojects/docker_rust_development/create_and_push_container_images 
sh rust_dev_cross_img.sh
```

This will create the image `rust_dev_cross_img`.

## Cross-compile for Windows

I added to the image `rust_dev_cross_img` the target and needed utilities for cross-compiling to Windows.  
It is nice for some programs to compile the executables both for Linux and Windows.  
This is now simple to cross-compile with this command:  

```bash
cargo build --target x86_64-pc-windows-gnu
```

The result will be in the folder `target/x86_64-pc-windows-gnu/debug`.  
You can then copy this file from the container to the host system.  
Run inside the host system (example for the simple rust_dev_hello project):  

```bash
mkdir -p ~/rustprojects/rust_dev_hello/win
podman cp rust_dev_cross_cnt:/home/rustdevuser/rustprojects/rust_dev_hello/target/x86_64-pc-windows-gnu/debug/rust_dev_hello.exe ~/rustprojects/rust_dev_hello/win/rust_dev_hello.exe
```

Now in the host system (Linux) you can copy this file (somehow) to your Windows system and run it there. It works.

## Cross-compile for Musl (standalone executable 100% statically linked)

I added to the image `rust_dev_cross_img` the target and needed utilities for cross-compiling to Musl.  
These executables are 100% statically linked and don't need any other dynamic library.  
Using a container to publish your executable to a server makes distribution and isolation much easier.  
These executables can run on the empty container `scratch`.  
Or on the smallest Linux container images like Alpine (7 MB) or distroless static-debian12 (3 MB).  
Most of the programs will run just fine with musl. Cross-compile with this:  

```bash
cargo build --target x86_64-unknown-linux-musl
```

The result will be in the folder `target/x86_64-unknown-linux-musl/debug`.  
You can then copy this file from the container to the host system.  
Run inside the host system (example for the simple rust_dev_hello project):

```bash
mkdir -p ~/rustprojects/rust_dev_hello/musl
podman cp rust_dev_cross_cnt:/home/rustdevuser/rustprojects/rust_dev_hello/target/x86_64-unknown-linux-musl/debug/rust_dev_hello ~/rustprojects/rust_dev_hello/musl/rust_dev_hello
```

First let's make an empty `scratch` container with only this executable:  

```bash
# build the container image from scratch

buildah from \
--name scratch_hello_world_img \
scratch

buildah config \
--author=github.com/bestia-dev \
--label name=scratch_hello_world_img \
--label source=github.com/bestia-dev/docker_rust_development \
scratch_hello_world_img

buildah copy scratch_hello_world_img  ~/rustprojects/rust_dev_hello/musl/rust_dev_hello /rust_dev_hello

buildah commit scratch_hello_world_img docker.io/bestiadev/scratch_hello_world_img

# now run the container and executable

podman run scratch_hello_world_img /rust_dev_hello
```

We can create also a small Alpine container and copy this executable into it.  

```bash
# build the container image

buildah from \
--name alpine_hello_world_img \
docker.io/library/alpine

buildah config \
--author=github.com/bestia-dev \
--label name=alpine_hello_world_img \
--label source=github.com/bestia-dev/docker_rust_development \
alpine_hello_world_img

buildah copy alpine_hello_world_img  ~/rustprojects/rust_dev_hello/musl/rust_dev_hello /usr/bin/rust_dev_hello
buildah run --user root  alpine_hello_world_img    chown root:root /usr/bin/rust_dev_hello
buildah run --user root  alpine_hello_world_img    chmod 755 /usr/bin/rust_dev_hello

buildah commit alpine_hello_world_img docker.io/bestiadev/alpine_hello_world_img

# now run the container and executable

podman run alpine_hello_world_img /usr/bin/rust_dev_hello
```

The commands are similar for distroless static.  

```bash
# build the container image

buildah from \
--name distroless_hello_world_img \
gcr.io/distroless/static-debian12

buildah config \
--author=github.com/bestia-dev \
--label name=distroless_hello_world_img \
--label source=github.com/bestia-dev/docker_rust_development \
distroless_hello_world_img

buildah copy distroless_hello_world_img  ~/rustprojects/rust_dev_hello/musl/rust_dev_hello /usr/bin/rust_dev_hello

buildah commit distroless_hello_world_img docker.io/bestiadev/distroless_hello_world_img

# now run the container and executable

podman run distroless_hello_world_img /usr/bin/rust_dev_hello
```

There is an example of this code in the folder `test_cross_compile`.

You can use this image for distribution of the program to your server. It is only 11 MB in size.

## Cross-compile to Wasi

I added to the image `rust_dev_cross_img` the target `wasm32-wasi` for cross-compiling to Wasi and the CLI wasmtime to run wasi programs.  

```bash
cargo build --target wasm32-wasi
wasmtime ./target/wasm32-wasi/debug/rust_dev_hello.wasm upper world
```

We can also run this wasm program in the WASI playground at <https://runno.dev/wasi>.  

## Cross-compile to Wasm/Webassembly

Rust is perfect for compiling to Wasm and run it inside the browser with no javascript at all!  
I added to the image `rust_dev_cross_img` the utility `wasm-pack` for cross-compiling to Wasm/Webassembly.  
It is an in-place substitute for the default `cargo` command:

```bash
wasm-pack build --release --target web
```

## Linux OCI image with VSCode server and extensions

I use VSCode as my primary code editor in Windows and in Debian GUI.  
I will install the `Remote SSH` extension for remote development. That is very broadly usable. We need to create an image that contains the VSCode server and extensions.

In the `host terminal` run the bash script `rust_dev_vscode_img.sh` It will create the image `rust_dev_vscode_img`.

```bash
cd ~/rustprojects/docker_rust_development/create_and_push_container_images 
sh rust_dev_vscode_img.sh
```

This is based on the image `rust_dev_cargo_img` and adds the VSCode server and extensions.  
VSCode is great because of its extensions. Most of these extensions are installed inside the image `rust_dev_vscode_img`:

- streetsidesoftware.code-spell-checker
- rust-lang.rust-analyzer
- davidanson.vscode-markdownlint
- dotjoshjohnson.xml
- lonefy.vscode-js-css-html-formatter
- serayuzgur.crates

Other extensions you can add manually through VSCode, but then it is not repeatable. Better is to modify the script and recreate the image `rust_dev_vscode_img.sh`.

## Push the image to the Docker hub

I signed in to hub.docker.com.  
In Account Settings - Security I created an access token. This is the password for `podman login`. It is needed only once.  
Then I created a new image repository with the name `rust_dev_vscode_img` and tagged it as the `latest`. Docker is helping with the push command syntax. I use `Podman`, so I just renamed `Docker` to `Podman`. The same for `rust_dev_squid_img`.  
In `host terminal`:

```bash
podman login --username bestiadev docker.io
# type docker access token

podman push docker.io/bestiadev/rust_dev_cargo_img:cargo-1.76.0
podman push docker.io/bestiadev/rust_dev_cargo_img:latest

podman push docker.io/bestiadev/rust_dev_cross_img:cargo-1.76.0
podman push docker.io/bestiadev/rust_dev_cross_img:latest

podman push docker.io/bestiadev/rust_dev_vscode_img:vscode-1.86.1
podman push docker.io/bestiadev/rust_dev_vscode_img:cargo-1.76.0
podman push docker.io/bestiadev/rust_dev_vscode_img:latest

podman push docker.io/bestiadev/rust_dev_squid_img:squid-3.5.27-2
podman push docker.io/bestiadev/rust_dev_squid_img:latest
```

It takes some time to upload more than 3 GB with my slow internet connection.

## Enter the container as root

Sometimes you need to do something as `root`.  
You don't need to use `sudo`. It is not installed. Just open the container `bash` as `root` user.  

```bash
podman exec -it --user root rust_dev_vscode_cnt bash
```

## Image sizes

Rust is not so small. The official Rust image is 500 MB compressed to 1.4 GB uncompressed.  
I saved some 600MB of space just by deleting the docs folder, which no one needs because you can find it on the internet.  
I added in the image a lot of useful tools:  

- faster linking with mold,
- sccache to cache artifacts,
- crate.io-index is already downloaded in the image,
- rust-src for debugging
- cargo-auto for task automation
- cross-compile to Windows, Musl, Wasi and Wasm/WebAssembly,

Docker Hub stores compressed images, so they are a third of the size to download.  

| Image                                    | Label          | Size         | compressed  |
| ---------------------------------------- | -------------- |------------- | ----------- |
| docker.io/bestiadev/rust_dev_cargo_img   | cargo-1.76.0   | 1.28 GB      | 0.45 GB     |
| docker.io/bestiadev/rust_dev_cross_img   | cargo-1.76.0   | 3.03 GB      | 0.98 GB     |
| docker.io/bestiadev/rust_dev_vscode_img  | cargo-1.76.0   | 3.32 GB      | 1.06 GB     |

## Users keys for SSH

We need to create 2 SSH keys, one for the `SSH server` identity `host key` of the container and the other for the identity of `rustdevuser`. This is done only once. To avoid old cryptographic algorithms I will force the new `ed25519`.  
In `host terminal`:

```bash
# generate user key
ssh-keygen -f ~/.ssh/localhost_2201_rustdevuser_ssh_1 -t ed25519 -C "info@my.domain"
# give it a passphrase and remember it, you will need it
# generate host key
mkdir -p ~/.ssh/rust_dev_pod_keys/etc/ssh
ssh-keygen -A -f ~/.ssh/rust_dev_pod_keys

# check the new files
# list user keys
ls -la ~/.ssh | grep "rustdevuser"
# -rw------- 1 rustdevuser rustdevuser  2655 Apr  3 12:03 localhost_2201_rustdevuser_ssh_1
# -rw-r--r-- 1 rustdevuser rustdevuser   569 Apr  3 12:03 localhost_2201_rustdevuser_ssh_1.pub

# list host keys
ls -la ~/.ssh/rust_dev_pod_keys/etc/ssh
# -rw------- 1 rustdevuser rustdevuser 1381 Apr  4 10:44 ssh_host_dsa_key
# -rw-r--r-- 1 rustdevuser rustdevuser  603 Apr  4 10:44 ssh_host_dsa_key.pub
# -rw------- 1 rustdevuser rustdevuser  505 Apr  4 10:44 ssh_host_ecdsa_key
# -rw-r--r-- 1 rustdevuser rustdevuser  175 Apr  4 10:44 ssh_host_ecdsa_key.pub
# -rw------- 1 rustdevuser rustdevuser  399 Apr  4 10:44 ssh_host_ed25519_key
# -rw-r--r-- 1 rustdevuser rustdevuser   95 Apr  4 10:44 ssh_host_ed25519_key.pub
# -rw------- 1 rustdevuser rustdevuser 2602 Apr  4 10:44 ssh_host_rsa_key
# -rw-r--r-- 1 rustdevuser rustdevuser  567 Apr  4 10:44 ssh_host_rsa_key.pub
```

If we use WSL2, the same keys we will need in Windows because the VSCode client works in Windows. We will copy them.  
In the `WSL2 terminal`:

```bash
win_userprofile="$(cmd.exe /c "<nul set /p=%UserProfile%" 2>/dev/null)"
WSLWINUSERPROFILE="$(wslpath $win_userprofile)"
echo $WSLWINUSERPROFILE/.ssh
cp -v ~/.ssh/localhost_2201_rustdevuser_ssh_1 $WSLWINUSERPROFILE/.ssh/localhost_2201_rustdevuser_ssh_1
cp -v ~/.ssh/localhost_2201_rustdevuser_ssh_1.pub $WSLWINUSERPROFILE/.ssh/localhost_2201_rustdevuser_ssh_1.pub
cp -v -r ~/.ssh/rust_dev_pod_keys $WSLWINUSERPROFILE/.ssh/rust_dev_pod_keys
# check
ls -la $WSLWINUSERPROFILE/.ssh | grep "rustdevuser"
ls -la $WSLWINUSERPROFILE/.ssh/rust_dev_pod_keys/etc/ssh
```

## Volumes or mount restrictions

I don't want that the container can access any file on my local system.  
This is a "standalone" development container and everything must run inside.  
The files must be cloned/pulled from GitHub or copied manually with `podman cp`.  
Before removing the containers the source files must be pushed to GitHub or exported some other way.  

## Network Inbound restrictions

I would like to restrict the use of the network from/to the container.  
When using Podman as a rootless user, the network is set up automatically. Only the `localhost` can be used. The container itself does not have an IP Address because, without root privileges, network association is not allowed. Port publishing as rootless containers can be done for "high ports" only. All ports below `1024` are privileged and cannot be used for publishing.  
I think that all inbound ports are closed by default and I need to explicitly expose them manually.

## Network Outbound restrictions with Squid proxy in container

I would like to limit access to the internet only to whitelisted domains:  
crates.io, github.com,...  
Some malware could want to "call home" and I will try to disable this.  
What I need is a "proxy" or "transparent proxy". I will use the leading open-source proxy `Squid`, but in a container.  
It can restrict both HTTP and HTTPS outbound traffic to a given set of Internet domains while being fully transparent for instances in the private subnet.  
<https://aws.amazon.com/blogs/security/how-to-add-dns-filtering-to-your-nat-instance-with-squid/>  
I want to use this proxy for the container `rust_dev_vscode_cnt`. Container-to-container networking can be complex.  
Podman works with `pods`, that make networking easy. This is usually the simplest approach for two rootless containers to communicate. Putting them in a `pod` allows them to communicate directly over `localhost`.  
First, create a modified image for Squid:

```bash
cd ~/rustprojects/docker_rust_development/create_and_push_container_images 
sh rust_dev_squid_img.sh
```

If you need, you can modify the file `etc_squid_squid.conf` to add more whitelisted domains. Then run `sh rust_dev_squid_img.sh` to build the modified image.  
You can also add whitelisted domains later when you use the squid container. First modify the file `~/rustprojects/docker_rust_development/create_and_push_container_images/etc_squid_squid.con`. Then copy this file into the squid container:

```bash
podman cp ~/rustprojects/docker_rust_development/create_and_push_container_images/etc_squid_squid.conf rust_dev_squid_cnt:/etc/squid/squid.conf
# Finally restart the squid container
podman restart rust_dev_squid_cnt
```

Watch the squid log if the access has been denied to some domains:

```bash
podman exec rust_dev_squid_cnt cat /var/log/squid/access.log
podman exec rust_dev_squid_cnt tail -f /var/log/squid/access.log
```

Check later, if these env variables are set inside `rust_dev_vscode_cnt` bash terminal.  
These variables should be set when creating the pod.

```bash
env
# you can set the env variable manually 
export http_proxy='http://localhost:3128'
export https_proxy='http://localhost:3128'
export all_proxy='http://localhost:3128'
```

## One pod with 2 containers

Podman and Kubernetes have the concept of pods, where more containers are tightly coupled. Here we will have the `rust_dev_vscode_cnt` that will use `rust_dev_squid_cnt` as a proxy. From the outside, the pod is like one entity with one address. All the network communication goes through the pod. Inside the pod, everything is in the `localhost` address. That makes it easy to configure.  
Inside the container `rust_dev_vscode_cnt` I want that everything goes through the proxy. These env variables should do that: `http_proxy`, `https_proxy`,`all_proxy`.  
Run the bash script to create a new pod `rust_dev_pod` with proxy settings:

```bash
cd ~/rustprojects/docker_rust_development/docker_rust_development_install/pod_with_rust_vscode 
sh rust_dev_pod_create.sh
```

The pod is now running:

```bash
podman pod list
podman ps -a 
```

## Try SSH from Debian

Try the SSH connection from WSL2 to the container:

```bash
ssh -i ~/.ssh/localhost_2201_rustdevuser_ssh_1 -p 2201 rustdevuser@localhost
# Choose `yes` to save fingerprint if asked, just the first time.  
# type passphrase
# should work !  
# try for example
ls
# ls result: rustprojects
# to exit the container
exit
```

## Try SSH from Windows

Run in `Windows cmd prompt` to access the container over SSH from Windows:

```bash
# test the ssh connection from Windows cmd prompt
"C:\WINDOWS\System32\OpenSSH\ssh.exe" -i ~\.ssh\localhost_2201_rustdevuser_ssh_1 -p 2201 rustdevuser@localhost
# Choose `y` to save fingerprint if asked, just the first time.  
# type passphrase
# should work !  
# try for example
ls
# ls result: rustprojects
# to exit the container
exit
```

## Debug SSH connection

Sometimes it is needed to debug the connection to the `ssh server` because the normal error messages are completely useless.  
From the `host terminal`, I enter the `container terminal` as `root`:  

```bash
podman exec -it --user=root  rust_dev_vscode_cnt bash
```

In `container terminal`:

```bash
service ssh stop
/usr/sbin/sshd -ddd -p 2201
# now we can see the verbose log when we attach an SSH client to this server. And we can see where is the problem.  
# after debug, start the service, before exit
service ssh start
exit
```

To see the verbose log of the `SSH client` add `-v` like this:  

```bash
ssh -i ~/.ssh/github_com_git_ssh_1 -p 2201 rustdevuser@localhost -v
```

To see the listening ports:

```bash
netstat -tan 
```

## VSCode

Open VSCode and install the extension `Remote - SSH`.  
In VSCode `F1`, type `ssh` and choose `Remote-SSH: Open SSH configuration File...`.  
In Debian on bare metal:  
choose  `~/.ssh/config` and type (if is missing)  

```bash
Host rust_dev_vscode_cnt
  HostName localhost
  Port 2201
  User rustdevuser
  IdentityFile ~/.ssh/localhost_2201_rustdevuser_ssh_1
  IdentitiesOnly yes
```

In Windows +WSL2:  
choose  `c:\users\user_name\ssh\config` and type (if is missing)

```bash
Host rust_dev_vscode_cnt
  HostName localhost
  Port 2201
  User rustdevuser
  IdentityFile ~\.ssh\localhost_2201_rustdevuser_ssh_1
  IdentitiesOnly yes
```

The big difference is only / or \ for the file path. Bad Windows!  
Save and close.  
Then in VSCode `F1`, type `ssh` and choose `Remote-SSH: Connect to Host...` and choose `rust_dev_vscode_cnt`.  
Choose `Linux` and yes for the fingerprint if asked, just the first time.  
Type your passphrase.  
If we are lucky, everything works and VSCode is now inside the container over SSH.  

## VSCode terminal

VSCode has an integrated `VSCode terminal`. It has some advantages for developers that the standard `bash terminal` does not have.  
It is great to use it for everything around code in containers. You can open more than one `VSCode terminal` if you need to. For example, if you run a web server.  
If the `VSCode terminal` is not opened simply press `Ctrl+j` to open it and the same to close it.  
Inside the `VSCode terminal`, we will create a sample project:

```bash
cd ~/rustprojects
cargo new rust_dev_hello
```

This easy command opens a new VSCode window exactly for this project/folder inside the container:

```bash
code rust_dev_hello
```

A new VSCode window will open for the `rust_dev_hello` project. Because of the SSH communication, it asks for the passphrase again. You can close now all other VSCode windows.

Build and run the project in the `VSCode terminal`:

```bash
cargo run
```

That should work and greet you with "Hello, world!".  
Leave VSCode open because the next chapter will continue from here.

## Open the VSCode project from the command line

You can call directly an existing VSCode project inside the container from the Linux host over SSH like this:

```bash
code --remote ssh-remote+rust_dev_vscode_cnt /home/rustdevuser/rustprojects
```

## GitHub in the container

Download the template for the bash script from here:  
[personal_keys_and_settings.sh](https://github.com/bestia-dev/docker_rust_development/blob/main/docker_rust_development_install/personal_keys_and_settings_template.sh)  
into Debian folder `~\.ssh`. It contains all the steps explained below. First, rename it to personal_keys_and_settings.sh. You have to personalize it with your personal data.  
Run in `host terminal`:

```bash
sh ~/.ssh/rust_dev_pod_keys/personal_keys_and_settings.sh
```

Manually step-by-step instructions that are inside the `personal_keys_and_settings.sh`.  
Git inside the container does not yet have your information, that it needs.  
In `host terminal`:

```bash
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.email "info@your.mail"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.name "your_name"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global -l
```

I like to work with GitHub over SSH and not over HTTPS. I think it is the natural and safe thing for Linux.  
To make the SSH client work in the container I need the file with the private key for SSH connection to GitHub. I already have this in the file `~/.ssh/github_com_git_ssh_1`. I will copy it into the container with `podman cp`.  
Be careful ! This is a secret !  
It means that this container I cannot share any more with anybody. It is now my private container. I must never make an image from it and share it. Never !

In `host terminal`:

```bash
podman exec --user=rustdevuser rust_dev_vscode_cnt ls -la /home/rustdevuser/.ssh
podman cp ~/.ssh/github_com_git_ssh_1 rust_dev_vscode_cnt:/home/rustdevuser/.ssh/github_com_git_ssh_1
podman exec --user=rustdevuser rust_dev_vscode_cnt chmod 600 /home/rustdevuser/.ssh/github_com_git_ssh_1
podman cp ~/.ssh/github_com_git_ssh_1.pub rust_dev_vscode_cnt:/home/rustdevuser/.ssh/github_com_git_ssh_1.pub
podman exec --user=rustdevuser rust_dev_vscode_cnt ls -la /home/rustdevuser/.ssh
```

The `VSCode terminal` is still open on the project `rust_dev_hello` from the previous chapter.

## ssh-agent in Linux bash

Read SSH easy here: [ssh_easy.md](ssh_easy.md)

It is comfortable to use the `ssh-agent` to store the passphrase in memory, so we type it only once. The ssh-agent is already started on login in the `~/.bashrc` script.  
Again attention, that this container has secrets and must not be shared ! Never !  
In the `VSCode terminal` (Ctrl+j) run:

```bash
ssh-add /home/rustdevuser/.ssh/github_com_git_ssh_1
# enter your passphrase
```

You can download the template [sshadd_template.sh](https://github.com/bestia-dev/docker_rust_development/blob/main/docker_rust_development_install/sshadd_template.sh) from GitHub and save it into the Debian folder `~/.ssh`. Rename it to `sshadd.sh` and personalize it with your SSH key file names.  
Run in `host Terminal`:

```bash
podman cp ~/.ssh/sshadd.sh rust_dev_vscode_cnt:/home/rustdevuser/.ssh/sshadd.sh  
```

You will then run inside the `VSCode terminal` for each window/project separately:

```bash
sh ~/.ssh/sshadd.sh
# or simply
sshadd
# if you add the alias into ~/.bashrc
```

After you enter the passphrase, it will remember it until the terminal is open.  
When you open the terminal again, you will have to run the script again and enter the passphrase again.

## ssh-agent in Windows powershell

I use VSCode from Windows and connect over SSH to CRDE - Containerized Rust Development Environment.  
Every time I connect I must input the passcode for my SSH identity.  
Also windows has `ssh-agent` and I could use it just the same as in Linux bash to avoid retyping the passcode every time.  

Create powershell script  
`$HOME\.ssh\sshadd.ps1`  
copied from  
[sshadd_template.ps1](docker_rust_development_install/win_home_ssh_sshadd_template.ps1)

Recreate the alias on every startup with the powershell script  
`$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1`  
copied from  
[microsoft_powershell_profile_template.ps1](docker_rust_development_install\win_home_documents_powershell_microsoft_powershell_profile_template.ps1).

Then add your often used identities simply with: 

```powershell
sshadd
```

My Win10 `ssh -V` has the version OpenSSH_for_Windows_8.1p1, LibreSSL 3.0.2.
I will update it to version OpenSSH_for_Windows_9.5p1, LibreSSL 3.8.2 from Winget.

In `Apps & Features` uninstall OpenSSH if exists.
In `Manage Optional Features` uninstall OpenSSH client and Server. They are some old version anyway. Sadly, it will leave some files behind:  
Delete the folder `c:\Windows\System32\OpenSSH\`. The owner is TrustedInstaller, so first you have to change the owner to you and then give permission to administrators to Full Control. Then you can finally delete it as administrator.

In Powershell as administrator run:

```powershell
winget search "openssh beta"
winget install "openssh beta"
# Add the folder to windows path:
$env:Path = 'C:\Program Files\OpenSSH>;' + $env:Path
ssh -V
#OpenSSH_for_Windows_9.5p1, LibreSSL 3.8.2
```

WARNING!!! don't run the agent in Powershell like `ssh-agent`. It will get the illusion that works, but it will be a mess.
If you are not in Powershell as administrator
you will get strange errors that are impossible to debug:  

- Could not add identity : agent refused operation  
- cannot create agent root reg key, ERROR:5  
- and so on...  

Correctly start it this way:
In `Services` find `OpenSSH Authentication Agent`,
`Start` it and change `Startup type` to `Automatic`.
That way, the agent will work correctly.

WARNING!!! Windows ssh-agent cannot accept options like `-c` or `-t 1h`. It will return an cryptic error that is super hard to debug: "Could not add identity "key": agent refused operation". Just don't use any option.  

WARNING!!! Don't use `~` or `$home` or anything similar in windows scripts, because one of the involved programs will sure miss how to expand it. Just write the complete path. This is true also for the .ssh/config file!  

In extreme cases for debugging open `Pwsh as administrator` and run `ssh-agent -d`.
Then in another `Pwsh` window run a `ssh-add` command.  The debugging works only for one command.

## GitHub push

Open `github.com` in the browser and sign in, click `New` and create a new repository named `rust_dev_hello`.  
GitHub is user-friendly and shows the standard commands we need to run. Choose SSH commands and not HTTPS or CLI. You will find commands similar to the commands below.  
In VSCode click on the `Source control` and click `Initialize`, then type the commit-msg "init" and click `Commit`.  
Then in `VSCode terminal` run:

```bash
git remote add origin git@github.com:bestia-dev/rust_dev_hello.git
git push -u origin main
```

Done! Check your GitHub repository.  
Always push the changes to GitHub. So you can destroy this pod/container and create a new empty one, then pull the code from GitHub and continue developing. Containers are the worst place to have persistent data stored. They can be deleted at any second for any reason.  
Leave VSCode open because the next chapter will continue from here.

## Existing Rust projects on GitHub

You probably already have a Rust project on GitHub. You want to continue its development inside the container.  
For example, we will use my PWA+WebAssembly/WASM project `rust_wasm_pwa_minimal_clock`, which needs to forward port 8001 because our project needs a web server. That is fairly common. I am not a fan of autoForward `automagic` in VSCode, so I disable it in `File-Preferences-Settings` search `remote.autoForwardPorts` and uncheck it to false.  
We will continue to use the existing `VSCode terminal`, which is already opened in the folder `/home/rustdevuser/rustprojects/rust_dev_hello`. Just to practice.  
Run the commands to clone the repository from GitHub and open a new VSCode window. We already have the SSH private key and `ssh-agent` running:

```bash
cd /home/rustdevuser/rustprojects/
git clone git@github.com:bestia-dev/rust_wasm_pwa_minimal_clock.git
code rust_wasm_pwa_minimal_clock
```

The `code` command will open a new VSCode window in the folder `rust_wasm_pwa_minimal_clock`. Enter the SSH passphrase when asked. In the new VSCode window, we can now edit, compile and run the project. All are sandboxed/isolated inside the container. We can now close the other VSCode windows, we don't need it anymore.  
This example is somewhat more complex because it is WebAssembly, but it is good for learning. I used the automation tool `cargo-auto` to script a more complex building process. You can read the automation task code in `automation_task_rs/src/main.rs`. On the first, it will download the wasm components and wasm-bindgen. That can take some time. Don't whine!

Now we can build and run the project in the `VSCode terminal` (Ctrl+j):

```bash
cargo auto build_and_run
```

In VSCode go to Ports and add port `4000`.  
Open the browser in Windows:  
<http://localhost:4000/rust_wasm_pwa_minimal_clock/>  
This is an example of Webassembly and PWA, directly from a Linux OCI container.  
A good learning example.

## After reboot

After reboot, WSL2 can create some network problems for Podman.  
No problem for Debian on bare metal. But the script is ok to restart the pod and start the sshd server.  
So use it in both cases.  
We can simulate the WSL2 reboot in `Powershell in Windows`:

```powershell
wsl --shutdown 
```

Before entering any Podman command we need first to clean some temporary files, restart the pod and restart the SSH server.  
In `host terminal`:

```bash
sh ~/rustprojects/docker_rust_development_install/rust_dev_pod_after_reboot.sh
podman ps
```

If the restart is successful every container will be started a few seconds. It is not enough for containers to be in the status "created". Then just repeat the restart procedure.

## VSCode and file copying from win10

It is easy to copy files from Win10 to the VSCode project inside the container just with drag&drop.  
In the other direction, we right-click a file in VSCode Explorer and choose `Download` and then a download folder. It works for entire folders too.

## Protect the SSH private key in Windows

In Linux, the private keys inside `~/.ssh` are protected with `chmod 600`.  
We need to do similarly for the private keys inside Win10 folder `~\.ssh`
Run in `Powershell terminal` with the standard user:

```PowerShell
cd ~/.ssh
ls
# Set Key File Variable:
  New-Variable -Name Key -Value "$env:UserProfile\.ssh\id_rsa"
# Remove Inheritance:
  Icacls $Key /c /t /Inheritance:d
# Set Ownership to Owner:
  Icacls $Key /c /t /grant ${env:UserName}:F
# Remove All Users, except for Owner:
  Icacls $Key  /c /t /Remove Administrator BUILTIN\Administrators BUILTIN Everyone System Users
# Verify:
  Icacls $Key
# Remove Variable:
  Remove-Variable -Name Key
```

## Debian shutdown

I got this error on shutdown: "A stop job running..." and it waits for 3 minutes.  
I think it is Podman. I will always shutdown Debian with a script that stops Podman first.  
Create a bash script with this text:

```bash
#!/bin/sh
echo 'podman pod stop --all'
podman pod stop --all
echo 'podman stop --all'
podman stop --all
echo 'sudo shutdown -h now'
sudo shutdown -h now
```

```bash
nano ~/shut.sh
sudo chmod a+x ~/shut.sh
sh ~/shut.sh
```

In ~/.bashrc add these lines, then use just the short command `shut`:

```bash
echo "For correct shutdown that stops podman use the command 'shut'"
alias shut="sh ~/shut.sh"
```

## Quirks

It is a complex setting. There can be some quirks sometimes.

## ssh could not resolve hostname

Warning: The "ssh could not resolve hostname" is a common error. It is not that big of an issue. I closed everything and restart my computer and everything works fine now.

## WARNING: REMOTE HOST IDENTIFICATION HAS CHANGED

SSH client used in VSCode remembers the key of the servers in the file `~/.ssh/known_hosts`.
If we created a new key for the ephemeral container, we can get the error `REMOTE HOST IDENTIFICATION HAS CHANGED`.  
It is enough to open the file `~/.ssh/known_hosts` and delete the offending line.  
VSCode is a Windows program, so the offending file is in windows `C:\Users\luciano\.ssh\known_hosts`.  
In the `WSL2 terminal` we can use:

```bash
ssh-keygen -f ~/.ssh/known_hosts -R "[localhost]:2201";
win_userprofile="$(cmd.exe /c "<nul set /p=%UserProfile%" 2>/dev/null)"
WSLWINUSERPROFILE="$(wslpath $win_userprofile)"
echo $WSLWINUSERPROFILE/.ssh
ssh-keygen -f $WSLWINUSERPROFILE/.ssh/known_hosts -R "[localhost]:2201";
```

## Double-commander SFTP

On Debian, I use Double-commander as an alternative to Total-commander on Windows. It has an Ftp functionality that allows SSH and SFTP. But the private key must be PEM/rsa. It does not work with the existing localhost_2201_rustdevuser_ssh_1 which is OpenSSH. I tried to convert the key format, but neither key-gen, OpenSsl nor putty was up to the task. So I decided to make a new private key just for Double-commander.  
In the DoubleCmd ftp setting, I must enable the "use SSH+SCP protocol (no SFTP)" to make it work.  
On the host Debian system run:

```bash
ssh-keygen -t rsa -b 4096 -m PEM -C rustdevuser@rust_dev_pod -f /home/rustdevuser/.ssh/rustdevuser_rsa_key
podman cp ~/.ssh/rustdevuser_rsa_key.pub rust_dev_vscode_cnt:/home/rustdevuser/.ssh/rustdevuser_rsa_key.pub
podman exec --user=rustdevuser rust_dev_vscode_cnt /bin/sh -c 'cat /home/rustdevuser/.ssh/rustdevuser_rsa_key.pub >> /home/rustdevuser/.ssh/authorized_keys'
ssh-keyscan -p 2201 -H 127.0.0.1 >> ~/.ssh/known_hosts
```

Now I can use this key for Double-commander SFTP.

## Typescript compiler

Some projects need the typescript compiler `tsc`. First, we need to install nodejs with npm to install typescript. That is a lot of installation. This is because I don't want it in my default container. For typescript, I created a new container image: `rust_ts_dev_image`.  
The bash script `sh rust_ts_dev_image.sh` will create the new image with typescript.  
Then we can use `sh docker_rust_development_install\pod_with_rust_ts_vscode\rust_dev_pod_create.sh.sh` to create the Podman pod with typescript.  
The same `sh ~/rustprojects/docker_rust_development_install/rust_dev_pod_after_reboot.sh` is used after reboot.  

## PostgreSQL

Some projects need the database PostgreSQL 13. I created a new pod with the command `sh docker_rust_development_install\pod_with_rust_pg_vscode\rust_dev_pod_create.sh`.  
The same `sh ~/rustprojects/docker_rust_development_install/rust_dev_pod_after_reboot.sh` is used after reboot.  
I didn't like the pgAdmin administrative tool. I will try DBeaver instead on `localhost:9876`.  
If you want, you can change the user and passwords in the bash script `rust_dev_pod_create.sh` to something stronger.  

## Read more

Read more about how I use my [Development environment](https://github.com/bestia-dev/development_environment).  

## WSL problems

I still have problems after the WSL reboot.  
Some say: The `/tmp` files should be on a temporary filesystem.  
Here is how I set fstab to mount tmpfs, it works.

```bash
echo "none  /tmp  tmpfs  defaults  0 0" | sudo tee -a /etc/fstab
# create /tmp folder if not exist
sudo mkdir /tmp
sudo chmod 1777 /tmp
```

