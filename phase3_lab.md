# 🚀 Microservices Deployment Lab — Phase 3
## Angular Frontend (Premium Dashboard)

---

## 🎨 Design Showcase

Your frontend is built with **modern glassmorphism**:
- **Dark Mode** backend with subtle gradients.
- **Glass Cards** with backdrop blur and soft borders.
- **Micro-animations** on hover.
- **Real-time Status** dots (Online/Offline) for your microservices.

---

## 📁 What Was Created

```
phase3-frontend/
│
├── src/
│   ├── app/
│   │   ├── models/           ← User & Product interfaces
│   │   ├── services/         ← ApiService (connects to 8081/8082)
│   │   └── app.component.ts  ← Main Dashboard (Standalone)
│   ├── styles.css            ← Premium Glassmorphism CSS
│   └── main.ts               ← Application Bootstrap
│
├── angular.json              ← Build configuration
├── package.json              ← Dependencies
├── tsconfig.json             ← TypeScript config
└── 01_build_frontend.sh      ← ONE-CLICK Build & Deploy script
```

---

## 🏃 How to Run on Your Linux Server

Since you are running on a remote Linux server (EC2), follow these steps:

### Option A: Development Mode (Quick View)
Use this to see the UI immediately on your browser.

```bash
cd phase3-frontend
npm install --legacy-peer-deps
# Start dev server accessible from outside
# ⚠️ Make sure Port 4200 is open in your Security Group!
npm start -- --host 0.0.0.0 --port 4200
```
Then visit: `http://<YOUR-EC2-IP>:4200`

### Option B: Production Build (Recommended)
This follows real DevOps practices by building static files.

```bash
cd phase3-frontend
chmod +x 01_build_frontend.sh
bash 01_build_frontend.sh
```

**What happens?**
1. It runs `npm install`.
2. It runs `ng build` for production.
3. It moves the output to `/opt/microservices-lab/frontend/`.

> [!NOTE]
> You won't see the app via Nginx yet! That happens in **Phase 4**. For now, use Option A to verify the UI.

---

## 🔌 API Connectivity Logic

The [ApiService](file:///D:/Devops/-Microservices-Deployment-Lab/phase3-frontend/src/app/services/api.service.ts#7-50) uses `HttpClient` to fetch data:
```typescript
// phase3-frontend/src/app/services/api.service.ts
private userApiUrl = 'http://localhost:8081/api/users';
private productApiUrl = 'http://localhost:8082/api/products';
```

**Why localhost?**
When the Angular code runs in your *browser*, `localhost` refers to *your computer*. However, since we'll eventually access this through Nginx, Phase 4 will update these URLs to use relative paths like `/api/users`, which Nginx will then proxy.

---

## ⚠️ Common Errors & Fixes — Phase 3

### ❌ `npm: command not found`
**Cause:** Node.js wasn't installed correctly in Phase 1.  
**Fix:** Run `bash ../phase1-setup/01_install_tools.sh` again.

### ❌ `Connection Refused` on Dashboard
**Cause:** Your Spring Boot microservices (Phase 2) are not running.  
**Fix:**
```bash
cd ../phase2-microservices
bash 02_start_services.sh
```

### ❌ `CORS Error` in Browser Console
**Cause:** The backend isn't allowing requests from Port 4200.  
**Fix:** Ensure your Spring Boot Controllers have `@CrossOrigin(origins = "*")`. (Already included in the code I gave you!)

---

## ✅ Phase 3 Checklist

- [ ] `npm start` works and shows the dashboard on port 4200. ✓
- [ ] User table loads data from `8081`. ✓
- [ ] Product cards load data from `8082`. ✓
- [ ] Status dots turn **Green** when services are running. ✓
- [ ] `bash 01_build_frontend.sh` finishes without errors. ✓

---

> ✅ **Confirm "Phase 3 done" to proceed to Phase 4 (Nginx Reverse Proxy & End-to-End setup)!**
