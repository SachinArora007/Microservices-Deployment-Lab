#!/bin/bash
# =============================================================
# Phase 3 — Create and Build Angular App on Linux
# Run: bash 01_build_frontend.sh
# =============================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()    { echo -e "${CYAN}[INFO]${NC}  $1"; }
success(){ echo -e "${GREEN}[OK]${NC}    $1"; }

DEPLOY_DIR="/opt/microservices-lab/frontend"

echo ""
echo "============================================================"
echo "  Phase 3 — Building Angular Frontend"
echo "============================================================"
echo ""

# ── Clean up old build ────────────────────────────────────────
log "Cleaning up old build artifacts..."
rm -rf dist/ node_modules/

# ── Install Dependencies ──────────────────────────────────────
log "Installing npm dependencies (this may take a few minutes)..."
npm install --legacy-peer-deps

# ── Build for Production ──────────────────────────────────────
log "Building Angular app for Production..."
npm run build

# ── Deploy to /opt ───────────────────────────────────────────
log "Deploying built files to $DEPLOY_DIR..."

# In Angular 17, the output is in dist/frontend/browser
BUILD_FOLDER=$(find dist -type d -name "browser" | head -n 1)
[ -z "$BUILD_FOLDER" ] && BUILD_FOLDER="dist/frontend"

sudo rm -rf "$DEPLOY_DIR"/*
sudo cp -r "$BUILD_FOLDER"/* "$DEPLOY_DIR/"

success "Angular app built and deployed to $DEPLOY_DIR"
echo ""
echo "  Note: In Phase 3, you can view the app by running:"
echo "  npm start -- --host 0.0.0.0 --port 4200"
echo ""
echo "  In Phase 4, Nginx will serve these files on Port 80."
echo ""
