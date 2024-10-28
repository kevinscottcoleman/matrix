apt-get install python3

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install node 20
nvm install v20.15.1
nvm use v20.15.1

ls -la ./scripts

# run script using node
node ./scripts/index.js