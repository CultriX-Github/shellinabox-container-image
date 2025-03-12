#!/bin/bash

# Enable strict mode for better error handling.
set -euo pipefail

# Function to generate a random hexadecimal string.
hex() {
    openssl rand -hex 8
}

echo "Preparing container..."

# Base command for running Shell in a Box.
COMMAND="shellinaboxd --debug --no-beep --disable-peer-check -u ${SIAB_USER} -g ${SIAB_GROUP} -c /var/lib/shellinabox -p ${SIAB_PORT} --user-css ${SIAB_USERCSS}"
# Constructs the base command to start Shell in a Box with specified user, group, port, and CSS.

# Install additional packages if specified.
if [ "$SIAB_PKGS" != "none" ]; then
    sudo yum install -y "$SIAB_PKGS"
    # Installs the packages specified in SIAB_PKGS, using sudo.
    [[ "$SIAB_PKGS2" != "none" ]] && sudo yum install -y "$SIAB_PKGS2"
    # Installs the packages specified in SIAB_PKGS2, using sudo if SIAB_PKGS2 is not none.
    sudo yum clean all
    # Cleans up the yum cache using sudo.
fi

# Disable SSL if SIAB_SSL is not true.
if [ "<span class="math-inline">SIAB\_SSL" \!\= "true" \]; then
COMMAND\+\=" \-t"
\# Adds the \-t flag to the Shell in a Box command to disable SSL\.
fi
\# Create a user if SIAB\_ADDUSER is true\.
if \[ "</span>{SIAB_ADDUSER}" == "true" ]; then
    # Generate a random password if the default password is used.
    if [ "<span class="math-inline">\{SIAB\_PASSWORD\}" \=\= "putsafepasswordhere" \]; then
SIAB\_PASSWORD\=</span>(hex)
        echo "Autogenerated password for user ${SIAB_USER}: <span class="math-inline">\{SIAB\_PASSWORD\}"
fi
\# Set the user's password\.
echo "</span>{SIAB_USER}:${SIAB_PASSWORD}" | chpasswd
    # Sets the password for the created user using chpasswd.
    unset SIAB_PASSWORD
    # Unsets the password variable for security.
fi

# Add services to the Shell in a Box command.
for service in ${SIAB_SERVICE}; do
    COMMAND+=" -s ${service}"
    # Adds each service specified in SIAB_SERVICE to the Shell in a Box command.
