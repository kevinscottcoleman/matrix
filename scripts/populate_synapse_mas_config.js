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

configContents += `
${readFileSync("./configurations/synapse-mas/clients.appendix.yaml", "utf8")}
${readFileSync("./configurations/synapse-mas/keycloak.appendix.yaml", "utf8")}`;

const SYNAPSE_HOST = getEnv("SYNAPSE_FQDN")
  .replace("http://", "https://")
  .replace("https://", "");

const replacements = [
  {
    search: "uri: postgresql://",
    replace: `uri: postgresql://${encodeURIComponent(
      getEnv("POSTGRES_SYNAPSE_MAS_USER")
    )}:${encodeURIComponent(
      getEnv("POSTGRES_SYNAPSE_MAS_PASSWORD")
    )}@postgres-synapse-mas:5432/${encodeURIComponent(
      getEnv("POSTGRES_SYNAPSE_MAS_DB")
    )}`,
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
    replace: `homeserver: ${SYNAPSE_HOST}`,
  },
  {
    search: "endpoint: http://localhost:8008/",
    replace: `endpoint: http://${getEnv("SYNAPSE_FQDN")}/`,
  },
  {
    search: /matrix:\n  homeserver: (.*)\n.*secret: (.*)/,
    replace: (match, homeserver, secret) => {
      const newSecret = getEnv("SYNAPSE_API_ADMIN_TOKEN");
      return `matrix:\n  homeserver: ${homeserver}\n  secret: ${newSecret}`;
    },
    useRegex: true,
  },
  {
    search: "{{SYNAPSE_MAS_SECRET}}",
    replace: getEnv("SYNAPSE_MAS_SECRET"),
  },
  {
    search: "public_base: http://[::]:8080/",
    replace: `public_base: ${getEnv(SYNAPSE_MAS_FQDN)}`, 
  },
  {
    search: "issuer: http://[::]:8080/",
    replace: `issuer: ${getEnv(SYNAPSE_MAS_FQDN)}`,
  },
];

function replaceByRegex(text, searchRegex, replaceFunction) {
  return text.replace(searchRegex, replaceFunction);
}

function populateSynapseMasConfig() {
  replacements.forEach((replacement) => {
    if (replacement.useRegex) {
      configContents = replaceByRegex(
        configContents,
        replacement.search,
        replacement.replace
      );
    } else {
      configContents = configContents
        .split(replacement.search)
        .join(replacement.replace);
    }
  });

  writeFileSync("./configurations/synapse-mas/config.yaml", configContents);
}

module.exports = {
  populateSynapseMasConfig,
};
