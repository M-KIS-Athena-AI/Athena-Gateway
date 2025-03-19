# Athena Gateway

## Vue d'ensemble

Athena Gateway est le point d'entrée unique pour toutes les requêtes vers la plateforme Athena. Basé sur Kong API Gateway, il gère le routage, l'authentification, la sécurité et le monitoring des API de tous les microservices.

Ce repository contient les configurations déclaratives de Kong, les plugins nécessaires et les scripts de déploiement.

## Fonctionnalités

- **Routage intelligent** vers les microservices appropriés
- **Authentification centralisée** via Auth0 (GitHub/Google OAuth)
- **Rate limiting** pour prévenir les abus
- **Logging** des requêtes pour audit et debug
- **Monitoring** des performances et disponibilité
- **CORS** configuré pour l'interface frontend
- **Cache** pour améliorer les performances
- **Circuit breaker** pour la résilience

## Structure du repository

```
/
├── config/                   # Configurations Kong
│   ├── kong.yml              # Configuration déclarative principale
│   ├── routes/               # Définitions des routes par service
│   └── plugins/              # Configuration des plugins
├── scripts/                  # Scripts utilitaires
│   ├── setup-kong.sh         # Configuration initiale
│   └── test-routes.sh        # Tests des routes
├── docker/                   # Configuration Docker
│   └── docker-compose.yml    # Pour développement local
└── kubernetes/               # Manifestes Kubernetes
    ├── deployment.yaml       # Déploiement Kong
    ├── service.yaml          # Service Kong
    └── ingress.yaml          # Ingress Kong (si nécessaire)
```

## Routes configurées

- `/api/auth/*` → Service d'authentification (Auth0)
- `/api/chat/*` → AI Service
- `/api/integrations/aws/*` → AWS Integration Service
- `/api/integrations/datadog/*` → Datadog Integration Service
- `/api/integrations/ovh/*` → OVH Integration Service
- `/api/data/*` → Storage Service
- `/api/health` → Vérification de santé du système
- `/api/docs` → Documentation des API (Swagger/OpenAPI)

## Prérequis

- Docker & Docker Compose (développement local)
- kubectl (déploiement Kubernetes)
- Compte Auth0 configuré

## Démarrage rapide

### Développement local

1. Cloner ce repository:

```bash
git clone https://github.com/athena-ai/athena-gateway.git
cd athena-gateway
```

2. Configurer les variables d'environnement:

```bash
cp .env.example .env
# Éditer .env avec vos configurations
```

3. Lancer Kong avec Docker Compose:

```bash
cd docker
docker-compose up -d
```

4. Vérifier l'installation:

```bash
curl http://localhost:8001/status  # Admin API
curl http://localhost:8000/api/health  # Gateway API
```

### Déploiement sur Kubernetes

Le déploiement sur Kubernetes est géré par le repository `athena-infra`. Consultez sa documentation pour les instructions détaillées.

## Configuration de l'authentification

### Intégration avec Auth0

1. Créer un compte Auth0 et configurer une API
2. Configurer les connexions OAuth (GitHub, Google)
3. Obtenir le Domain et Audience
4. Mettre à jour la configuration Kong:

```yaml
# Dans config/plugins/auth.yml
plugins:
  - name: jwt
    config:
      secret_is_base64: false
      claims_to_verify:
        - exp
      key_claim_name: kid
      uri_param_names:
        - jwt
      cookie_names: []
      header_names:
        - Authorization
      jwks_uri: https://YOUR_AUTH0_DOMAIN/.well-known/jwks.json
```

## Plugins activés

- **jwt**: Authentification via JWT (Auth0)
- **rate-limiting**: Limitation des requêtes par IP/utilisateur
- **cors**: Support Cross-Origin Resource Sharing
- **prometheus**: Exposition des métriques
- **request-termination**: Gestion des routes non implémentées
- **http-log**: Logging des requêtes
- **ip-restriction**: Restriction par IP (optionnel)
- **acl**: Contrôle d'accès basé sur les rôles

## Monitoring et logs

Kong expose des métriques Prometheus sur l'endpoint `/metrics`. Ces métriques peuvent être collectées par Prometheus et visualisées dans Grafana.

Les logs sont également disponibles dans les logs Docker/Kubernetes ou via le plugin `http-log` qui peut les envoyer à un service de logging externe.

## Contribution

1. Créer une branche à partir de `develop`
2. Effectuer les modifications
3. Tester localement avec Docker Compose
4. Soumettre une Pull Request vers `develop`
5. Une fois approuvée, elle sera fusionnée puis déployée

## Sécurité

- Les clés et tokens d'API ne doivent jamais être inclus directement dans les configurations
- Utiliser des variables d'environnement et des secrets Kubernetes
- Maintenir Kong à jour avec les dernières versions de sécurité

## Dépannage

### Problèmes courants

**Q: Les routes ne fonctionnent pas correctement**  
**R:** Vérifier la configuration avec `curl -i http://localhost:8001/routes`

**Q: Erreurs d'authentification**  
**R:** Vérifier que les JWKS sont correctement configurés et que le token est valide

**Q: Kong ne démarre pas**  
**R:** Vérifier les logs avec `docker-compose logs kong` ou `kubectl logs -n athena-system deployment/kong`
