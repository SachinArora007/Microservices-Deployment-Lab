# 🚀 Microservices Deployment Lab — Phase 2
## Spring Boot Microservices (User Service + Product Service)

---

## 📁 What Was Created

```
phase2-microservices/
│
├── user-service/                          ← Spring Boot App (Port 8081)
│   ├── pom.xml                            ← Maven build file
│   └── src/
│       ├── main/
│       │   ├── java/com/microlab/userservice/
│       │   │   ├── UserServiceApplication.java   ← main() entry point
│       │   │   ├── model/User.java               ← data model (POJO)
│       │   │   └── controller/UserController.java ← REST API endpoints
│       │   └── resources/
│       │       └── application.properties         ← port, logging, actuator
│       └── test/.../UserServiceApplicationTests.java
│
├── product-service/                       ← Spring Boot App (Port 8082)
│   ├── pom.xml
│   └── src/
│       ├── main/
│       │   ├── java/com/microlab/productservice/
│       │   │   ├── ProductServiceApplication.java
│       │   │   ├── model/Product.java
│       │   │   └── controller/ProductController.java
│       │   └── resources/
│       │       └── application.properties
│       └── test/.../ProductServiceApplicationTests.java
│
├── 01_build_and_deploy.sh   ← Builds JARs and copies to /opt
├── 02_start_services.sh     ← Starts both services in background
├── 03_stop_services.sh      ← Stops both services cleanly
└── 04_test_apis.sh          ← Tests all API endpoints with curl
```

---

## 🔌 API Endpoints Reference

### User Service — `http://localhost:8081`

| Method | URL | Description |
|--------|-----|-------------|
| GET | `/api/users` | Get all users |
| GET | `/api/users/{id}` | Get user by ID |
| POST | `/api/users` | Create new user |
| DELETE | `/api/users/{id}` | Delete user |
| GET | `/api/users/health` | Custom health check |
| GET | `/actuator/health` | Spring Actuator health |

### Product Service — `http://localhost:8082`

| Method | URL | Description |
|--------|-----|-------------|
| GET | `/api/products` | Get all products |
| GET | `/api/products?category=Electronics` | Filter by category |
| GET | `/api/products/{id}` | Get product by ID |
| POST | `/api/products` | Create new product |
| DELETE | `/api/products/{id}` | Delete product |
| GET | `/api/products/health` | Custom health check |
| GET | `/actuator/health` | Spring Actuator health |

---

## 🏃 How to Run on Your Linux Server

```bash
# 1. Pull latest code on your EC2
cd /path/to/repo
git pull origin main

# 2. Go to phase2 scripts
cd phase2-microservices
chmod +x *.sh

# 3. Build and deploy JARs
bash 01_build_and_deploy.sh

# 4. Start services
bash 02_start_services.sh

# 5. Test all APIs
bash 04_test_apis.sh

# 6. To stop services
bash 03_stop_services.sh
```

---

## 🧱 How Spring Boot Works (Concept Summary)

```
HTTP Request → Spring DispatcherServlet
                     ↓
              @RestController (UserController)
                     ↓
              @GetMapping / @PostMapping
                     ↓
              Business Logic (in-memory List)
                     ↓
              Return Object → Jackson → JSON Response
```

**Key Annotations:**
| Annotation | What it does |
|---|---|
| `@SpringBootApplication` | Marks main class, auto-configures everything |
| `@RestController` | Marks class as REST API handler |
| `@RequestMapping("/api/users")` | Base URL prefix for all methods |
| `@GetMapping` | Handles HTTP GET requests |
| `@PostMapping` | Handles HTTP POST requests |
| `@PathVariable` | Extracts `{id}` from the URL |
| `@RequestBody` | Converts incoming JSON → Java object |
| `@CrossOrigin` | Allows Angular (different port) to call this API |

---

## ⚠️ Common Errors & Fixes — Phase 2

### ❌ `Port 8081 already in use`
```bash
# Find what's using the port
lsof -i :8081
# Kill it
kill -9 <PID>
# Or use the stop script
bash 03_stop_services.sh
```

### ❌ `BUILD FAILURE` during `mvn package`
```bash
# See detailed error
mvn clean package -DskipTests 2>&1 | tail -30
# Most common cause: Java not found
java -version          # must show 17
echo $JAVA_HOME        # must not be empty
source ~/.bashrc       # reload env vars
```

### ❌ `Connection refused` on health check
```bash
# Service didn't start yet — wait more
sleep 30
curl http://localhost:8081/api/users/health

# Or check logs for startup errors
tail -50 /opt/microservices-lab/logs/user-service.log
```

### ❌ `Error: JAVA_HOME not set`
```bash
export JAVA_HOME=/usr/lib/jvm/java-17-openjdk-amd64
export PATH=$JAVA_HOME/bin:$PATH
source ~/.bashrc
```

### ❌ Log file permission denied
```bash
sudo chown -R $USER:$USER /opt/microservices-lab/logs/
chmod 755 /opt/microservices-lab/logs/
```

---

## ✅ Phase 2 Checklist

- [ ] `bash 01_build_and_deploy.sh` — both JARs built successfully
- [ ] `bash 02_start_services.sh` — both services started
- [ ] `curl http://localhost:8081/api/users` → returns JSON array of users
- [ ] `curl http://localhost:8082/api/products` → returns JSON array of products
- [ ] `bash 04_test_apis.sh` → all tests passed (green ✔)
- [ ] Logs exist at `/opt/microservices-lab/logs/`

---

> ✅ **Confirm "Phase 2 done" when all tests pass → I'll build Phase 3 (Angular Frontend)**
