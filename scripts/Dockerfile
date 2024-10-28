# Use an official Node.js runtime as a parent image
FROM node:20

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the project files into the container
COPY . .

RUN ls -la

# Install any needed packages specified in package.json
# RUN npm install

# Specify the command to run your script
CMD ["node", "./scripts/index.js"]