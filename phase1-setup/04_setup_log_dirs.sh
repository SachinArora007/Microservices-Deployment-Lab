#!/bin/bash
# =============================================================
# Phase 1 - Step 04: Setup Log Directories + Logrotate
# Run: bash 04_setup_log_dirs.sh
# =============================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

log()    { echo -e "${CYAN}[INFO]${NC}  $1"; }
success(){ echo -e "${GREEN}[OK]${NC}    $1"; }

LOG_DIR="/opt/microservices-lab/logs"

# ── Create log files (touch creates empty file if not exists) ──
log "Creating log files..."
touch "$LOG_DIR/user-service.log"
touch "$LOG_DIR/product-service.log"
touch "$LOG_DIR/nginx-access.log"
touch "$LOG_DIR/nginx-error.log"
chmod 664 "$LOG_DIR"/*.log
success "Log files created at $LOG_DIR"

# ── Setup logrotate so logs don't grow forever ─────────────────
log "Configuring logrotate for microservices logs..."

sudo tee /etc/logrotate.d/microservices-lab > /dev/null << EOF
$LOG_DIR/*.log {
    daily                    # Rotate daily
    missingok                # Don't error if log file is missing
    rotate 7                 # Keep last 7 days of logs
    compress                 # Compress old logs with gzip
    delaycompress            # Compress on next rotation, not immediately
    notifempty               # Don't rotate if log is empty
    copytruncate             # Copy then truncate (safe for running apps)
    su $USER $USER           # Run as current user
}
EOF

success "Logrotate configured: /etc/logrotate.d/microservices-lab"

# ── Print directory tree ───────────────────────────────────────
echo ""
echo "  Lab directory structure:"
find /opt/microservices-lab -maxdepth 2 | sed 's|/opt/microservices-lab||' \
  | sort | sed 's|^/||' | sed 's|/[^/]*$||' \
  | awk -F/ '{printf "%*s%s\n", 2*NF, "", $NF}' 2>/dev/null \
  || ls -R /opt/microservices-lab
echo ""
success "Phase 1 log setup complete!"
