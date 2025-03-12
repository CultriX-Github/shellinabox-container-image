FROM archlinux:latest

# Define build-time arguments for user and group IDs.
ARG SIAB_USERID=1000
ARG SIAB_GROUPID=1000

# Set environment variables for Shell in a Box configuration.
ENV SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css"
# Defines the default CSS styles for the Shell in a Box interface.
ENV SIAB_PORT=4200
# Sets the port on which Shell in a Box will listen for connections.
ENV SIAB_ADDUSER=true
# Determines whether a new user should be created within the container.
ENV SIAB_USER=guest
# Specifies the username for the user to be created.
ENV SIAB_GROUP=guest
# Specifies the group name for the group to be created.
ENV SIAB_PASSWORD=putsafepasswordhere
# Sets the password for the created user. If left as default, a random password will be generated.
ENV SIAB_SHELL=/bin/bash
# Sets the default shell for the created user.
ENV SIAB_HOME=/home/guest
# Sets the home directory for the created user.
ENV SIAB_SUDO=false
# Determines whether the created user should be given sudo privileges. (Now limited to apt)
ENV SIAB_SSL=true
# Determines whether Shell in a Box should use SSL.
ENV SIAB_SERVICE=/:LOGIN
# Specifies the services to be exposed through Shell in a Box.
ENV SIAB_PKGS=none
# Specifies additional packages to be installed before starting Shell in a Box.
ENV SIAB_SCRIPT=none
# Specifies a URL to a script that should be executed before starting Shell in a Box.

# Install necessary packages and create user/group.
#
# This RUN command executes a series of commands to install packages, clean the package cache,
# create a user and group, and configure sudo privileges for the user.
#
# Parameters:
# - $SIAB_PKGS: A space-separated list of additional packages to be installed before starting Shell in a Box.
#
# Return:
# - None. The RUN command updates the system, installs packages, creates user/group, and configures sudo.
RUN pacman -Syu --noconfirm $SIAB_PKGS && \
    pacman -Scc --noconfirm && \
    groupadd -r -g ${SIAB_GROUPID} ${SIAB_GROUP} && \
    useradd -r -l ${SIAB_USER} -u ${SIAB_USERID} -m -g ${SIAB_GROUP} -s ${SIAB_SHELL} -d ${SIAB_HOME} ${SIAB_USER} && \
    usermod -aG wheel ${SIAB_USER} && \
    echo "${SIAB_USER} ALL=(ALL) NOPASSWD: /usr/bin/pacman" > /etc/sudoers.d/siab-pacman && \
    chmod 0440 /etc/sudoers.d/siab-pacman

EXPOSE 4200

# Copy the entrypoint script into the container.
#
# This COPY command copies the entrypoint script from the host machine to the container.
#
# Parameters:
# - assets/entrypoint.sh: The path to the entrypoint script on the host machine.
# - /usr/local/sbin/: The destination directory in the container where the script will be copied.
#
# Return:
# - None. The COPY command copies the script into the container.
COPY assets/entrypoint.sh /usr/local/sbin/

# Set the working directory for subsequent commands.
#
# This WORKDIR command sets the working directory for any RUN, CMD, ENTRYPOINT, COPY, or ADD instructions that follow it in the Dockerfile.
#
# Parameters:
# - /home/${SIAB_USER}: The path to the user's home directory in the container.
#
# Return:
# - None. The WORKDIR command sets the working directory.
WORKDIR /home/${SIAB_USER}

# Set the user for subsequent commands.
#
# This USER command sets the user and group to be used when running any subsequent commands.
#
# Parameters:
# - ${SIAB_USER}: The username of the user to be used.
#
# Return:
# - None. The USER command sets the user and group.
USER ${SIAB_USER}

# Set the entrypoint for the container.
#
# This ENTRYPOINT command sets the command that will be executed when the container starts.
#
# Parameters:
# - ["/usr/local/sbin/entrypoint.sh"]: The command to be executed as the entrypoint.
#
# Return:
# - None. The ENTRYPOINT command sets the entrypoint.
ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]

# Set the default command for the container.
#
# This CMD command sets the default command to be executed when the container starts if no command is provided.
#
# Parameters:
# - ["shellinabox"]: The command to be executed as the default command.
#
# Return:
# - None. The CMD command sets the default command.
CMD ["shellinabox"]

# Define a healthcheck for the container.
#
# This HEALTHCHECK command defines a command to check the health of the container.
#
# Parameters:
# - --interval=30s: The interval at which to check the health.
# - --timeout=5s: The maximum time to wait for a response from the health check.
# - --start-period=5s: The time to wait before starting the health checks.
# - --retries=3: The number of times to retry the health check before considering it a failure.
# - CMD curl -f http://localhost:4200 || exit 1: The command to execute for the health check.
#
# Return:
# - None. The HEALTHCHECK command defines the healthcheck.
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:4200 || exit 1