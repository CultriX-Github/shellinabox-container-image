# Use a minimal CentOS 7 image for a smaller footprint.
FROM centos:7

# Define build-time arguments for user and group IDs.
ARG SIAB_USERID=1000
ARG SIAB_GROUPID=1000

# Set environment variables for Shell in a Box configuration.
ENV SIAB_USERCSS="Normal:+/etc/shellinabox/options-enabled/00+Black-on-White.css,Reverse:-/etc/shellinabox/options-enabled/00_White-On-Black.css;Colors:+/etc/shellinabox/options-enabled/01+Color-Terminal.css,Monochrome:-/etc/shellinabox/options-enabled/01_Monochrome.css"
ENV SIAB_PORT=4200
ENV SIAB_ADDUSER=true
ENV SIAB_USER=guest
ENV SIAB_GROUP=guest
ENV SIAB_PASSWORD=putsafepasswordhere
ENV SIAB_SHELL=/bin/bash
ENV SIAB_HOME=/home/guest
ENV SIAB_SUDO=false
ENV SIAB_SSL=true
ENV SIAB_SERVICE=/:LOGIN
# Default SIAB_PKGS is empty (instead of "none") to prevent issues.
ENV SIAB_PKGS=""
ENV SIAB_SCRIPT=""

# Install necessary packages and clean up.
RUN set -ex && \
    # Ensure EPEL repository is installed and enabled
    yum install -y epel-release && \
    yum-config-manager --enable epel && \
    yum makecache && \
    # Install required packages
    yum install -y \
        openssh-clients \
        sudo \
        curl && \
    # Install Shellinabox separately to handle EPEL issues
    yum install -y shellinabox || true && \
    # Install additional user-defined packages if provided
    [ -n "$SIAB_PKGS" ] && yum install -y $SIAB_PKGS || true && \
    # Clean up to reduce image size
    yum clean all && \
    rm -rf /var/cache/yum /tmp/* /var/tmp/*

# Create user and group.
RUN set -ex && \
    # Ensure /etc/sudoers.d exists
    mkdir -p /etc/sudoers.d && \
    chmod 0755 /etc/sudoers.d && \
    getent group ${SIAB_GROUP} || groupadd -r -g ${SIAB_GROUPID} ${SIAB_GROUP} && \
    useradd -r -l ${SIAB_USER} -u ${SIAB_USERID} -m -g ${SIAB_GROUP} -s ${SIAB_SHELL} -d ${SIAB_HOME} && \
    usermod -aG wheel ${SIAB_USER} && \
    echo "${SIAB_USER} ALL=(ALL) NOPASSWD: /usr/bin/yum" > /etc/sudoers.d/siab-yum && \
    chmod 0440 /etc/sudoers.d/siab-yum

# Expose the Shell in a Box port dynamically.
EXPOSE ${SIAB_PORT}

# Copy the entrypoint script and ensure it is executable.
COPY assets/entrypoint.sh /usr/local/sbin/entrypoint.sh
RUN chmod +x /usr/local/sbin/entrypoint.sh

# Set working directory.
WORKDIR ${SIAB_HOME}

# Switch to the created user.
USER ${SIAB_USER}

# Set the entrypoint and default command.
ENTRYPOINT ["/usr/local/sbin/entrypoint.sh"]
CMD ["shellinabox"]

# Add a health check for Shell in a Box.
HEALTHCHECK --interval=30s --timeout=5s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:${SIAB_PORT} || exit 1
