# Install deno
curl -fsSL https://deno.land/install.sh | sh

ls -la ./scripts

# echo current working directory
pwd

# ls -la on output of pwd
ls -la

# run script (pwd + scripts/index.ts) using deno
export SCRIPT_PATH=$(pwd)/scripts/index.ts
echo "Running script: $SCRIPT_PATH"
echo $SCRIPT_PATH
/root/.deno/bin/deno --allow-read --allow-write --allow-env --allow-run --allow-hrtime --no-check $SCRIPT_PATH