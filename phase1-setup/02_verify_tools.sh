#!/bin/bash
# =============================================================
# Phase 1 - Step 02: Verify All Tool Installations
# Run: bash 02_verify_tools.sh
# =============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m'

PASS=0
FAIL=0

check() {
  local label="$1"
  local cmd="$2"
  local result
  result=$(eval "$cmd" 2>&1 | head -1)
  if [ $? -eq 0 ] && [ -n "$result" ]; then
    echo -e "  ${GREEN}✔${NC}  $label → $result"
    ((PASS++))
  else
    echo -e "  ${RED}✘${NC}  $label → NOT FOUND or ERROR"
    ((FAIL++))
  fi
}

service_check() {
  local name="$1"
  local status
  status=$(systemctl is-active "$name" 2>&1)
  if [ "$status" = "active" ]; then
    echo -e "  ${GREEN}✔${NC}  $name service → active (running)"
    ((PASS++))
  else
    echo -e "  ${RED}✘${NC}  $name service → $status"
    ((FAIL++))
  fi
}

dir_check() {
  local path="$1"
  if [ -d "$path" ]; then
    echo -e "  ${GREEN}✔${NC}  Directory exists → $path"
    ((PASS++))
  else
    echo -e "  ${RED}✘${NC}  Directory MISSING → $path"
    ((FAIL++))
  fi
}

echo ""
echo "============================================================"
echo "   Phase 1 — Tool Verification Report"
echo "============================================================"
echo ""

echo "── Installed Tools ─────────────────────────────────────────"
check "Git"         "git --version"
check "Java 17"     "java -version 2>&1 | head -1"
check "JAVA_HOME"   "echo \$JAVA_HOME"
check "Maven"       "mvn -version 2>&1 | head -1"
check "Node.js"     "node -v"
check "npm"         "npm -v"
check "Angular CLI" "ng version 2>&1 | grep 'Angular CLI'"
check "Nginx"       "nginx -v 2>&1"

echo ""
echo "── Running Services ─────────────────────────────────────────"
service_check "nginx"
service_check "jenkins"

echo ""
echo "── Directory Structure ──────────────────────────────────────"
dir_check "/opt/microservices-lab"
dir_check "/opt/microservices-lab/user-service"
dir_check "/opt/microservices-lab/product-service"
dir_check "/opt/microservices-lab/frontend"
dir_check "/opt/microservices-lab/logs"

echo ""
echo "── Firewall Ports ───────────────────────────────────────────"
for port in 22 80 8080 8081 8082; do
  if sudo ufw status | grep -q "$port"; then
    echo -e "  ${GREEN}✔${NC}  Port $port → OPEN"
    ((PASS++))
  else
    echo -e "  ${YELLOW}⚠${NC}  Port $port → not explicitly listed (may be OK if UFW is inactive)"
  fi
done

echo ""
echo "============================================================"
echo -e "  Results: ${GREEN}$PASS passed${NC}  |  ${RED}$FAIL failed${NC}"
echo "============================================================"
echo ""

if [ "$FAIL" -gt 0 ]; then
  echo -e "  ${RED}❌ Some checks failed. Review errors above and re-run 01_install_tools.sh${NC}"
  exit 1
else
  echo -e "  ${GREEN}✅ All checks passed! Phase 1 is complete.${NC}"
  echo "  → Next step: bash ../phase2-microservices/01_create_user_service.sh"
fi
echo ""
