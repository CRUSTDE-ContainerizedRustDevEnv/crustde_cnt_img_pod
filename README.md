# Rust: Hack Without Fear ! (docker_rust_development)

**A complete development environment for Rust with VSCode inside a docker container.**  
***version: 2022.324.1258  date: 2022-03-24 author: [bestia.dev](https://bestia.dev) repository: [GitHub](https://github.com/bestia-dev/docker_rust_development)***  

[![Lines in md](https://img.shields.io/badge/Lines_in_markdown-832-green.svg)](https://github.com/bestia-dev/docker_rust_development/)  [![Lines in bash scripts](https://img.shields.io/badge/Lines_in_bash_scripts-722-blue.svg)](https://github.com/bestia-dev/docker_rust_development/)  [![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/bestia-dev/docker_rust_development/blob/master/LICENSE)

![spiral_of_madness](https://github.com/bestia-dev/docker_rust_development/raw/main/images/spiral_of_madness.png "spiral_of_madness")

## Try it

Video tutorial on youtube: <https://bestia.dev/youtube/docker_rust_development.html>

Super short instructions without explanation just in 9 easy steps. For tl;dr; continue reading below.

Prerequisites: Win10, WSL2, VSCode.  
I tested the script on a completely fresh installation of Debian on WSL2.  

1\. Download the podman_install_and_setup bash script and run it. This can take 10 minutes to setup because it downloads about 1.5 GB from docker hub.  
In `WSL2 terminal`:

```bash
sudo apt update
sudo apt -y full-upgrade
sudo apt install -y curl
mkdir -p ~/rustprojects/docker_rust_development
cd ~/rustprojects/docker_rust_development
# Download the bash script
curl -L -s https://github.com/bestia-dev/docker_rust_development/raw/main/podman_install_and_setup.sh --output podman_install_and_setup.sh
# You can check the content of the bash script
cat podman_install_and_setup.sh
# then run
sh podman_install_and_setup.sh
# This can take 10 minutes because it needs to download around 1.5 GB from docker hub.
# You will be asked to create a new passphrase for the SSh key. Remember it, you will need it.
```

2\. Run the script to create and start the pod - just once:

```bash
sh rust_dev_pod_create.sh
```

3\. Try the SSH connection from WSL2:

```bash
ssh -i ~/.ssh/rustdevuser_key -p 2201 rustdevuser@localhost
# Choose `yes` to save fingerprint if asked, just the first time.
# type passphrase
# should work !
# try for example
ls
# ls result: rustprojects
# to exit the container
exit
```

4\. Run in `windows cmd prompt` to access the container over SSH from windows:

```bash
# test the ssh connection from Windows cmd prompt
"C:\WINDOWS\System32\OpenSSH\ssh.exe" -i ~\.ssh\rustdevuser_key -p 2201 rustdevuser@localhost
# Choose `y` to save fingerprint if asked, just the first time.
# type passphrase
# should work !
# try for example
ls
# ls result: rustprojects
# to exit the container
exit
```

5\. Open VSCode and install extension `Remote - SSH`.

6\. Then in VSCode `F1`, type `ssh` and choose `Remote-SSH: Connect to Host...` and choose `rust_dev_pod`.  
Choose `Linux` if asked, just the first time.  
Type your passphrase.  
If we are lucky, everything works and you are now inside the container over SSH.

7\. In `VSCode terminal`:

```bash
cd ~/rustprojects
cargo new rust_dev_hello
cd rust_dev_hello
cargo run
```

That should work and greet you with "Hello, world!"

8\. After reboot WSL2 can create some network problems for podman. Before entering any podman command we need first to clean some temporary files, restart the pod and restart the SSh server.  
We can simulate the WSL2 reboot in `powershell in windows`:

```powershell
Get-Service LxssManager | Restart-Service
```

In `WSL2 terminal`:

```bash
# restart the pod after reboot
sh ~/rustprojects/docker_rust_development/rust_dev_pod_after_reboot.sh
```

9\. Eventually you will want to remove the entire pod. Docker containers and pods are ephemeral, it means just temporary. But your code and data must persist. Before destroying the pod/containers, push your changes to github, because it will destroy also all the data that is inside.  
Be careful !  
In `WSL2 terminal`:

```bash
podman pod rm rust_dev_pod_create -f
```

You can jump over the long explanation directly to "Github in the container" and continue there.

## Motivation

Rust is a fantastic young language that empowers everyone to build reliable and efficient software. It enables simultaneously low-level control without giving up high-level conveniences. But with great power comes great responsibility !

Rust programs can do any "potentially harmful" things to your system. That is true for any compiled program, Rust is no exception.

But Rust can do anything also in the compile-time using `build.rs` and `procedural macros`. Even worse, if you open a code editor (like VSCode) with auto-completion (like Rust-analyzer), it will compile the code in the background without you knowing it. And the `build.rs` and `procedural macros` will run and they can do "anything" !

Even if you are very careful and avoid `build.rs` and `procedural macros`, your Rust project will have a lot of crates in the dependency tree. Any of those can surprise you with some "malware". This is called a "supply chain attack".

It is very hard to avoid "supply chain attacks" in Rust as things are today. We are just lucky, that the ecosystem is young and small and the malevolent players are waiting for Rust to become more popular. Then they will strike and strike hard. We need to be skeptical about anything that comes from the internet. We need to isolate/sandbox it so it cannot harm our system.  

Let learn to develope "everything" inside a Docker container and to isolate/sandbox it as much as possible from the underlying system.

I have to acknowledge that Docker Linux Containers are not the perfect sandboxing solution. But I believe that for my "Rust development environment", it is "good enough". I expect that container isolation will get better with time (google, amazon, Intel, OpenStack and IBM are working on it). My main system is Win10. Inside that, I have WSL2, which is a Linux virtual machine. And inside that, I have Docker Linux Containers.  

- No files/volumes are shared with the host.  
- The outbound network is restricted to whitelisted domains by a Squid proxy server.  
- The inbound network is allowed only to "published/exposed" ports.  

Yes, there exists the possibility of abusing a kernel vulnerability, but I believe it is hard and they will get patched.

## Docker and OCI

We all call it Docker, but [Docker](https://www.docker.com/) is just a well known company name with the funny whale logo.
They developed and promoted Linux containers. Then they helped to create an open industry standards around container formats and runtimes. This standard is now called OCI (Open Container Initiative). So the correct name is "OCI containers" and "OCI images".

But "OCI" is a so boring name. I will still use the terms "Docker containers" and "Docker images" even if other companies can work interchangeably with them because of the OCI standards.

And there are alternatives to use Docker software that I will explore here.

## Install Podman in Win10 + WSL2 + Debian 11(Bullseye)

[Podman](https://podman.io/) is a **daemonless**, open source, Linux native tool designed to work with Open Containers Initiative (OCI) Containers and Container Images. Containers under the control of Podman can be run by a **non-privileged user**. The CLI commands of the Podman ***"Container Engine"*** are practically identical to the Docker CLI. Podman relies on an OCI compliant ***"Container Runtime"*** (runc, crun, runv, etc) to interface with the operating system and create the running containers.

I already wrote some information how to install and use the combination of Win10 + WSL2 + Debian11(Bullseye):

<https://github.com/bestia-dev/win10_wsl2_debian11>

Podman is available from the Debian11 package manager.

<https://podman.io/getting-started/installation>

Let's install it. Open the `WSL2 terminal` and type:

```bash
sudo apt update
sudo apt install -y podman
podman version
```

Here we see some errors.

Wsl2 has a special kernel and Podman needs a small trick to work.

<https://www.redhat.com/sysadmin/podman-windows-wsl2>

<https://www.youtube.com/watch?v=fWFNGxJNZ8Y>

```bash
mkdir $HOME/.config/containers
nano $HOME/.config/containers/containers.conf
```

In this empty new file `containers.conf` write just this 3 lines and save:

```conf
[engine]
cgroup_manager = "cgroupfs"
events_logger = "file"
```

Now you can command again and the result has no errors:

```bash
podman version
# 3.0.1
```

Sadly, the version on Debian 11 stable is 3.0.1, that is buggy and does not work properly. I will install the version 3.4.4 from the `testing` Debian 12.
In `WSL2 terminal`:

```bash
sudo nano /etc/apt/sources.list
# add the line for `testing` repository
deb http://http.us.debian.org/debian/ testing non-free contrib main
# Ctrl-o, enter, Ctrl-x
sudo apt update
# Then run 
sudo apt install -y podman
podman info
# podman 3.4.4
# Very important: Remove the temporary added line and run apt update
sudo nano /etc/apt/sources.list
# delete: deb http://http.us.debian.org/debian/ testing non-free contrib main 
# Ctrl-o, enter, Ctrl-x
sudo apt update
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

For test, run a sample container. It is a web server.

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
```

Testing the httpd container:

```bash
curl http://localhost:8001
```

That should print the HTML page.

Finally you can remove the `sample_cnt` container we used:

```bash
podman rm sample_cnt
```

You can also remove the image, because this was just practice for learning:

```bash
podman rmi docker.io/library/httpd
```

## Buildah for our Rust development images

Buildah is a replacement for the `docker build` command. It is easier to incorporate into scripts. It is pronounced exactly as Builder, but with a Bostonian accent ;-)

<https://opensource.com/article/18/6/getting-started-buildah>

The Rust official images are on Docker hub: <https://hub.docker.com/_/rust>

I was surprised by the size of the image. It is big from 200Mb compressed to 1.2Gb uncompressed. But this is mostly the size of rust files.

I don't like that this images have only the `root` user. I will start from the Debian-11 image and install all I need as a non-privileged user `rustdevuser`.

In `WSL2 terminal` pull the image from Docker hub:

```bash
podman pull docker.io/library/debian:bullseye-slim
```

I wrote the bash script `rust_dev_cargo_img.sh`

Run it with

```bash
sh rust_dev_cargo_img.sh
```

This will create the image `rust_dev_cargo_img`.

The scripts sre just bash scripts and are super easy to read, follow, learn and modify. Much easier than Dockerfile. You can even run the commands one by one in the `WSL2 terminal` and inspect the container to debug the building process.

## Rust development in a Docker container

There is a lot of benefits making a development environment in a container.

We want that everything is isolated/sandboxed and cannot affect our host system (WSL2 and Win10).

We also don't want to make any changes to our system because of Rust tools or our project needs.

We can have simultaneously more containers, each with a different version of Rust or a different toolchain with all the necessary configuration and tools. We can easily transfer the container to another system or to another developer and use it exactly as it is configured. Effortlessly.

We can save an `container image` with the source code and the exact state of all developer tools for a particular app version. Then years later we can still work on it for some security patches without the fear that new tools will break the old source code.

You will see that everybody uses `podman run`, but this is essentially 4 commands in one: `pull` from a repository, `create` the container, `start` or `attach` to the container and exec the bash in interactive mode. I like to use this commands separately, because it makes more sense for learning.

Create the container with a fixed name rust_dev_cargo_cnt:

--name - the container name will be `rust_dev_cargo_cnt`  
-ti - we will use the container interactively in the terminal  

```bash
podman create -ti --name rust_dev_cargo_cnt docker.io/bestiadev/rust_dev_cargo_img:latest/
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

First let find the rustc version:

```bash
cargo --version
  cargo 1.59.0 (49d8809dc 2022-02-10)
```

Let create and run a small Rust program:

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

When we exited the container we returned to `WSL2 terminal`.

The container still exists and is still running. Check with `podman ps -a`.

To interact with it again, repeat the previous command `podman exec -it rust_dev_cargo_cnt bash`.

This container does not work with VSCode and we will not need it any more. If you use another editor, you can use this image/container as base for your image/container for your editor.

Remove the container with:

```bash
podman rm rust_dev_cargo_cnt -f
```

## Docker image with VSCode server and extensions

I use VSCode as my primary code editor in Windows. It works fine remotely with WSL2 (Debian Linux) with the `Remote - WSL` extension.

There exists a `Remote - Containers` extension, that lets you use a Docker container as a full-featured development environment. I tried it. There are a lot of `automagic` functions in this extension. But for some reason `automagic` never worked for me. I must always go painfully step-by-step and discover why the `automagic` does not work in my case. Always!

I decided to go with the `SSH` communication for remote developing. That is more broadly usable. We need to create an image that contains the VSCode server and extensions.

In `WSL2 terminal` run the bash script `rust_dev_vscode_img.sh` will create the image `rust_dev_vscode_img`.

Run it with:

```bash
sh rust_dev_vscode_img.sh
```

This is based on the image `rust_dev_cargo_img` and adds the VSCode server and extensions.
VSCode is great because of its extensions. Most of these extensions are installed inside the image `rust_dev_vscode_img`:

- streetsidesoftware.code-spell-checker
- matklad.rust-analyzer
- davidanson.vscode-markdownlint
- 2gua.rainbow-brackets
- dotjoshjohnson.xml
- lonefy.vscode-js-css-html-formatter
- serayuzgur.crates

Other extensions you can add manually through VSCode, but then it is not repeatable. Better is to modify the script and recreate the image `rust_dev_vscode_img.sh`.

## Push image to docker hub

I signed in to hub.docker.com.

In Account settings - Security I created an access token. This is the password for `podman login`. It is needed only once.

Then I created a new image repository with the name `rust_dev_vscode_img` and tag `latest`. Docker is helping with the push command syntax. I use `podman`, so I just renamed `docker` to `podman`. The same for `rust_dev_squid_img`.

In `WSL2 terminal`:

```bash
podman login --username bestiadev docker.io
# type access token
podman push docker.io/bestiadev/rust_dev_cargo_img:latest
podman push docker.io/bestiadev/rust_dev_cargo_img:cargo-1.59.0

podman push docker.io/bestiadev/rust_dev_vscode_img:latest
podman push docker.io/bestiadev/rust_dev_vscode_img:vscode-1.66.0
podman push docker.io/bestiadev/rust_dev_vscode_img:cargo-1.59.0

podman push docker.io/bestiadev/rust_dev_squid_img:latest
podman push docker.io/bestiadev/rust_dev_squid_img:squid-3.5.27-2
```

It takes some time to upload more than 1.4 Gb.

## enter the container as root

Sometimes you need to do something as `root`.  
You don't need to use `sudo`. Just open the container as `root` user.  

```bash
podman exec -it --user root rust_dev_vscode_cnt bash
```

## sizes

Rust is not so small. I saved some 600MB of space just deleting the docs folder, that actually noone needs.  
docker.io/bestiadev/rust_dev_squid_img  squid3.5.27-2  168 MB
docker.io/bestiadev/rust_dev_cargo_img  cargo-1.59.0  1.08 GB
docker.io/bestiadev/rust_dev_vscode_img cargo-1.59.0  1.32 GB

## Users keys for SSH

We need to create 2 SSH keys, one for the `SSH server` identity `host key` of the container and the other for the identity of `rustdevuser`. This is done only once. To avoid old cryptographic algorithms I will force the new `ed25519`.  
In `WSL2 terminal`:

```bash
# generate user key
ssh-keygen -f ~/.ssh/rustdevuser_key -t ed25519 -C "info@my.domain"
# give it a passphrase and remember it, you will need it
# generate host key
mkdir  -p ~/.ssh/rust_dev_pod_keys/etc/ssh
ssh-keygen -A -f ~/.ssh/rust_dev_pod_keys

# check the new files
# list user keys
ls -l ~/.ssh | grep "rustdevuser"
# -rw------- 1 luciano luciano  2655 Apr  3 12:03 rustdevuser_key
# -rw-r--r-- 1 luciano luciano   569 Apr  3 12:03 rustdevuser_key.pub

# list host keys
ls -l ~/.ssh/rust_dev_pod_keys/etc/ssh
# -rw------- 1 luciano luciano 1381 Apr  4 10:44 ssh_host_dsa_key
# -rw-r--r-- 1 luciano luciano  603 Apr  4 10:44 ssh_host_dsa_key.pub
# -rw------- 1 luciano luciano  505 Apr  4 10:44 ssh_host_ecdsa_key
# -rw-r--r-- 1 luciano luciano  175 Apr  4 10:44 ssh_host_ecdsa_key.pub
# -rw------- 1 luciano luciano  399 Apr  4 10:44 ssh_host_ed25519_key
# -rw-r--r-- 1 luciano luciano   95 Apr  4 10:44 ssh_host_ed25519_key.pub
# -rw------- 1 luciano luciano 2602 Apr  4 10:44 ssh_host_rsa_key
# -rw-r--r-- 1 luciano luciano  567 Apr  4 10:44 ssh_host_rsa_key.pub
```

The same keys we will need in Windows, because the VSCode client works in windows. We will copy them:
In `WSL2 terminal`:

```bash
setx.exe WSLENV "USERPROFILE/p"
echo $USERPROFILE/.ssh/rustdevuser_key
cp -v ~/.ssh/rustdevuser_key $USERPROFILE/.ssh/rustdevuser_key
cp -v ~/.ssh/rustdevuser_key.pub $USERPROFILE/.ssh/rustdevuser_key.pub
cp -v -r ~/.ssh/rust_dev_pod_keys $USERPROFILE/.ssh/rust_dev_pod_keys
# check
ls -l $USERPROFILE/.ssh | grep "rustdevuser"
ls -l $USERPROFILE/.ssh/rust_dev_pod_keys/etc/ssh
```

## Volumes or mount restrictions

I don't want that the container can access any file on my local system.

This is a "standalone" development container and everything must run inside.

The files can be cloned/pulled from Github or copied manually with `podman cp`.

## Network Inbound restrictions

I would like to restrict the use of the network from/to the container.

When using Podman as a rootless user, the network is setup automatically. Only the `localhost` can be used. The container itself does not have an IP Address, because without root privileges, network association is not allowed. Port publishing as rootless containers can be done for "high ports" only. All ports below `1024` are privileged and cannot be used for publishing.

I hope/think that all inbound ports are closed by default and I need to explicitly expose them manually.

## Network Outbound restrictions with Squid proxy in container

I would like to limit the access to the internet only to whitelisted domains:

crates.io, github.com,...

Some malware could want to "call home" and I will try to disable this.

What I need is a "proxy" or "transparent proxy". I will use the leading open-source proxy `Squid`, but in a container.

It can restrict both HTTP and HTTPS outbound traffic to a given set of Internet domains, while being fully transparent for instances in the private subnet.

<https://aws.amazon.com/blogs/security/how-to-add-dns-filtering-to-your-nat-instance-with-squid/>

I want to use this proxy for the container `rust_dev_vscode_cnt`. Container-to-container networking can be complex.

Podman works with `pods`, that make networking easy. This is usually the simplest approach for two rootless containers to communicate. Putting them in a `pod` allows them to communicate directly over `localhost`.

First create a modified image for Squid with (run inside the rustprojects/docker_rust_development folder):

```bash
sh rust_dev_squid_img.sh
```

If you need, you can modify the file `etc_squid_squid.conf` to add more whitelisted domains. Then run `sh rust_dev_squid_img.sh` to build the modified image.

## One pod with 2 containers

Podman and Kubernetes have the concept of pods, where more containers are tightly coupled. Here we will have the `rust_dev_vscode_cnt` that will use `rust_dev_squid_cnt` as a proxy. From outside the pod is like one entity with one address. All the network communication goes over the pod. Inside the pod everything is in the `localhost` address. That makes it easy to configure.

Inside the container `rust_dev_vscode_cnt` I want that everything goes through the proxy. This env variables should do that:

`http_proxy`, `https_proxy`,`all_proxy`.

Run the bash script to create a new pod `rust_dev_pod` with proxy settings:

```bash
sh rust_dev_pod_create.sh
```

The pod is now running:

```bash
podman pod list
podman ps -a 
```

## SSH from WSL2 Debian

Try the SSH connection from WSL2 to the container:

```bash
ssh -i ~/.ssh/rustdevuser_key -p 2201 rustdevuser@localhost
# Choose `yes` to save fingerprint if asked, just the first time.
# type passphrase
# should work !
# try for example
ls
# ls result: rustprojects
# to exit the container
exit
```

## SSH from windows

Run in `windows cmd prompt` to access the container over SSH from windows:

```bash
# test the ssh connection from Windows cmd prompt
"C:\WINDOWS\System32\OpenSSH\ssh.exe" -i ~\.ssh\rustdevuser_key -p 2201 rustdevuser@localhost
# Choose `y` to save fingerprint if asked, just the first time.
# type passphrase
# should work !
# try for example
ls
# ls result: rustprojects
# to exit the container
exit
```

## debug SSH connection

Sometimes it is needed to debug the connection to the `ssh server`, because the normal error messages are completely useless.  
From `WSL2 terminal` I enter the `container terminal` as `root`:  

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
ssh -i ~/.ssh/githubssh1 -p 2201 rustdevuser@localhost -v
```

To see the listening ports:

```bash
netstat -tan 
```

## VSCode

Open VSCode and install the extension `Remote - SSH`.
In VSCode `F1`, type `ssh` and choose `Remote-SSH: Open SSh configuration File...`, choose  `c:\users\user_name\ssh\config` and type (if is missing):

```bash
Host rust_dev_pod
  HostName localhost
  Port 2201
  User rustdevuser
  IdentityFile ~\.ssh\rustdevuser_key
  IdentitiesOnly yes
```

Save and close.

Then in VSCode `F1`, type `ssh` and choose `Remote-SSH: Connect to Host...` and choose `rust_dev_pod`.  
Choose `Linux` if asked, just the first time.  
Type your passphrase.  
If we are lucky, everything works and VSCode is now inside the container over SSH.  

## VSCode terminal

VSCode has an integrated `VSCode terminal`. It has some advantages for developers that the standard `WSL2 terminal` does not have.
It is great to use it for everything around code in containers. You can open more then one `VSCode terminal` if you need to. For example if you run a web server.

If the `VSCode terminal` is not opened simply press `Ctrl+j` to open it and the same to close it.

Inside `VSCode terminal`, we will create a sample project:

```bash
cd ~/rustprojects
cargo new rust_dev_hello
cd ~/rustprojects/rust_dev_hello
```

This easy command opens a new VSCode window exactly for this project/folder inside the container:

```bash
code .
```

A new VSCode windows will open for the `rust_dev_hello` project. Because of the SSH communication it asks for the passphrase. You can close now all other VSCode windows.

Build and run the project in the `VSCode terminal`:

```bash
cargo run
```

That should work and greet you with "Hello, world!".

Leave VSCode open because the next chapter will continue from here.

## Github in the container

Shortcut: Copy the template for bash script from here: [personal_keys_and_settings.sh](https://github.com/bestia-dev/docker_rust_development/blob/main/personal_keys_and_settings.sh). It contains all the steps from below. You need to personalize it first and save it into Win10 folder `~\.ssh`.  
Then copy it manually into WSL2. Run in `WSL Terminal`:

```bash
setx.exe WSLENV "USERPROFILE/p"
cp -v $USERPROFILE/.ssh/personal_keys_and_settings.sh ~/.ssh/personal_keys_and_settings.sh
# and then run
sh ~/.ssh/personal_keys_and_settings.sh
```

Git inside the container does not yet have your information, that it needs:
In `WSL2 terminal`:

```bash
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.email "info@your.mail"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global user.name "your_name"
podman exec --user=rustdevuser rust_dev_vscode_cnt git config --global -l
```

I like to work with Github over SSH and not over https. I think it is the natural thing for Linux.  
To make SSH client work in the container I need the file with the private key for SSH connection to Github. I already have this in the file `~/.ssh/githubssh1`. I will copy it into the container with `podman cp`.  
Be careful ! This is a secret !
It means that this container I cannot share anymore with anybody. It is now my private container. I must never make an image from it and share it. Never !

In `WSL2 terminal`:

```bash
podman exec --user=rustdevuser rust_dev_vscode_cnt ls -l /home/rustdevuser/.ssh
podman cp ~/.ssh/githubssh1 rust_dev_vscode_cnt:/home/rustdevuser/.ssh/githubssh1
podman exec --user=rustdevuser rust_dev_vscode_cnt chmod 600 /home/rustdevuser/.ssh/githubssh1
podman cp ~/.ssh/githubssh1.pub rust_dev_vscode_cnt:/home/rustdevuser/.ssh/githubssh1.pub
podman exec --user=rustdevuser rust_dev_vscode_cnt ls -l /home/rustdevuser/.ssh
```

The `VSCode terminal` is still opened on the project `rust_dev_hello`.

## SSH Agent

It is comfortable to use the `ssh-agent` to store the passphrase in memory, so we type it only once.

Again attention, that this container has secrets and must not be shared ! Never !

In the `VSCode terminal` (Ctrl+j) run:

```bash
eval $(ssh-agent)
ssh-add /home/rustdevuser/.ssh/githubssh1
# enter your passphrase
```

You can copy the template [sshadd.sh](https://github.com/bestia-dev/docker_rust_development/blob/main/sshadd.sh) from Github and personalize it with you SSH keys file names. Copy the personalized file in win10 folder `~\.ssh`.
Then copy it manually into WSL2 and the container. Run in `WSL Terminal`:

```bash
setx.exe WSLENV "USERPROFILE/p"
echo $USERPROFILE
cp -v $USERPROFILE/.ssh/sshadd.sh ~/.ssh/sshadd.sh  
podman cp ~/.ssh/sshadd.sh rust_dev_vscode_cnt:/home/rustdevuser/.ssh/sshadd.sh  
```

You will then run inside the `VSCode terminal` for each window/project separately:

```bash
sh ~/.ssh/sshadd.sh
```

## Github push

Open `github.com` in the browser and sign in, click `New` and create a new repository named `rust_dev_hello`.

Github is user friendly and shows the standard commands we need to run.

Modify the commands below to **your** Github repository.

In VSCode click on the `Source control` and click `Initialize` and type the commit msg `init`.
Then in `VSCode terminal` run:

```bash
git remote add origin git@github.com:bestia-dev/rust_dev_hello.git
git push -u origin main
```

Done! Check your Github repository.
Always push the changes to Github. So you can destroy this pod/container and create a new empty one, then pull the code from Github and continue developing. Containers are the worst place to have persistent data stored. They can be deleted any second for any reason.
Leave VSCode open because the next chapter will continue from here.

## Existing Rust projects on Github

You probably already have a Rust project on Github. You want to continue its development inside the container.

For an example we will use my PWA+WebAssembly/WASM project `rust_wasm_pwa_minimal_clock`, that needs to forward the port 8001, because our project needs a web server. That is fairly common. I am not a fan of autoForward `automagic` in VSCode, so I disable it in `File-Preferences-Settings` search `remote.autoForwardPorts` and uncheck it to false.

We will continue to use the existing `VSCode terminal`, that is already opened on the folder `/home/rustdevuser/rustprojects/rust_dev_hello`. Just to practice.

Run the commands to clone the repository from Github and open a new VSCode window. We already have the SSH private key and `ssh-agent` running:

```bash
cd /home/rustdevuser/rustprojects/
git clone git@github.com:bestia-dev/rust_wasm_pwa_minimal_clock.git
cd rust_wasm_pwa_minimal_clock
code .
```

The `code .` command will open a new VSCode window in the folder `rust_wasm_pwa_minimal_clock`. Enter the SSH passphrase if asked. In the new VSCode window, we can now edit, compile and run the project. All sandboxed/isolated inside the container. We can now close the other VSCode windows, we don't need it any more.

This example is somewhat more complex, because it is WebAssembly, but it is good for learning. I used the automation tool `cargo-auto` to script a more complex building process. You can read the automation task code in `automation_task_rs/src/main.rs`. On the first build it will download the wasm components and wasm-bindgen. That can take some time. Don't despair.

Now we can build and run the project in `VSCode terminal` (Ctrl+j):

```bash
cargo auto build_and_run
```

In VSCode go to Ports and add the port `4000`.  

Open the browser in Windows:

`http://localhost:4000/rust_wasm_pwa_minimal_clock/`

This is an example of Webassembly and PWA, directly from a docker container.

A good learning example.

## After reboot

After reboot WSL2 can create some network problems for podman.  
We can simulate the WSL2 reboot in `powershell in windows`:

```powershell
Get-Service LxssManager | Restart-Service
```

Before entering any podman command we need first to clean some temporary files, restart the pod and restart the SSh server.  
In `WSL2 terminal`:

```bash
sh rust_dev_pod_after_reboot.sh
```

## VSCode and file copying from win10

It is easy to copy files from Win10 to the VSCode project within the container just with drag&drop.

## Quirks

It is a complex setting. There can be some quirks sometimes.

## ssh could not resolve hostname

Warning: The "ssh could not resolve hostname" is a common error. It is not that big of an issue. I closed everything and restart my computer and everything works fine now.

## Read more

Read more how I use my [Development environment](https://github.com/bestia-dev/development_environment).  

## TODO

Watch the log if the access is restricted to some domains:
podman exec rust_dev_squid_cnt cat /var/log/squid/access.log
podman exec rust_dev_squid_cnt tail -f /var/log/squid/access.log

new image with cargo-crev and cargo_crev_reviews
new image with windows cross compile

## cargo crev reviews and advisory

We live in times of danger with [supply chain attacks](https://en.wikipedia.org/wiki/Supply_chain_attack).  
It is recommended to always use [cargo-crev](https://github.com/crev-dev/cargo-crev)  
to verify the trustworthiness of each of your dependencies.  
Please, spread this info.  
You can also read reviews quickly on the web:  
<https://web.crev.dev/rust-reviews/crates/>  

## open-source and free as a beer

My open-source projects are free as a beer (MIT license).  
I just love programming.  
But I need also to drink. If you find my projects and tutorials helpful,  
please buy me a beer donating on my [paypal](https://paypal.me/LucianoBestia).  
You know the price of a beer in your local bar ;-)  
So I can drink a free beer for your health :-)  
[Na zdravje!](https://translate.google.com/?hl=en&sl=sl&tl=en&text=Na%20zdravje&op=translate) [Alla salute!](https://dictionary.cambridge.org/dictionary/italian-english/alla-salute) [Prost!](https://dictionary.cambridge.org/dictionary/german-english/prost) [Nazdravlje!](https://matadornetwork.com/nights/how-to-say-cheers-in-50-languages/) 🍻
