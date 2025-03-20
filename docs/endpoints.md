# Documentation des Endpoints Athena Gateway

Cette documentation détaille les endpoints disponibles via Athena Gateway, le point d'entrée unique pour toutes les API Athena.

## Base URL

- **Développement**: `http://localhost:8000`
- **Production**: `https://api.athena.example.com`

## Authentification

Toutes les requêtes aux API (à l'exception de `/api/health` et `/api/docs`) nécessitent une authentification via JWT.

**En-tête d'authentification**:
```
Authorization: Bearer <token>
```

Le token JWT doit être obtenu via le service d'authentification.

## Endpoints

### Service d'Authentification

| Endpoint | Méthode | Description | Authentification |
|----------|---------|-------------|-----------------|
| `/api/auth/login` | POST | Obtenir un token JWT | Non |
| `/api/auth/logout` | POST | Révoquer un token | Oui |
| `/api/auth/me` | GET | Informations sur l'utilisateur courant | Oui |
| `/api/auth/refresh` | POST | Rafraîchir un token | Oui |

### Service IA/Chat

| Endpoint | Méthode | Description | Authentification |
|----------|---------|-------------|-----------------|
| `/api/chat/completions` | POST | Obtenir une complétion de texte | Oui |
| `/api/chat/conversations` | GET | Lister les conversations | Oui |
| `/api/chat/conversations/:id` | GET | Détails d'une conversation | Oui |

### Service d'Intégration AWS

| Endpoint | Méthode | Description | Authentification |
|----------|---------|-------------|-----------------|
| `/api/integrations/aws/resources` | GET | Lister les ressources AWS | Oui |
| `/api/integrations/aws/ec2` | GET | Lister les instances EC2 | Oui |
| `/api/integrations/aws/s3` | GET | Lister les buckets S3 | Oui |

### Service d'Intégration Datadog

| Endpoint | Méthode | Description | Authentification |
|----------|---------|-------------|-----------------|
| `/api/integrations/datadog/metrics` | GET | Récupérer des métriques | Oui |
| `/api/integrations/datadog/events` | GET | Récupérer des événements | Oui |
| `/api/integrations/datadog/monitors` | GET | Récupérer l'état des moniteurs | Oui |

### Service d'Intégration OVH

| Endpoint | Méthode | Description | Authentification |
|----------|---------|-------------|-----------------|
| `/api/integrations/ovh/instances` | GET | Lister les instances | Oui |
| `/api/integrations/ovh/storage` | GET | Lister les espaces de stockage | Oui |
| `/api/integrations/ovh/ip` | GET | Lister les adresses IP | Oui |

### Service de Stockage

| Endpoint | Méthode | Description | Authentification |
|----------|---------|-------------|-----------------|
| `/api/data/files` | GET | Lister les fichiers | Oui |
| `/api/data/files/:id` | GET | Récupérer un fichier | Oui |
| `/api/data/files` | POST | Téléverser un fichier | Oui |
| `/api/data/files/:id` | DELETE | Supprimer un fichier | Oui |

### Utilitaires

| Endpoint | Méthode | Description | Authentification |
|----------|---------|-------------|-----------------|
| `/api/health` | GET | Vérifier l'état du système | Non |
| `/api/docs` | GET | Documentation Swagger/OpenAPI | Non |

## Limites de Taux (Rate Limiting)

Les limites suivantes sont appliquées par défaut:

- 60 requêtes par minute par IP
- 1000 requêtes par heure par IP

Des limites spécifiques par service:

- Service IA/Chat: 10 requêtes par minute, 100 par heure
- Service d'authentification: 20 requêtes par minute, 200 par heure
- Autres services: 30 requêtes par minute, 300 par heure

## Codes d'Erreur

| Code | Description |
|------|-------------|
| 200 | Succès |
| 400 | Requête incorrecte |
| 401 | Non authentifié |
| 403 | Non autorisé |
| 404 | Ressource non trouvée |
| 429 | Trop de requêtes (rate limit) |
| 500 | Erreur serveur |

## CORS

CORS est activé pour l'origine `https://app.athena.example.com`. 