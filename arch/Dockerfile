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
RUN pacman -Syu --noconfirm $SIAB_PKGS && \
    pacman -Scc --noconfirm && \
    groupadd -r -g ${SIAB_GROUPID} ${SIAB_GROUP} && \
    useradd -r -l ${SIAB_USER} -u ${SIAB_USERID} -m -g ${SIAB_GROUP} -s ${SIAB_SHELL} -d ${SIAB_HOME} ${SIAB_USER} && \
    usermod -aG wheel ${SIAB_USER} && \
    echo "${SIAB_USER} ALL=(ALL) NOPASSWD: /usr/bin/pacman" > /etc/sudoers.d/siab-pacman && \
    chmod 0440 /etc/sudoers.d/siab-pacman

EXPOSE 4200

COPY assets/entrypoint.sh /usr/local/sbin/

WORKDIR /home/${SIAB_USER}

USER ${SIAB_USER}

ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]
CMD ["shellinabox"]

HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:4200 || exit 1