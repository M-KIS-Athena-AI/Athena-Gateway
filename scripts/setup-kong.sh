#!/bin/bash

# Script de configuration initiale de Kong
# Ce script initialise Kong et charge les configurations déclaratives

set -e

# Vérifier si Kong est accessible
echo "Vérification de l'accès à Kong..."
curl -s -I http://localhost:8001 > /dev/null || { echo "Kong n'est pas accessible à http://localhost:8001. Veuillez démarrer Kong."; exit 1; }

# Vérifier si le mode déclaratif est activé
echo "Vérification de la configuration déclarative..."
DECLARATIVE_CONFIG=$(curl -s http://localhost:8001 | grep -c "declarative_config" || true)
if [ "$DECLARATIVE_CONFIG" -eq "0" ]; then
  echo "Kong n'est pas configuré en mode déclaratif. Veuillez vérifier votre configuration."
  exit 1
fi

# Charger la configuration
echo "Chargement de la configuration principale..."
curl -i -X POST http://localhost:8001/config \
  -F config=@../config/kong.yml

echo "Configuration chargée avec succès!"

# Vérifier les routes configurées
echo "Routes configurées:"
curl -s http://localhost:8001/routes | jq '.data[].name'

# Vérifier les plugins configurés
echo "Plugins configurés:"
curl -s http://localhost:8001/plugins | jq '.data[].name'

echo "Configuration terminée!" 