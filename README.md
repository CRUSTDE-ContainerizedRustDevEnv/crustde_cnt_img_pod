# docker_rust_development

Rust is a fantastic young language that empowers everyone to build reliable and efficient software. It enables simultaneously low-level control without giving up high-level conveniences. But with great power comes great responsibility !  
Rust programs can do any "potentially harmful" things to your system. That is true for any compiled program, Rust is no exception.  
But Rust can do anything also in the compile-time using `build.rs` and `procedural macros`. Even worse, if you open a code editor (like VSCode) with auto-completion (like Rust-analyzer), it will compile the code in the background without you knowing it. And the `build.rs` and `procedural macros` will run and they can do "anything" !  
Even if you are very careful and avoid `build.rs` and `procedural macros`, your Rust project will have a lot of crates in the dependency tree. Any of those can surprise you with some "malware". This is called a "supply chain attack".  
It is very hard to avoid "supply chain attacks" in Rust as things are today. We are just lucky, that the ecosystem is young and small and the malevolent players are waiting for Rust to become more popular. Then they will strike and strike hard.  
We need to be skeptical about anything that comes from the internet. We need to isolate/sandbox it so it cannot harm our system. Docker containers are good for isolation/sandbox. They are not perfect, but they are very good and probably they will get better with time.  
Let learn to do "everything" inside a Docker container and to isolate/sandbox it as much as possible from the underlying system.  

## Docker and  OCI

