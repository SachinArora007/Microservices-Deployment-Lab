# 🚀 Microservices Deployment Lab — Phase 1
## Basic Architecture Setup + Installing Required Tools on Linux (Ubuntu)

---

## 📐 Architecture Overview

You will build **3 independent services** that talk to each other through Nginx:

```
                        ┌─────────────────────────────────┐
                        │         USER's Browser           │
                        └────────────┬────────────────────┘
                                     │ HTTP (Port 80)
                        ┌────────────▼────────────────────┐
                        │         NGINX (Reverse Proxy)    │
                        │         Port: 80                 │
                        └──┬─────────────┬────────────────┘
                           │             │
              /api/users   │             │  /api/products
         ┌─────────────────▼──┐    ┌────▼──────────────────┐
         │  User Service       │    │  Product Service       │
         │  Spring Boot        │    │  Spring Boot           │
         │  Port: 8081         │    │  Port: 8082            │
         └────────────────────┘    └──────────────────────-┘
                           │
              Angular App  │
         ┌─────────────────▼──┐
         │  Frontend (Angular) │
         │  Served by Nginx    │
         │  Port: 4200 (dev)   │
         │  Port: 80 (prod)    │
         └────────────────────┘

Jenkins: Port 8080
```

### 🔌 Port Summary Table

| Service          | Technology    | Port |
|------------------|---------------|------|
| Angular Frontend | Nginx (prod)  | 80   |
| Nginx Proxy      | Nginx         | 80   |
| User Microservice| Spring Boot   | 8081 |
| Product Microservice | Spring Boot | 8082 |
| Jenkins CI/CD    | Jenkins       | 8080 |

---

## 📁 Project Folder Structure

This is the folder layout you will create on your Linux server:

```
/opt/microservices-lab/
│
├── user-service/            ← Spring Boot microservice #1
│   ├── src/
│   ├── pom.xml
│   └── user-service.jar     ← compiled artifact
│
├── product-service/         ← Spring Boot microservice #2
│   ├── src/
│   ├── pom.xml
│   └── product-service.jar
│
├── frontend/                ← Angular app
│   ├── src/
│   ├── dist/                ← built output served by Nginx
│   └── package.json
│
└── logs/                    ← all service logs go here
    ├── user-service.log
    └── product-service.log
```

---

## 🧰 Phase 1 — Step-by-Step Tool Installation

> **Where to run these commands:** Open a terminal on your Ubuntu Linux machine (or SSH into it from VS Code using the Remote-SSH extension). Run each command one by one and wait for it to finish.

---

### Step 1 — Update the System

**Why:** Always update package lists before installing anything. This ensures you get the latest versions and avoid dependency issues.

```bash
sudo apt update && sudo apt upgrade -y
```

- `sudo` → Run as administrator (super user)
- `apt update` → Refresh the list of available packages
- `apt upgrade -y` → Install all pending updates; `-y` auto-confirms

---

### Step 2 — Install Git

**Why:** Git is used to clone your code from GitHub and by Jenkins to pull the latest code automatically.

```bash
sudo apt install git -y
git --version
```

Expected output: `git version 2.x.x`

---

### Step 3 — Install Java (JDK 17)

**Why:** Spring Boot microservices are Java applications. JDK 17 is the current Long-Term Support (LTS) version.

```bash
sudo apt install openjdk-17-jdk -y
java -version
```

Expected output:
```
openjdk version "17.x.x" ...
```

**Set JAVA_HOME (important for Jenkins and Maven):**

```bash
echo 'export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64' >> ~/.bashrc
echo 'export PATH=$JAVA_HOME/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
echo $JAVA_HOME
```

- `echo '...' >> ~/.bashrc` → Appends the line to your shell config file (runs every time you open a terminal)
- `source ~/.bashrc` → Reloads the config without restarting the terminal

---

### Step 4 — Install Maven

**Why:** Maven is the build tool for Java/Spring Boot projects. It downloads dependencies and compiles the code into a `.jar` file.

```bash
sudo apt install maven -y
mvn -version
```

Expected output:
```
Apache Maven 3.x.x
Java version: 17...
```

---

### Step 5 — Install Node.js and npm

**Why:** Angular is built on Node.js. npm (Node Package Manager) installs Angular and its dependencies.

```bash
# Install NodeSource repository (gives us a newer Node version)
curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash -

# Now install Node.js
sudo apt install nodejs -y

# Verify
node -v
npm -v
```

Expected output:
```
v20.x.x
10.x.x
```

> **Linux tip:** `curl` is a command to download content from a URL. The `|` (pipe) sends that downloaded script directly into `sudo bash -` to be executed.

---

### Step 6 — Install Angular CLI

**Why:** Angular CLI (`ng`) is the tool to create, build, and serve Angular applications.

```bash
sudo npm install -g @angular/cli
ng version
```

- `-g` → Install globally (available system-wide, not just in one folder)

Expected output:
```
Angular CLI: 17.x.x
```

---

### Step 7 — Install Nginx

**Why:** Nginx (pronounced "engine-x") acts as a **reverse proxy** — it receives all browser requests on port 80 and forwards them to the right backend service. It also serves the compiled Angular files.

```bash
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx
```

