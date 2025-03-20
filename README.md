# Athena Gateway

Ce projet implémente une Gateway API basée sur Kong pour l'organisation M-KIS-Athena-AI.

## État Actuel du Projet

### ✅ Infrastructure de Base
- Kong Gateway opérationnel (version 3.5.0)
- PostgreSQL comme datastore
- Service de test configuré (httpbin.org)
- Route de test configurée (/test)

### ✅ Plugins Configurés
- Rate Limiting (5 requêtes par minute)
- Prometheus metrics (monitoring)
- CORS (en cours de configuration)

## Configuration Locale

### Prérequis
- Docker Desktop
- curl (pour les tests API)

### Installation

1. Cloner le repository :
```bash
git clone git@github.com:M-KIS-Athena-AI/Athena-Gateway.git
cd Athena-Gateway
```

2. Démarrer les services :
```bash
cd kong
docker compose up -d
```

3. Vérifier l'installation :
```bash
curl http://localhost:8001/status
```

### Ports Exposés
- 8000 : Kong Proxy (HTTP)
- 8443 : Kong Proxy (HTTPS)
- 8001 : Kong Admin API (localhost uniquement)
- 5432 : PostgreSQL (localhost uniquement)

### Configuration Actuelle

#### Services et Routes
```bash
# Test service (httpbin)
curl http://localhost:8000/test/get
```

#### Rate Limiting
- Limite : 5 requêtes par minute
- Headers : X-RateLimit-Remaining-Minute, X-RateLimit-Limit-Minute
- Politique : local

#### Prometheus Metrics
- Endpoint : http://localhost:8001/metrics
- Configuration : per_consumer=true

## Prochaines Étapes

### 🔄 En Cours
- Configuration CORS
- Documentation des endpoints

### 📅 À Venir
- Configuration SSL/TLS
- Mise en place de l'authentification
- Configuration déclarative (kong.yml)
- Dashboards de monitoring

## Structure du Projet
```
Athena-Gateway/
├── kong/
│   ├── docker-compose.yml
│   ├── .env
│   ├── config/           # Configuration Kong
│   └── data/            # Données persistantes
├── docs/                # Documentation
└── README.md
```

## Contribution
Instructions pour contribuer au projet à venir...

## Licence
À définir...
