const { execSync } = require("child_process");
const { readFileSync, writeFileSync } = require("fs");
const { getEnv } = require("./utils");

const configGenerationCommand =
  "docker run ghcr.io/element-hq/matrix-authentication-service config generate > ./configurations/synapse-mas/template.config.yaml";

execSync(configGenerationCommand);

let configContents = readFileSync(
  "./configurations/synapse-mas/template.config.yaml",
  "utf8"
);

const replacements = [
  {
    search: "uri: postgresql://",
    replace: `uri: postgresql://${getEnv("POSTGRES_SYNAPSE_USER")}:${getEnv(
      "POSTGRES_SYNAPSE_PASSWORD"
    )}@postgres-synapse:5432/${getEnv("POSTGRES_SYNAPSE_DB")}`,
  },
  {
    search: `from: '"Authentication Service" <root@localhost>'`,
    replace: `from: '"${getEnv("SYNAPSE_FRIENDLY_SERVER_NAME")}" <${getEnv(
      "SMTP_USER"
    )}>'`,
  },
  {
    search: `reply_to: '"Authentication Service" <root@localhost>'`,
    replace: `reply_to: '"${getEnv("SYNAPSE_FRIENDLY_SERVER_NAME")}" <${getEnv(
      "ADMIN_EMAIL"
    )}>'`,
  },
  {
    search: "homeserver: localhost:8008",
    replace: `homeserver: ${getEnv("SYNAPSE_HOST")}`,
  },
  {
    search: "endpoint: http://localhost:8008/",
    replace: `endpoint: http://${getEnv("SYNAPSE_FQDN")}/`,
  },
];

export function populateSynapseMasConfig() {
  replacements.forEach((replacement) => {
    configContents = configContents
      .split(replacement.search)
      .join(replacement.replace);
  });

  writeFileSync("./configurations/synapse-mas/config.yaml", configContents);
}
