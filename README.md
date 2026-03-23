# 🚀 Microservices Deployment Lab
### No Docker · No Kubernetes · Real DevOps Practices

**Tech Stack:** Java Spring Boot · Angular · Jenkins · Nginx · Ubuntu Linux

---

## 📁 Project Structure

```
microservices-deployment-lab/
│
├── phase1-setup/                  ← Phase 1: Tool installation & base config
│   ├── 01_install_tools.sh        ← Installs all tools (Java, Node, Nginx, Jenkins…)
│   ├── 02_verify_tools.sh         ← Verifies every tool is correctly installed
│   ├── 03_configure_nginx_base.sh ← Nginx reverse proxy base config
│   └── 04_setup_log_dirs.sh       ← Log directories + logrotate setup
│
├── phase2-microservices/          ← Phase 2: Spring Boot microservices (coming soon)
├── phase3-frontend/               ← Phase 3: Angular frontend (coming soon)
├── phase4-nginx/                  ← Phase 4: Full Nginx config (coming soon)
├── phase5-systemd/                ← Phase 5: systemd services (coming soon)
├── phase6-jenkins-setup/          ← Phase 6: Jenkins + GitHub config (coming soon)
├── phase7-pipeline/               ← Phase 7: Declarative Jenkins pipeline (coming soon)
└── phase8-monitoring/             ← Phase 8: Logs + troubleshooting (coming soon)
```

---

## 🏃 How to Run Phase 1 (on Linux Ubuntu)

```bash
# 1. Clone this repo on your Linux machine
git clone https://github.com/<your-username>/-Microservices-Deployment-Lab.git
cd -Microservices-Deployment-Lab/phase1-setup

# 2. Make scripts executable
chmod +x *.sh

# 3. Run installation
bash 01_install_tools.sh

# 4. Verify everything works
bash 02_verify_tools.sh

# 5. Configure Nginx base
bash 03_configure_nginx_base.sh

# 6. Setup log directories
bash 04_setup_log_dirs.sh
```

---

## 🌐 Architecture

```
Browser → Nginx (Port 80) ──→ Angular Frontend
                          ──→ User Service    (Spring Boot :8081)
                          ──→ Product Service (Spring Boot :8082)
Jenkins (Port 8080) — CI/CD automation
```

---

## 📌 Phases

| Phase | Status | Description |
|-------|--------|-------------|
| Phase 1 | ✅ Ready | Tool installation + base config |
| Phase 2 | 🔜 Pending | Spring Boot microservices |
| Phase 3 | 🔜 Pending | Angular frontend |
| Phase 4 | 🔜 Pending | Nginx full reverse proxy |
| Phase 5 | 🔜 Pending | systemd service setup |
| Phase 6 | 🔜 Pending | Jenkins + GitHub |
| Phase 7 | 🔜 Pending | Jenkins declarative pipeline |
| Phase 8 | 🔜 Pending | Logs & troubleshooting |
