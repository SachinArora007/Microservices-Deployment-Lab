#!/bin/bash
# =============================================================
# Phase 2 — Test APIs with curl (quick validation)
# Run: bash 04_test_apis.sh
# =============================================================

GREEN='\033[0;32m'
RED='\033[0;31m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'
BOLD='\033[1m'

pass=0; fail=0

test_api() {
  local label="$1"
  local url="$2"
  local expected_code="${3:-200}"

  local http_code response_body
  response_body=$(curl -s -w "\n%{http_code}" "$url" 2>/dev/null)
  http_code=$(echo "$response_body" | tail -1)
  body=$(echo "$response_body" | head -n -1)

  if [ "$http_code" = "$expected_code" ]; then
    echo -e "  ${GREEN}✔${NC} $label"
    echo -e "    ${CYAN}URL:${NC}  $url"
    echo -e "    ${CYAN}Code:${NC} $http_code"
    # Print a short preview of the response (first 120 chars)
    echo -e "    ${CYAN}Body:${NC} ${body:0:120}..."
    ((pass++))
  else
    echo -e "  ${RED}✘${NC} $label"
    echo -e "    ${CYAN}URL:${NC}  $url"
    echo -e "    ${RED}Expected:${NC} $expected_code | ${RED}Got:${NC} $http_code"
    ((fail++))
  fi
  echo ""
}

echo ""
echo "============================================================"
echo -e "${BOLD}  Phase 2 — API Test Suite${NC}"
echo "============================================================"
echo ""

echo "── User Service (port 8081) ─────────────────────────────────"
test_api "GET All Users"         "http://localhost:8081/api/users"
test_api "GET User by ID (1)"    "http://localhost:8081/api/users/1"
test_api "GET User Not Found"    "http://localhost:8081/api/users/999"    "404"
test_api "GET Users Health"      "http://localhost:8081/api/users/health"
test_api "GET Actuator Health"   "http://localhost:8081/actuator/health"

echo "── Product Service (port 8082) ──────────────────────────────"
test_api "GET All Products"              "http://localhost:8082/api/products"
test_api "GET Product by ID (1)"         "http://localhost:8082/api/products/1"
test_api "GET Products by Category"      "http://localhost:8082/api/products?category=Electronics"
test_api "GET Product Not Found"         "http://localhost:8082/api/products/999"  "404"
test_api "GET Products Health"           "http://localhost:8082/api/products/health"
test_api "GET Actuator Health"           "http://localhost:8082/actuator/health"

echo "── Results ──────────────────────────────────────────────────"
echo -e "  ${GREEN}Passed: $pass${NC}  |  ${RED}Failed: $fail${NC}"
echo ""

if [ "$fail" -gt 0 ]; then
  echo -e "  ${RED}Some tests failed. Check logs:${NC}"
  echo "    tail -50 /opt/microservices-lab/logs/user-service.log"
  echo "    tail -50 /opt/microservices-lab/logs/product-service.log"
  exit 1
else
  echo -e "  ${GREEN}✅ All API tests passed! Services are working correctly.${NC}"
  echo ""
  echo "  Confirm 'Phase 2 done' to proceed to Phase 3 (Angular Frontend)"
fi
echo ""
