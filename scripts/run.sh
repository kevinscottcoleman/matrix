curl -fsSL https://bun.sh/install | bash
export BUN_INSTALL="$HOME/.bun" 
export PATH="$BUN_INSTALL/bin:$PATH"
~/.bun/bin/bun run ./scripts/index.ts