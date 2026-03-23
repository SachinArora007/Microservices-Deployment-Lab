#!/bin/bash
# =============================================================
# Phase 1 - Step 03: Configure Nginx Base (Reverse Proxy Skeleton)
# Run: bash 03_configure_nginx_base.sh
# NOTE: Full Nginx config is done in Phase 4.
#       This creates a working placeholder so Nginx doesn't fail.
# =============================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

log()    { echo -e "${CYAN}[INFO]${NC}  $1"; }
success(){ echo -e "${GREEN}[OK]${NC}    $1"; }

NGINX_CONF="/etc/nginx/sites-available/microservices-lab"
NGINX_ENABLED="/etc/nginx/sites-enabled/microservices-lab"

log "Writing base Nginx configuration..."

sudo tee "$NGINX_CONF" > /dev/null << 'EOF'
# ============================================================
# Microservices Lab — Nginx Reverse Proxy Configuration
# Phase 1: Base placeholder (updated fully in Phase 4)
# ============================================================

server {
    listen 80;
    server_name _;

    # ── Serve Angular frontend (built files) ──────────────────
    # Uncomment in Phase 4 after Angular build:
    # root /opt/microservices-lab/frontend/dist/frontend;
    # index index.html;

    # ── Default root response (Phase 1 placeholder) ──────────
    location / {
        return 200 'Microservices Lab - Nginx is running!\n';
        add_header Content-Type text/plain;
    }

    # ── User Service Proxy ────────────────────────────────────
    location /api/users {
        proxy_pass         http://localhost:8081;
        proxy_http_version 1.1;
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_connect_timeout 30s;
        proxy_read_timeout    30s;
    }

    # ── Product Service Proxy ─────────────────────────────────
    location /api/products {
        proxy_pass         http://localhost:8082;
        proxy_http_version 1.1;
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_connect_timeout 30s;
        proxy_read_timeout    30s;
    }

    # ── Nginx access and error logs ───────────────────────────
    access_log /opt/microservices-lab/logs/nginx-access.log;
    error_log  /opt/microservices-lab/logs/nginx-error.log;
}
EOF

# Enable the site (symlink into sites-enabled)
sudo ln -sf "$NGINX_CONF" "$NGINX_ENABLED"

# Disable the default Nginx site to avoid conflicts
sudo rm -f /etc/nginx/sites-enabled/default

# Test Nginx config for syntax errors
log "Testing Nginx configuration..."
sudo nginx -t

# Reload Nginx
log "Reloading Nginx..."
sudo systemctl reload nginx

success "Nginx base configuration applied!"
echo ""
echo "  Config file: $NGINX_CONF"
echo "  Logs dir:    /opt/microservices-lab/logs/"
echo ""
echo "  Test it: curl http://localhost"
echo "  Expected: 'Microservices Lab - Nginx is running!'"
echo ""

curl -s http://localhost || true