We all call it Docker, but [Docker](https://www.docker.com/) is just a well known company name with the funny whale logo.
They developed and promoted Linux containers. Then they helped to create an open industry standards around container formats and runtimes. This standard is now called OCI (Open Container Initiative). So the correct name is "OCI containers" and "OCI images".  
But "OCI" is a so boring name. I will still use the terms "Docker containers" and "Docker images" even if other companies can work interchangeably with them because of the OCI standards.  
And there are alternatives to use Docker software that I will explore here.  

## Install Podman in Win10 + WSL2 + Debian 11(Bullseye)

[Podman](https://podman.io/) is a **daemonless**, open source, Linux native tool designed to work with Open Containers Initiative (OCI) Containers and Container Images. Containers under the control of Podman can be run by a **non-privileged user**. The CLI commands of the Podman ***"Container Engine"*** are practically identical to the Docker CLI. Podman relies on an OCI compliant ***"Container Runtime"*** (runc, crun, runv, etc) to interface with the operating system and create the running containers.

I already wrote some information how to install and use the combination of Win10 + WSL2 + Debian11(Bullseye):  
<https://github.com/LucianoBestia/win10_wsl2_debian11>  

Podman is available from the Debian11 package manager.  
Let's install it as rootless  
<https://podman.io/getting-started/installation>:

```bash
sudo apt-get update
sudo apt-get install podman
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

``` bash
podman version
```

## Using Podman

Using the Podman CLI is just the same as using Docker CLI.  
<https://podman.io/getting-started/>  
We have no images for now:

```bash
podman images
```

The words "image" and "container" are somewhat confusing. Super simplifying: When it runs it is a "container". If it does not run it is an "image". The image is just an "installation file". The containers can be `started` and `stopped` or `attached` and `detached`, but they are "run" only one time.

For test, run a sample container. It is a web server.  
-d means it is run in a detached mode.  
-t adds a pseudo-tty to run arbitrary commands in an interactive shell  
-p stays for port  
The run command will download/pull the image if needed.

```bash
podman run -dt -p 8080:80/tcp docker.io/library/httpd
```

List all containers:

```bash
podman ps -a
```

Testing the httpd container:

```bash
curl http://localhost:8080
```

Finally you can remove the "last" container we used:

```bash
podman rm -l 
```

You can also remove the image, because this was just a test:

```bash
podman rmi -l 
```

## Buildah for our Rust development image

Buildah is a replacement for the `docker build` command. It is easier to incorporate into scripts. It is pronounced exactly as Builder, but with a Bostonian accent ;-)  
The Rust official images are on Docker hub: <https://hub.docker.com/_/rust>  
I was surprised by the size of the image. It is big from 200Mb compressed to 1.2Gb uncompressed. But this is mostly the size of rust files. I tried to build a different image, but the result was also so big.  
Pull the image from Docker hub:

```bash
podman pull docker.io/library/rust:slim
```

The official image of Rust is missing Git. This is a good excuse to learn a little about Buildah.  
<https://opensource.com/article/18/6/getting-started-buildah>  

I will write a simple bash script `buildah_rust_development1.sh`  
Run it with `sh buildah_rust_development1.sh`  
First, it will remove the image/container `rust_development1` if exists.  
Then it will create a container from the official Rust image.  
It will install git.  
Finally it will commit this container and create the image `rust_development1`.  
This is the image we will use for our containers.  

## Rust development in a Docker container

There is a lot of benefits making a development environment in a container.  
We want that everything is isolated/sandboxed and cannot affect our host system (WSL2 and Win10).  
We also don't want to make any changes to our system because of Rust tools or our project needs.  
We can have simultaneously more containers, each with a different version of Rust or a different toolchain with all the necessary configuration and tools. We can easily transfer the container to another system and use it exactly as it is configured. Effortlessly.  

Everybody uses `podman run`, but this is essentially 3 commands in one: `pull` from a repository, `create` the container and `start` or `attach` to the container. I would like to use it separately, because it makes more sense for learning.  

Create the container with a fixed name rust_dev1:  
--name - the container name will be `rust_dev1`  
-ti - we will use the container interactively in the terminal  

```bash
podman create -ti --name rust_dev1 localhost/rust_development1
```

We can list the existing containers with:

```bash
podman ps -a
```

Now we can start the container and interact with its bash terminal:
-ai - attach and interactively  

```bash
podman start -ai rust_dev1
```

We are now inside the container in the terminal and we can use `cargo`, `rustup` and other rust tools. The files we create will be inside the container. We are `root` inside this container, so we will put our projects in the `/root/projects` directory.  
This container is started from Podman without `root access` to the host system !  
This is a small, but important difference between Docker and Podman.  
Let create and run a small Rust program:  

```bash
cd /root
mkdir projects
cd projects
cargo new rust_dev_hello
cd rust_dev_hello
cargo run
```

We can exit the container now with the command  

```bash
exit
```

The container still exists, but is not started. Check with `podman ps -a`.  
To start it again, repeat the previous command `podman start -ai rust_dev1`.  
Be careful that it is very easy to remove the container and loose the files inside it with `podman rm rust_dev1 -f` or the dangerous `podman rm -a`. We will try to always use a Github remote repository to overcome this problem.  

## VSCode from Windows to WSL2 to container
  
I use VSCode as my primary code editor in Windows. It works fine remotely with WSL2 (Debian Linux) with the `Remote - WSL` extension.  
There is also a `Remote - Containers` extension, that lets you use a Docker container as a full-featured development environment. First install this extension in VSCode.  
<https://www.jonathancreamer.com/setting-up-wsl2-and-the-vscode-containers-plugin/>  
We need to change 2 settings because we want to use Podman instead of Docker and we want to execute all commands inside WSL2.  
In VSCode open File-Preferences-Settings or Ctrl+,  
Search for `remote.containers.dockerPath`. Type `/usr/bin/podman`.  
Search for `remote.containers.executeInWSL` and enable it.

In VSCode click on the icon `Remote Explorer`. Up-right instead of `WSL Targets` choose `Containers`. There is a list of containers and among them our `localhost/rust_development1 rust_dev1`. Right click on it and choose `Attach in New Window`.  
On first run, VSCode will `Start: Downloading VS Code Server` into the container. That can take some time.  
VSCode is now working inside the container. In the left bottom corner there is the name of the container in green.  
`File - Open Folder` and choose our existing project `/root/projects/rust_dev_hello`.  
The next time you can use `File-Open Recent` to open the project easily.  Or click on the `Remote explorer` icon and choose directly the `project/folder` inside the container, right-click and `Open Folder in Container`.  

If the VSCode Terminal is not opened press `Ctrl+j` to open it. Then write:  

```bash
cargo run
```

That should work!  
We can now edit, compile and run our Rust project in VSCode inside the container.  

## Push changes to Github

I like to work with Github over SSH and not over https.  
To make SSH work I need the file with the private key for SSH connection. I already have this one in WSL2. I will copy it into the container.  
Be careful ! This is a secret !  
It means that this container I cannot share anymore with anybody. It is now my private container. I must never make an image from it and share it. Never !  
From WSL2/Debian bash I can copy files with podman into the container:  

```bash
podman cp ~/.ssh/cert_name rust_dev1:/root/.ssh/cert_name
podman cp ~/.ssh/cert_name.pub rust_dev1:/root/.ssh/cert_name.pub
```

It is comfortable to use the ssh-agent to store the passphrase in memory, so we type it only once.  
Again attention, that this container has secrets and must not be shared ! Never !
Open VSCode, click on the `Remote Explorer` icon, choose `Containers`, right-click on `localhost/rust_development1 rust_dev1` and click `Attach in New Window`, then open the folder `projects/rust_dev_hello`.  
In the VsCode terminal (Ctrl+j) run:  

```bash
eval `ssh-agent`
ssh-add /root/.ssh/cert_name
# type your passphrase
```

Open github.com in the browser and sign in, click New and create a new repository named `rust_dev_hello`.  
Github is user friendly and shows the standard commands we need to run.  
In the VsCode terminal run:  

```bash
git init
git add *
git commit -m "first commit"
git branch -M main
git remote add origin git@github.com:LucianoBestia/rust_dev_hello.git
git push -u origin main
```

Done! Check your Github repository.

Warning: The "ssh could not resolve hostname" is a common error. It is not that big of an issue. I closed everything and restart my computer and everything works fine now.  

## Existing Rust projects on Github

You probably already have a Rust project on Github. You want to continue its development inside the container.  
In Debian, open the bash terminal of the container:  

```bash
podman start -ai rust_dev1
```

In the container bash you need this only once to remember your passphrase:  

```bash
eval `ssh-agent`
ssh-add /root/.ssh/cert_name
# type your passphrase
```

Then the commands to clone the repository from Github:

```bash
cd root/projects/
git clone git@github.com:LucianoBestia/reader_for_microxml.git
cd reader_for_microxml
ls
```

Open VSCode, click on the `Remote Explorer` icon, choose `Containers`, right-click on `localhost/rust_development1 rust_dev1` and click `Attach in New Window`.  
In the new VSCode Window `File-Open Folder` and choose `/root/projects/reader_for_microxml`.
We can now edit, compile and run the project. All sandboxed/isolated inside the container.  
Always push the changes to Github. So you can delete this container and create a new one, pull the code and continue developing. Containers are the worst place to have persistent data stored. They can be deleted in a second.  

## VSCode tools

VSCode is great because of its extensions. Most of these extensions need to be installed inside the container.  
From VSCode is easy to manually install these extensions "inside the container", but it is not repeatable.  
I found an unofficial way to do it when building the image. But it is fragile, this can change any time.  
I made a script `buildah_rust_development2.sh` with the needed code.  
First you need to know the exact `commit_sha` of your VSCode client. Click on `Help-About` and `Copy` it from there.  
Then if needed, replace the old one inside `buildah_rust_development2.sh`.  
Build the new image:  

```bash
sh buildah_rust_development1.sh
```

Then create a container from that image:  

```bash
podman create -ti --name rust_dev2 localhost/rust_development2
```

Open VSCode, click on the `Remote Explorer` icon, choose `Containers`, right-click on `localhost/rust_development2 rust_dev2` and click `Attach in New Window`.  
This time the extensions should be already installed inside the container:  

- rust-analyzer by matklad for auto-completion
- Code Spell Checker from Street Side Software  
- markdownlint from David Anson
- Rainbow Brackets from 2gua
