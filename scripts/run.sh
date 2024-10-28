# Install deno
curl -fsSL https://deno.land/install.sh | sh

ls -la ./scripts

# echo current working directory
pwd

# ls -la on output of pwd
ls -la

# run script using deno
/root/.deno/bin/deno -R -W ./scripts/index.ts