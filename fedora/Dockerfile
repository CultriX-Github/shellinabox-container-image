# Use a minimal Fedora image for a smaller footprint.
FROM fedora:latest

# Define build-time arguments for user and group IDs.
ARG SIAB_USERID=1000
ARG SIAB_GROUPID=1000

# Set environment variables for Shell in a Box configuration.
ENV SIAB_USERCSS="Colors:+/usr/share/shellinabox/color.css,Normal:-/usr/share/shellinabox/white-on-black.css,Monochrome:-/usr/share/shellinabox/monochrome.css" \
    # Defines the default CSS styles for the Shell in a Box interface.
    SIAB_PORT=4200 \
    # Sets the port on which Shell in a Box will listen for connections.
    SIAB_ADDUSER=true \
    # Determines whether a new user should be created within the container.
    SIAB_USER=guest \
    # Specifies the username for the user to be created.
    SIAB_GROUP=guest \
    # Specifies the group name for the group to be created.
    SIAB_PASSWORD=putsafepasswordhere \
    # Sets the password for the created user. If left as default, a random password will be generated.
    SIAB_SHELL=/bin/bash \
    # Sets the default shell for the created user.
    SIAB_HOME=/home/guest \
    # Sets the home directory for the created user.
    SIAB_SUDO=false \
    # Determines whether the created user should be given sudo privileges. (Now limited to dnf)
    SIAB_SSL=true \
    # Determines whether Shell in a Box should use SSL.
    SIAB_SERVICE=/:LOGIN \
    # Specifies the services to be exposed through Shell in a Box.
    SIAB_PKGS=none \
    # Specifies additional packages to be installed before starting Shell in a Box.
    SIAB_SCRIPT=none \
    # Specifies a URL to a script that should be executed before starting Shell in a Box.

# Install necessary packages and create user/group.
RUN dnf install -y openssh-clients sudo shellinabox && \
    # Installs required packages, including sudo.
    dnf clean -y all && \
    # Cleans up the dnf cache to reduce image size.
    rm -rf /var/cache/dnf && \
    # Removes the dnf cache directory.
    groupadd -r -g ${SIAB_GROUPID} ${SIAB_GROUP} && \
    # Creates a system group with the specified group ID.
    useradd -r -u ${SIAB_USERID} -m -g ${SIAB_GROUP} -s ${SIAB_SHELL} -d ${SIAB_HOME} ${SIAB_USER} && \
    # Creates a system user with the specified user ID, home directory, and shell.
    usermod -aG wheel ${SIAB_USER} && \
    # Adds the created user to the wheel group (sudo equivalent in fedora).
    echo "${SIAB_USER} ALL=(ALL) NOPASSWD: /usr/bin/dnf" > /etc/sudoers.d/siab-dnf && \
    # Creates a sudoers file to limit the user's sudo privileges to dnf commands.
    chmod 0440 /etc/sudoers.d/siab-dnf

# Expose the Shell in a Box port.
EXPOSE 4200

# Copy the entrypoint script to the container.
COPY assets/entrypoint.sh /usr/local/sbin/

# Set the working directory.
WORKDIR /home/${SIAB_USER}

# Switch to the non-root user.
USER ${SIAB_USER}

# Set the entrypoint and default command for the container.
ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]
CMD ["shellinabox"]

# Add a health check to ensure Shell in a Box is running.
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:4200 || exit 1
