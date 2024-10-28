# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash

# Load nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install node 20
nvm install v20.15.1
nvm use v20.15.1

# Install npx
npm i -g npx

ls -la ./scripts

# run script using ts-node
npx ts-node ./scripts/index.ts