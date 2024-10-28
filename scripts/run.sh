#!/bin/bash

# Change directory to where the Dockerfile is located
# its the current working dir plus /scripts
SCRIPT_DIR="$(pwd)/scripts"

echo "Current directory: $SCRIPT_DIR"

# Build the Docker image using the Dockerfile in the scripts directory
docker build -t matrix-env-populater -f "$SCRIPT_DIR/Dockerfile" .

# Run the Docker container
docker run --rm -v "$(pwd)":/usr/src/app matrix-env-populater