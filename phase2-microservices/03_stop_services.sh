#!/bin/bash
# =============================================================
# Phase 2 — Stop Both Microservices
# Run: bash 03_stop_services.sh
# =============================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

log()    { echo -e "${CYAN}[INFO]${NC}  $1"; }
success(){ echo -e "${GREEN}[OK]${NC}    $1"; }
warn()   { echo -e "${YELLOW}[WARN]${NC}  $1"; }

DEPLOY_DIR="/opt/microservices-lab"

stop_service() {
  local name="$1"
  local pidfile="$DEPLOY_DIR/$name/$name.pid"

  if [ -f "$pidfile" ]; then
    PID=$(cat "$pidfile")
    if kill -0 "$PID" 2>/dev/null; then
      log "Stopping $name (PID $PID)..."
      kill "$PID"
      sleep 2
      # Force kill if still running
      kill -0 "$PID" 2>/dev/null && kill -9 "$PID"
      success "$name stopped."
    else
      warn "$name was not running (stale PID file)."
    fi
    rm -f "$pidfile"
  else
    warn "No PID file found for $name — may not be running."
    # Try to find and kill by port as fallback
    local port="$2"
    local pid_by_port
    pid_by_port=$(lsof -ti tcp:"$port" 2>/dev/null || true)
    if [ -n "$pid_by_port" ]; then
      log "Found process on port $port (PID $pid_by_port). Killing..."
      kill "$pid_by_port" 2>/dev/null && success "$name stopped via port lookup."
    fi
  fi
}

echo ""
echo "============================================================"
echo "  Stopping Microservices"
echo "============================================================"
echo ""
stop_service "user-service"    8081
stop_service "product-service" 8082
echo ""
success "All services stopped."
echo ""
