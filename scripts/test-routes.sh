#!/bin/bash

# Script de test des routes Kong
# Ce script vérifie que toutes les routes sont correctement configurées

set -e

# Définir l'URL de base
KONG_PROXY_URL=${KONG_PROXY_URL:-"http://localhost:8000"}

# Couleurs pour les outputs
GREEN='\033[0;32m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Fonction pour tester un endpoint
test_endpoint() {
  local path=$1
  local expected_status=$2
  local method=${3:-GET}
  
  echo -n "Testing $method $path (expected: $expected_status): "
  
  status=$(curl -s -o /dev/null -w "%{http_code}" -X "$method" "$KONG_PROXY_URL$path")
  
  if [ "$status" -eq "$expected_status" ]; then
    echo -e "${GREEN}OK${NC} ($status)"
    return 0
  else
    echo -e "${RED}FAILED${NC} (got: $status, expected: $expected_status)"
    return 1
  fi
}

# Tester la route de santé
test_endpoint "/api/health" 200

# Tester les routes d'API
echo -e "\n=== Testing API Routes ==="
test_endpoint "/api/auth" 401  # Devrait demander une authentification
test_endpoint "/api/chat" 401  # Devrait demander une authentification
test_endpoint "/api/data" 401  # Devrait demander une authentification
test_endpoint "/api/integrations/aws" 401  # Devrait demander une authentification
test_endpoint "/api/integrations/datadog" 401  # Devrait demander une authentification
test_endpoint "/api/integrations/ovh" 401  # Devrait demander une authentification

# Tester la documentation
echo -e "\n=== Testing Documentation ==="
test_endpoint "/api/docs" 200  # Documentation devrait être accessible sans authentification

# Tester une route inexistante
echo -e "\n=== Testing Non-existent Route ==="
test_endpoint "/api/non-existent" 404  # Route inexistante

echo -e "\nTests terminés!" 