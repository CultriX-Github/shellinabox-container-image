# Shell in a Box Docker Image

A Dockerfile to build a secure and configurable Shell in a Box container image. This image provides web-based terminal access to a Linux environment.

## Table of Contents

- [Introduction](#introduction)
- [Features](#features)
- [Version](#version)
- [Prerequisites](#prerequisites)
- [Usage](#usage)
    - [Pull the Image](#pull-the-image)
    - [Run the Image](#run-the-image)
    - [Examples](#examples)
- [Configuration](#configuration)
    - [Available Configuration Parameters](#available-configuration-parameters)
- [Security Considerations](#security-considerations)
- [Contributing](#contributing)
- [References](#references)
- [License](#license)

## Introduction

This repository contains a Dockerfile for building a Shell in a Box container image. Shell in a Box provides a web-based terminal emulator, allowing you to access a Linux shell through a web browser. This image is designed to be secure, configurable, and easy to use.

## Features

- Secure: Runs Shell in a Box as a non-root user and allows restricting `sudo` privileges.
- Configurable: Provides numerous environment variables to customize the container.
- User Management: Allows creating a default user with configurable username, password, UID, and GID.
- Package Installation: Supports installing additional packages before starting Shell in a Box.
- Script Execution: Enables running a script before starting Shell in a Box.
- Multi-Distribution Support: Provides Dockerfiles and instructions for Ubuntu, CentOS, Fedora, Arch Linux, and NixOS.
- Health Check: Includes a health check to ensure Shell in a Box is running correctly.

## Version

Current Version: **2.20** (or whatever the latest version is)

## Prerequisites

- Docker installed on your system.

## Usage

### Pull the Image

Pull the latest image from Docker Hub:

    docker pull sspreitzer/shellinabox:latest

To pull a specific version, use the tag:

    docker pull sspreitzer/shellinabox:2.20

### Run the Image

To run the image, use the `docker run` command. You can customize the container using environment variables.

    docker run -p 4200:4200 -e SIAB_PASSWORD=mysecretpassword -e SIAB_SUDO=true sspreitzer/shellinabox:latest

This example maps port 4200 on the host to port 4200 in the container, sets the user's password to "mysecretpassword", and enables `sudo` access.

### Examples

**Basic Usage:**

    docker run -p 4200:4200 sspreitzer/shellinabox:latest

This will start the container with the default settings. You can then access Shell in a Box by navigating to `http://<your_docker_host>:4200` in your web browser.

**Running a Custom Script:**

    docker run -p 4200:4200 -e SIAB_SCRIPT=https://example.com/myscript.sh sspreitzer/shellinabox:latest

This will download and execute the script located at `https://example.com/myscript.sh` before starting Shell in a Box.

**Installing Additional Packages:**

    docker run -p 4200:4200 -e SIAB_PKGS="htop vim" sspreitzer/shellinabox:latest

This will install the `htop` and `vim` packages before starting Shell in a Box.

## Configuration

### Available Configuration Parameters

The following environment variables can be used to configure the Shell in a Box container:

- **`SIAB_USERCSS`**: String of configured and enabled CSS extensions. Defaults to the system default list.
- **`SIAB_PORT`**: The port where Shell in a Box should listen. Defaults to `4200`.
- **`SIAB_ADDUSER`**: Whether to create a default user. Defaults to `true`.
- **`SIAB_USER`**: The name of the user. Defaults to `guest`.
- **`SIAB_USERID`**: The numeric ID of the user. Defaults to `1000`.
- **`SIAB_GROUP`**: The primary group of the user. Defaults to `guest`.
- **`SIAB_GROUPID`**: The numeric ID of the primary group of the user. Defaults to `1000`.
- **`SIAB_PASSWORD`**: The password of the user. Defaults to an auto-generated password, printed out on stdout.
- **`SIAB_SHELL`**: The shell of the user. Defaults to `/bin/bash`.
- **`SIAB_HOME`**: The home directory of the user. Defaults to `/home/guest`.
- **`SIAB_SUDO`**: Whether to allow the user to use `sudo`. Defaults to `false`.
- **`SIAB_SSL`**: Whether to enable SSL and create certificates on request. Defaults to `true`.
- **`SIAB_SERVICE`**: Service strings to use for Shell in a Box, separated by whitespace. Defaults to local logins `/:LOGIN`.
- **`SIAB_PKGS`**: Packages to be installed before Shell in a Box starts. Defaults to `none`.
- **`SIAB_SCRIPT`**: Script to download and run before Shell in a Box starts. SSL verification is disabled. Defaults to `none`.

## Security Considerations

- **Password Management:** Avoid setting passwords directly in environment variables, especially in production. Consider using Docker secrets or a dedicated secrets management solution.
- **SSL:** While SSL is enabled by default, ensure you configure it properly for production use. Auto-generated certificates are not suitable for production.
- **`sudo` Access:** Exercise caution when granting `sudo` access. Limit `sudo` privileges to the necessary commands.
- **Script Execution:** Be extremely careful when using the `SIAB_SCRIPT` option. Only download and execute scripts from trusted sources.

## Contributing

Contributions are welcome! Please feel free to submit pull requests or open issues.

## References

- [https://github.com/sameersbn/docker-gitlab/blob/master/README.md](https://github.com/sameersbn/docker-gitlab/blob/master/README.md)
- [https://github.com/spali/docker-shellinabox](https://github.com/spali/docker-shellinabox)
- Shell in a Box: [Link to Shell in a Box project]
- Docker: [Link to Docker documentation]

## License

[Specify the license under which your project is released, e.g., MIT License]