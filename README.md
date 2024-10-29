# 🚀 Matrix Server Setup Guide

Welcome to your one-stop guide to deploying a Matrix server using this repository! Let's get you up and running with the power of **Coolify** and a sprinkle of **Docker** magic. 🐳✨

---

## 📋 Prerequisites

- **Coolify**: For easy self-hosting and app management (makes your life way simpler!)
- **A Keen Spirit**: Get ready to embark on a tech adventure! 🎒🧑‍💻

---

## ⚙️ Step-by-Step Setup

### 1. Install Coolify
Get started by installing Coolify on your server. For instructions, visit [Coolify Self-Hosted](https://coolify.io).

### 2. Create Your Project
1. In Coolify, navigate to **Projects** and select **Create New Project**.
2. Within your new project, add a resource and select **Keycloak with Postgres**.
3. Customize your service name, admin user, admin password, and database to suit your preferences. 🎨
4. **Deploy** and wait for the magic to happen. 🧙‍♂️✨

### 3. Configure Keycloak
1. Open the URL of your freshly deployed Keycloak instance.
2. Log in with your admin credentials.
3. Create a new realm, give it a unique name, and you're set! ✨

### 4. Deploy Your Matrix Server Containers
1. Return to Coolify and enter your project.
2. Add a new resource from this GitHub repository (or your fork).
3. Set **Build Type** to "Docker Compose", leave defaults, and click **Continue**.
4. Customize the build command to:
   ```bash
   chmod +x ./scripts/run.sh && ./scripts/run.sh && docker compose -f ./docker-compose.yml build
   ```
   🔧 This script prepares the required configuration files from your `.env` and keeps configurations updated during deployments.

### 5. Map Domains & Ports
Define the domain mappings for your Matrix server components:

- **Synapse**: `synapse.matrix.your-domain.com` (Port: 8008)
- **Sliding Sync Server**: `sync.matrix.your-domain.com` (Port: 8009)
- **MAS**: `mas.matrix.your-domain.com` (Port: 8080)
- **Nginx (Main Entry)**: `matrix.your-domain.com` (Port: 80)

📝 **Tip**: Ensure nginx is the primary entry point for clients.

### 6. Configure Environment Variables
1. In Coolify, navigate to **Environment Variables**.
2. Enable **Developer View** and paste in your `.env.example` content.
3. Adjust variables as needed (refer to comments for guidance).
4. Save your changes and switch back to **Normal View** for future variable tweaks.

### 7. Deploy and Celebrate! 🎉
1. Hit **Deploy** and watch everything come to life.
2. Once successful, access your Matrix server at your designated domain. Test Synapse with the message: "It works! Synapse is running."

🔗 **Connect clients** to your Matrix server using the nginx-mapped domain: `matrix.your-domain.com`.

---

Enjoy your newly deployed Matrix server! 🎊 If you encounter any hiccups, remember: tech adventures always include a bit of troubleshooting magic! 🧙‍♀️💻