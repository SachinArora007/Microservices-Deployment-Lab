#!/bin/bash
# =============================================================
# Phase 2 — Build & Deploy Both Microservices to Linux Server
# Run: bash 01_build_and_deploy.sh
# =============================================================

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()    { echo -e "${CYAN}[INFO]${NC}  $1"; }
success(){ echo -e "${GREEN}[OK]${NC}    $1"; }
warn()   { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error()  { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

# Root vs non-root (AWS EC2 runs as root)
[ "$EUID" -eq 0 ] && SUDO="" || SUDO="sudo"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEPLOY_DIR="/opt/microservices-lab"

echo ""
echo "============================================================"
echo "  Phase 2 — Build & Deploy Microservices"
echo "============================================================"
echo ""

# ── PRE-CHECKS ────────────────────────────────────────────────
log "Checking prerequisites..."
command -v java  &>/dev/null || error "Java not found. Run Phase 1 first."
command -v mvn   &>/dev/null || error "Maven not found. Run Phase 1 first."
[ -d "$DEPLOY_DIR" ]         || error "$DEPLOY_DIR not found. Run Phase 1 first."
success "Prerequisites OK"

# ============================================================
# BUILD: User Service
# ============================================================
log "Building User Service..."
cd "$SCRIPT_DIR/user-service"

# mvn clean: deletes the 'target/' folder (removes old build artifacts)
# mvn package: compiles code → runs tests → packages into .jar
# -DskipTests: skip tests here (they run in Jenkins pipeline)
mvn clean package -DskipTests

success "User Service JAR built: $(ls -lh target/user-service.jar | awk '{print $5}')"

# ============================================================
# DEPLOY: User Service
# ============================================================
log "Deploying User Service to $DEPLOY_DIR/user-service/..."
cp target/user-service.jar "$DEPLOY_DIR/user-service/user-service.jar"
success "user-service.jar copied to $DEPLOY_DIR/user-service/"

# ============================================================
# BUILD: Product Service
# ============================================================
log "Building Product Service..."
cd "$SCRIPT_DIR/product-service"
mvn clean package -DskipTests
success "Product Service JAR built: $(ls -lh target/product-service.jar | awk '{print $5}')"

# ============================================================
# DEPLOY: Product Service
# ============================================================
log "Deploying Product Service to $DEPLOY_DIR/product-service/..."
cp target/product-service.jar "$DEPLOY_DIR/product-service/product-service.jar"
success "product-service.jar copied to $DEPLOY_DIR/product-service/"

# ============================================================
# VERIFY deployed JARs
# ============================================================
echo ""
echo "── Deployed JARs ────────────────────────────────────────────"
ls -lh "$DEPLOY_DIR/user-service/user-service.jar"    2>/dev/null || error "user-service.jar missing!"
ls -lh "$DEPLOY_DIR/product-service/product-service.jar" 2>/dev/null || error "product-service.jar missing!"
echo ""

success "Build & Deploy complete!"
echo ""
echo "  Next: bash 02_start_services.sh"
echo ""
