#!/bin/bash
# =============================================================
# Phase 2 — Start Both Microservices (Background processes)
# Run: bash 02_start_services.sh
#
# NOTE: In Phase 5 we will convert these to proper systemd services
#       that auto-start on reboot. For now we run them manually.
# =============================================================

set -e

GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

log()    { echo -e "${CYAN}[INFO]${NC}  $1"; }
success(){ echo -e "${GREEN}[OK]${NC}    $1"; }
warn()   { echo -e "${YELLOW}[WARN]${NC}  $1"; }
error()  { echo -e "${RED}[ERROR]${NC} $1"; exit 1; }

DEPLOY_DIR="/opt/microservices-lab"
LOG_DIR="$DEPLOY_DIR/logs"

echo ""
echo "============================================================"
echo "  Phase 2 — Starting Microservices"
echo "============================================================"
echo ""

# ── Helper: start a service in background ─────────────────────
start_service() {
  local name="$1"       # e.g. "user-service"
  local jar="$2"        # e.g. "/opt/.../user-service.jar"
  local port="$3"       # e.g. 8081
  local logfile="$4"    # e.g. "/opt/.../logs/user-service.log"
  local pidfile="$DEPLOY_DIR/$name/$name.pid"

  # Kill old instance if already running
  if [ -f "$pidfile" ]; then
    OLD_PID=$(cat "$pidfile")
    if kill -0 "$OLD_PID" 2>/dev/null; then
      warn "$name already running (PID $OLD_PID). Stopping it first..."
      kill "$OLD_PID"
      sleep 2
    fi
    rm -f "$pidfile"
  fi

  # Check JAR exists
  [ -f "$jar" ] || error "$jar not found. Run 01_build_and_deploy.sh first."

  log "Starting $name on port $port..."

  # nohup: keeps the process running even if the terminal closes
  # & :    run in background
  # > logfile 2>&1: redirect stdout AND stderr to log file
  nohup java -jar "$jar" \
    --server.port="$port" \
    >> "$logfile" 2>&1 &

  # $! = PID of the last background process
  echo $! > "$pidfile"
  log "$name started with PID $(cat $pidfile)"
}

# ── Start services ─────────────────────────────────────────────
start_service "user-service" \
  "$DEPLOY_DIR/user-service/user-service.jar" \
  "8081" \
  "$LOG_DIR/user-service.log"

start_service "product-service" \
  "$DEPLOY_DIR/product-service/product-service.jar" \
  "8082" \
  "$LOG_DIR/product-service.log"

# ── Wait for services to start (Spring Boot needs ~10-15 seconds) ─
log "Waiting 20 seconds for services to start..."
sleep 20

# ── Health checks ──────────────────────────────────────────────
echo ""
echo "── Health Checks ────────────────────────────────────────────"

check_health() {
  local name="$1"
  local url="$2"
  local response
  response=$(curl -s -o /dev/null -w "%{http_code}" "$url" 2>/dev/null)
  if [ "$response" = "200" ]; then
    echo -e "  ${GREEN}✔${NC}  $name → HTTP $response (UP)"
  else
    echo -e "  ${RED}✘${NC}  $name → HTTP $response (check logs!)"
    echo "     Logs: tail -50 $LOG_DIR/$name.log"
  fi
}

check_health "user-service"    "http://localhost:8081/api/users/health"
check_health "product-service" "http://localhost:8082/api/products/health"

echo ""
echo "── API Endpoints Ready ───────────────────────────────────────"
echo "  Users:"
echo "    GET  http://localhost:8081/api/users"
echo "    GET  http://localhost:8081/api/users/1"
echo "    GET  http://localhost:8081/api/users/health"
echo "    GET  http://localhost:8081/actuator/health"
echo ""
echo "  Products:"
echo "    GET  http://localhost:8082/api/products"
echo "    GET  http://localhost:8082/api/products?category=Electronics"
echo "    GET  http://localhost:8082/api/products/health"
echo "    GET  http://localhost:8082/actuator/health"
echo ""
echo "  Test with curl:"
echo "    curl http://localhost:8081/api/users"
echo "    curl http://localhost:8082/api/products"
echo ""