- `systemctl start nginx` → Start Nginx now
- `systemctl enable nginx` → Make Nginx start automatically on server reboot
- `systemctl status nginx` → Check if it's running (look for `active (running)`)

**Test Nginx:** Open a browser and go to `http://<your-server-ip>`. You should see the Nginx welcome page.

---

### Step 8 — Install Jenkins

**Why:** Jenkins is the CI/CD automation server. It watches your GitHub repository and automatically builds and deploys your app when you push code.

```bash
# Step 8a: Add Jenkins repository key
curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Step 8b: Add Jenkins apt repository
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian-stable binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Step 8c: Update and install Jenkins
sudo apt update
sudo apt install jenkins -y

# Step 8d: Start and enable Jenkins
sudo systemctl start jenkins
sudo systemctl enable jenkins
sudo systemctl status jenkins
```

**Get initial admin password (needed for first login):**

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

Copy that password — you'll need it in Phase 4 (Jenkins setup).

**Access Jenkins:** Open browser → `http://<your-server-ip>:8080`

---

### Step 9 — Create the Lab Directory Structure

**Why:** Keeping all services under `/opt/microservices-lab/` follows Linux best practices. `/opt` is used for optional/third-party software.

```bash
sudo mkdir -p /opt/microservices-lab/{user-service,product-service,frontend,logs}
sudo chown -R $USER:$USER /opt/microservices-lab
ls -la /opt/microservices-lab/
```

- `mkdir -p` → Create directory and all parent directories if they don't exist
- `{user-service,product-service,frontend,logs}` → Brace expansion: creates all 4 folders in one command
- `chown -R $USER:$USER` → Give your current user ownership of the folder (so you don't need `sudo` every time)
- `ls -la` → List all files/folders in detail

---

### Step 10 — Verify All Tools Are Installed

Run this verification script to confirm everything is ready:

```bash
echo "=== Tool Verification ===" && \
echo "Git:     $(git --version)" && \
echo "Java:    $(java -version 2>&1 | head -1)" && \
echo "Maven:   $(mvn -version 2>&1 | head -1)" && \
echo "Node:    $(node -v)" && \
echo "npm:     $(npm -v)" && \
echo "Angular: $(ng version 2>&1 | grep 'Angular CLI')" && \
echo "Nginx:   $(nginx -v 2>&1)" && \
echo "Jenkins: $(systemctl is-active jenkins)" && \
echo "=== All Done ==="
```

---

## ⚠️ Common Errors & Fixes — Phase 1

### ❌ Error: `sudo: apt: command not found`
**Cause:** You are not on a Debian/Ubuntu system.  
**Fix:** This lab is designed for Ubuntu. Use Ubuntu 20.04 or 22.04.

---

### ❌ Error: `java: command not found` after installation
**Cause:** JAVA_HOME not set or terminal not reloaded.  
**Fix:**
```bash
source ~/.bashrc
java -version
```

---

### ❌ Error: `Permission denied` when creating `/opt/microservices-lab`
**Cause:** You didn't use `sudo`.  
**Fix:** Always use `sudo` when creating folders in `/opt`:
```bash
sudo mkdir -p /opt/microservices-lab
```

---

### ❌ Error: Jenkins page not loading on port 8080
**Cause:** Firewall might be blocking the port.  
**Fix:**
```bash
sudo ufw allow 8080
sudo ufw allow 80
sudo ufw allow 22
sudo ufw status
```
- `ufw` = Uncomplicated Firewall (Ubuntu's built-in firewall)

---

### ❌ Error: `ng: command not found`
**Cause:** Angular CLI was installed with `npm` but not in PATH.  
**Fix:**
```bash
export PATH=$PATH:$(npm root -g)/../.bin
# Or reinstall:
sudo npm install -g @angular/cli --force
```

---

## ✅ Phase 1 Recap — Checklist

Before confirming to proceed to Phase 2, verify all of these:

- [ ] System is updated (`apt update && apt upgrade` done)
- [ ] Git installed → `git --version` works
- [ ] Java 17 installed → `java -version` shows `17.x.x`
- [ ] JAVA_HOME is set → `echo $JAVA_HOME` shows a path
- [ ] Maven installed → `mvn -version` works
- [ ] Node.js installed → `node -v` shows `v20.x.x`
- [ ] npm installed → `npm -v` works
- [ ] Angular CLI installed → `ng version` works
- [ ] Nginx installed and running → `systemctl status nginx` shows `active`
- [ ] Jenkins installed and running → `systemctl status jenkins` shows `active`
- [ ] Lab directory created → `/opt/microservices-lab/` exists with 4 subfolders
- [ ] Firewall ports opened: 22, 80, 8080

---

## 📌 What's Coming Next

| Phase | Topic |
|-------|-------|
| **Phase 2** | Create Spring Boot User & Product Microservices |
| **Phase 3** | Create Angular Frontend + connect to APIs |
| **Phase 4** | Configure Nginx as Reverse Proxy |
| **Phase 5** | Set up systemd services for auto-restart |
| **Phase 6** | Install & configure Jenkins, connect GitHub |
| **Phase 7** | Write Declarative Jenkins Pipeline |
| **Phase 8** | Auto-deploy on Git Push + Logs & Troubleshooting |

---

> ✅ **Confirm "Phase 1 done" when your checklist is complete and I'll send Phase 2!**
