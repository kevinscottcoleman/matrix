#!/bin/bash

echo "Current directory: $SCRIPT_DIR"

# Build the Docker image using the Dockerfile in the scripts directory
docker build -t matrix-env-populater -f "./scripts/Dockerfile" .

# Run the Docker container
docker run --rm -v "$(pwd)":/usr/src/app matrix-env-populater