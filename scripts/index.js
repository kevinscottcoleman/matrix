const fs = require("fs");
const path = require("path");

function loadEnvFileIntoEnvVars() {
    const envFilePath = path.join(__dirname, ".env");
    if (!fs.existsSync(envFilePath)) {
        throw new Error(`.env file not found: ${envFilePath}`);
    }

    const envFile = fs.readFileSync(envFilePath, "utf8");
    envFile.split("\n").forEach((line) => {
        const [key, value] = line.split("=");
        process.env[key] = value;
    });
}

loadEnvFileIntoEnvVars();

const {populateSynapseMasConfig } = require("./populate_synapse_mas_config");
const { populateConfigsFromEnv } = require("./populate_configs_from_env");

populateSynapseMasConfig();
populateConfigsFromEnv();