[//]: # (auto_md_to_doc_comments segment start A)

# CRUSTDE - Containerized Rust Development Environment

Development project name: crustde_cnt_img_pod

**02. Tutorial for CRUSTDE - Containerized Rust Development Environment. Rust - Hack Without Fear and Trust! (2022-03)**  
***version: 3.0  date: 2022-09-06 author: [bestia.dev](https://bestia.dev) repository: [GitHub](https://github.com/CRUSTDE-Containerized-Rust-DevEnv/crustde_cnt_img_pod)***  

 ![maintained](https://img.shields.io/badge/maintained-green)
 ![ready_for_use](https://img.shields.io/badge/ready_for_use-green)

 ![logo](https://raw.githubusercontent.com/CRUSTDE-Containerized-Rust-DevEnv/CRUSTDE-Containerized-Rust-DevEnv/main/images/crustde_250x250.png)
 crustde_cnt_img_pod is a member of the [CRUSTDE-Containerized-Rust-DevEnv](https://github.com/orgs/CRUSTDE-Containerized-Rust-DevEnv/repositories?q=sort%3Aname-asc) project.

 [![Lines in md](https://img.shields.io/badge/Lines_in_markdown-932-green.svg)](https://github.com/CRUSTDE-Containerized-Rust-DevEnv/crustde_cnt_img_pod/)
 [![Lines in bash scripts](https://img.shields.io/badge/Lines_in_bash_scripts-1535-blue.svg)](https://github.com/CRUSTDE-Containerized-Rust-DevEnv/crustde_cnt_img_pod/)

 [![License](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/CRUSTDE-Containerized-Rust-DevEnv/crustde_cnt_img_pod/blob/master/LICENSE)
 ![crustde_cnt_img_pod](https://bestia.dev/webpage_hit_counter/get_svg_image/138544014.svg)

Hashtags: #rustlang #buildtool #developmenttool #tutorial #docker #ssh #container #podman #Linux #OCI  
My projects on GitHub are more like a tutorial than a finished product: [bestia-dev tutorials](https://github.com/bestia-dev/tutorials_rust_wasm).  

Be mesmerized by the spiral_of_madness:

![spiral_of_madness](https://github.com/CRUSTDE-Containerized-Rust-DevEnv/crustde_cnt_img_pod/raw/main/images/spiral_of_madness.png "spiral_of_madness")

## Try it

The installation is just a bunch of bash scripts.  
The scripts are for the Debian OS. Debian can be installed on bare metal or inside Win10+WSL2.  
First download and run the download_scripts.sh. This script will download the rest of the scripts.  
After downloading, you can inspect them to see exactly what they are doing. There are a lot of comments and descriptions inside to make it easy to understand and follow. A more detailed explanation is in this [DEVELOPMENT.md](DEVELOPMENT.md).  

```bash
mkdir -p ~/rustprojects/crustde_install;
cd ~/rustprojects/crustde_install;
# only if curl is not yet installed:
sudo apt install curl
curl -Sf -L https://github.com/CRUSTDE-Containerized-Rust-DevEnv/crustde_cnt_img_pod/raw/main/crustde_install/download_scripts.sh --output download_scripts.sh;
# you can review the bash script, it only creates dirs, download scripts and suggests what script to run next
cat download_scripts.sh; 
sh download_scripts.sh;
```

Every script will show step-by-step instructions on what to do next. That's it!  

This project has also a YouTube video tutorial. Watch it:
<!-- markdownlint-disable MD033 -->
[<img src="https://bestia.dev/youtube/crustde_cnt_img_pod.jpg" width="400px">](https://bestia.dev/youtube/crustde_cnt_img_pod.html)
<!-- markdownlint-enable MD033 -->

Now we can use `CRUSTDE - Containerized Rust Development Environment` from VSCode. The extension `Remote SSH` must be installed. The `~/.ssh/config`
must be set as shown by the installation scripts.  
Open `git-bash` terminal and run VSCode to open a folder inside the container:

```bash
MSYS_NO_PATHCONV=1 code --remote ssh-remote+localhost_2201_rustdevuser_ssh_1 /home/rustdevuser/rustprojects
```

If VSCode cannot connect to the container 99% is to blame the `~/.ssh/known_hosts` file. Try to rename it to `known_hosts.bak` and retry.

## Motivation

Rust is a fantastic young language that empowers everyone to build reliable and efficient software. It enables simultaneously low-level control without giving up high-level conveniences. But with great power comes great responsibility!

Rust programs can do any "potentially harmful" things to your system. That is true for any compiled program, Rust is no exception.

Rust can do anything also in the compile-time using `build.rs` and `procedural macros`. Even worse, if you open a code editor (like VSCode) with auto-completion (like Rust-analyzer), it will compile the code in the background without you knowing it. And the `build.rs` and `procedural macros` will run and they can do "anything"!

Even if you are very careful and avoid `build.rs` and `procedural macros`, your Rust project will have a lot of crates in the dependency tree. Any of those can surprise you with some "malware". This is called a "supply chain attack".

It is very hard to avoid "supply chain attacks" in Rust as things are today. We are just lucky, that the ecosystem is young and small and the malevolent players are waiting for Rust to become more popular. Then they will strike and strike hard. We need to be skeptical about anything that comes from the internet. We need to isolate/sandbox it so it cannot harm our system.  

For a big open-source project, you will not read and understand every line of code. It is impossible because of the sheer size of projects and it is impossible to gain a deep understanding of all the underlying principles, rules and exceptions of everything. And everything is moving and changing fast and continuously. It is impossible to follow all the changes.  
We need to have layered protection between our computer system and some unknown code. In this project, I propose `CRUSTDE - Containerized Rust Development Environment` that will allow some degree of isolation. And in the same time easy to install, transfer and repeat.  

Let's learn to develop "everything" inside a Linux OCI container and to isolate/sandbox it as much as possible from the underlying system.

I have to acknowledge that Linux OCI Containers are not the perfect sandboxing solution. But I believe that it is "good enough" for my `CRUSTDE - Containerized Rust Development Environment`. I expect that container isolation will get better with time (google, amazon, Intel, OpenStack and IBM are working on it).  
It is possible to use the same Linux OCI container also inside a virtual machine for better isolation. For example, My main system is Win10. Inside that, I have WSL2, which is a Linux virtual machine. And inside that, I have Linux OCI Containers. It can just the same work in Debian on bare metal. My opinionated preferences:  

- No files/volumes are shared with the host.  
- The outbound network is restricted to whitelisted domains by a Squid proxy server.  
- The inbound network is allowed only to "published/exposed" ports.  

Yes, there exists the possibility of abusing a kernel vulnerability, but I believe it is hard and they will get patched.  
I didn't choose a true virtualization approach, but it is easy to run the container inside a virtual machine. More layers, more protection.

## Trust in Rust open-source 2022

First I have to talk about TRUST. This is the whole point of this entire project.  
We live in dangerous times for "supply chain attacks" in open-source and it is getting worse. This is a problem we need to address!  
In this project, you don't need to TRUST ME! You can run all the bash commands inside bash scripts line-by-line. My emphasis is to thoroughly comment and describe what is my intention for every single command. You can follow and observe exactly what is going on. This is the beauty of open source. But this is realistic only for very simple projects.  
To be meticulously precise, you still have to trust the Windows code, Linux, GNU tools, drivers, Podman, Buildah, VSCode, extensions, the microprocessor, memory, disc and many other projects. There is no system without an inherent minimal level of TRUST.

## Docker and OCI

We all call it Docker, but [Docker](https://www.docker.com/) is just a well-known company name with a funny whale logo.  
They developed and promoted Linux containers. Then they helped to create an open industry standard around container formats and runtimes. This standard is now called OCI (Open Container Initiative). So the correct name is "Linux OCI containers" and "Linux OCI images". Somebody also calls them just "Linux containers".

There are alternatives to using Docker software that I will explore here.

## Development details

Read the development details in a separate md file:  
[DEVELOPMENT.md](https://github.com/CRUSTDE-Containerized-Rust-DevEnv/crustde_cnt_img_pod/blob/main/DEVELOPMENT.md)

## Changelog

Read the changelog in a separate md file:  
[RELEASES.md](https://github.com/CRUSTDE-Containerized-Rust-DevEnv/crustde_cnt_img_pod/blob/main/RELEASES.md)

## TODO

known-host in windows must be deleted manually.

Nothing on my mind right now.  

## Open-source and free as a beer

My open-source projects are free as a beer (MIT license).  
I just love programming.  
But I need also to drink. If you find my projects and tutorials helpful, please buy me a beer by donating to my [PayPal](https://paypal.me/LucianoBestia).  
You know the price of a beer in your local bar ;-)  
So I can drink a free beer for your health :-)  
[Na zdravje!](https://translate.google.com/?hl=en&sl=sl&tl=en&text=Na%20zdravje&op=translate) [Alla salute!](https://dictionary.cambridge.org/dictionary/italian-english/alla-salute) [Prost!](https://dictionary.cambridge.org/dictionary/german-english/prost) [Nazdravlje!](https://matadornetwork.com/nights/how-to-say-cheers-in-50-languages/) 🍻

[//bestia.dev](https://bestia.dev)  
[//github.com/bestia-dev](https://github.com/bestia-dev)  
[//bestiadev.substack.com](https://bestiadev.substack.com)  
[//youtube.com/@bestia-dev-tutorials](https://youtube.com/@bestia-dev-tutorials)  

[//]: # (auto_md_to_doc_comments segment end A)
