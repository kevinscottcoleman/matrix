curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
nvm install v20.15.1
nvm use v20.15.1
npm i -g npx
ls -la ./scripts
npx ts-node ./scripts/index.ts