#!/bin/bash

set -e  # Exit immediately on error

# Define the default command (interactive shell)
COMMAND="${SIAB_SHELL:-/bin/bash}"

# Check if a startup script is provided and not set to "none"
if [ -n "$SIAB_SCRIPT" ] && [ "$SIAB_SCRIPT" != "none" ]; then
    echo "Downloading startup script from: $SIAB_SCRIPT"

    # Download the script using curl with proper options
    if ! curl -s -L -k "$SIAB_SCRIPT" -o /prep.sh; then
        echo "Error: Failed to download script from $SIAB_SCRIPT"
        exit 1
    fi

    # Ensure the script is executable
    chmod +x /prep.sh

    # Execute the script
    echo "Executing startup script: $SIAB_SCRIPT..."
    if ! /prep.sh; then
        echo "Error: Failed to execute startup script."
        exit 1
    fi
fi

echo "Starting container..."

# If no arguments are provided, start an interactive shell
if [ $# -eq 0 ]; then
    echo "No arguments provided, launching shell: $COMMAND"
    exec "$COMMAND" -l
else
    echo "Executing provided command: $@"
    exec "$@"
fi
