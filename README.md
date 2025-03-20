# Athena Gateway

API Gateway implementation based on Kong for the M-KIS-Athena-AI organization.

## Current Status

The gateway is operational with the following features:

- Basic infrastructure with Kong and PostgreSQL
- Test service configured (example_service pointing to httpbin.org)
- Configured plugins:
  - Rate Limiting (5 requests per minute)
  - CORS (configured for cross-origin requests)
  - Prometheus metrics (enabled for monitoring)

## Prerequisites

- Docker and Docker Compose
- curl (for testing)
- jq (for JSON processing)

## Installation

1. Clone the repository:
```bash
git clone https://github.com/athena-ai/athena-gateway.git
cd athena-gateway
```

2. Create a `.env` file with the required environment variables (see `.env.example`)

3. Start the services:
```bash
docker-compose up -d
```

## Configuration

### Exposed Ports

- Kong Admin API: 8001
- Kong Proxy: 8000
- PostgreSQL: 5432

### Current Routes

- `/test/*` - Routes to httpbin.org (example service)

### Plugin Configuration

#### Rate Limiting
- 5 requests per minute
- Local policy (no Redis required)
- Returns 429 status code when exceeded

#### CORS
- Allows all origins (`*`)
- Supports common HTTP methods (GET, POST, PUT, DELETE, OPTIONS)
- Allows credentials
- 1-hour max age for preflight requests

#### Prometheus
- Enabled for basic metrics
- Per-consumer tracking enabled

## Testing

Test the API Gateway functionality:

```bash
# Test the example service
curl http://localhost:8000/test/get

# Test rate limiting
for i in {1..6}; do curl -i http://localhost:8000/test/get; sleep 1; done

# Test CORS
curl -i -H "Origin: http://example.com" http://localhost:8000/test/get
```

## Next Steps

- [ ] Configure authentication
- [ ] Set up SSL/TLS certificates
- [ ] Create declarative configuration
- [ ] Set up monitoring dashboards
- [ ] Document all endpoints
- [ ] Configure additional security plugins

## Project Structure

```
.
├── config/
│   ├── kong.yml
│   └── plugins/
│       ├── auth.yml
│       ├── cors.yml
│       ├── prometheus.yml
│       ├── rate-limiting.yml
│       └── request-termination.yml
├── docker/
│   └── docker-compose.yml
├── docs/
│   └── endpoints.md
├── kubernetes/
│   └── values.yaml
├── scripts/
│   ├── setup-kong.sh
│   └── test-routes.sh
├── .env
├── .gitignore
├── docker-compose.yml
└── README.md
```

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

## License

[Add appropriate license]
