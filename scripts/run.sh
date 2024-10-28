#!/bin/bash

# Echo the current working directory
echo "Current directory: $(pwd)"

# Define the Node.js version you want to use
NODE_VERSION=20

# Run the Docker container using the official Node.js image
#docker run --rm -v "$(pwd)":/usr/src/app -w /usr/src/app node:$NODE_VERSION node ./scripts/index.js
docker run --rm -v ./:/usr/src/app -w /usr/src/app node:$NODE_VERSION ls -la /usr/src/app