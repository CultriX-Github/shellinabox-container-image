#!/bin/bash

# Check if a script URL is provided.
if [ "$SIAB_SCRIPT" != "none" ]; then
    # Download the script using curl.
    if ! curl -s -k "$SIAB_SCRIPT" > /prep.sh; then
        # If download fails, print an error message and exit.
        echo "Error downloading script: $SIAB_SCRIPT"
        exit 1
    fi
    # Make the downloaded script executable.
    chmod +x /prep.sh
    # Print a message indicating the script is being run.
    echo "Running $SIAB_SCRIPT..."
    # Execute the downloaded script.
    if ! /prep.sh; then
        # If script execution fails, print an error message and exit.
        echo "Error running script: $SIAB_SCRIPT"
        exit 1
    fi
fi

# Print a message indicating the container is starting.
echo "Starting container..."
# Check if the command-line arguments are equal to "shellinabox".
if [ "$*" = "shellinabox" ]; then
    # If they are, execute the Shell in a Box command.
    echo "Executing: $COMMAND"
    exec "$COMMAND"
else
    # If not, execute the provided command-line arguments.
    echo "Executing: $*"
    exec "$@"
fi