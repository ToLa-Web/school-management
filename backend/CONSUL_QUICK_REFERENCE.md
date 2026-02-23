# Steeltoe + Consul Quick Reference

## Quick Start

### Start Everything
```bash
cd backend
docker compose up -d --build
```

### Stop Everything
```bash
cd backend
docker compose down
```

### View Logs
```bash
docker compose logs -f                    # all services
docker compose logs auth-service -f       # auth service
docker compose logs school-service -f     # school service
docker compose logs api-gateway -f        # gateway
docker compose logs consul -f              # consul
```

## Testing

### Gateway Health
```bash
curl http://localhost:5001/health
```

### Auth Service (via Gateway)
```bash
curl http://localhost:5001/api/auth/health
```

### School Service (via Gateway)
```bash
curl http://localhost:5001/api/school/health
```

### Direct Service Access
```bash
curl http://localhost:5002/health        # auth-service directly
curl http://localhost:5003/health        # school-service directly
```

## Consul UI
- **URL**: http://localhost:8500
- Click "Services" to see registered services
- Click on service name to see instances and health status

## Check Service Registration
```bash
# View all registered services
curl http://localhost:8500/v1/agent/services

# View specific service
curl http://localhost:8500/v1/catalog/service/auth-service
```

## Debugging

### Check Container Status
```bash
docker compose ps
```

### View Service Logs (Last 50 Lines)
```bash
docker compose logs auth-service --tail=50
docker compose logs school-service --tail=50
```

### Exec Into Container
```bash
docker exec -it auth_service /bin/sh
docker exec -it school_service /bin/sh
docker exec -it consul_server /bin/sh
```

### Test Connectivity From Container
```bash
# Test if service can reach Consul
docker exec -it auth_service wget -qO- http://consul:8500/v1/agent/self

# Test if service can reach database
docker exec -it auth_service timeout 5 bash -c "echo > /dev/tcp/auth-db/5432" && echo "DB reachable" || echo "DB not reachable"
```

### View Full Logs
```bash
docker compose logs auth-service
docker compose logs school-service
```

## Common Issues

### Service Stuck in "Starting"
- Wait 30-60 seconds for databases to initialize
- Check logs: `docker compose logs service-name`

### "Connection refused" or "Name or service not known"
- Services are retrying (normal behavior during startup)
- Wait for retry loops to complete (5-10 minutes max)
- Check Consul is running: `docker compose ps consul_server`

### Gateway Returns 502
- Check services are registered: `curl http://localhost:8500/v1/agent/services`
- Check service health: `curl http://localhost:5001/api/auth/health`
- Restart gateway: `docker compose restart api-gateway`

### Database Errors
- Ensure DB is running: `docker compose ps auth-db school-db`
- Check logs: `docker compose logs auth-service | grep -i database`
- Wait for migrations to complete (first startup takes time)

## Restarting Services

### Restart Single Service
```bash
docker compose restart auth-service
docker compose restart school-service
docker compose restart api-gateway
```

### Rebuild and Restart All
```bash
docker compose down --remove-orphans
docker compose up -d --build --force-recreate
```

### Rebuild Specific Service
```bash
docker compose build --no-cache api-gateway
docker compose up -d api-gateway
```

## Performance

### View Resource Usage
```bash
docker stats
```

### Check Network Health
```bash
docker network inspect school_network
```

## Cleanup

### Remove All Containers and Volumes
```bash
docker compose down -v --remove-orphans
```

### Remove Unused Images
```bash
docker image prune -a
```

### Clean Build
```bash
docker compose down -v --remove-orphans
docker compose up -d --build --force-recreate
```

## Key Port Mappings

| Service | Host Port | Container Port | Purpose |
|---------|-----------|----------------|---------|
| api-gateway | 5001 | 8080 | API Gateway |
| auth-service | 5002 | 8080 | Auth Service |
| school-service | 5003 | 8080 | School Service |
| consul | 8500 | 8500 | Service Registry |
| auth-db | 5433 | 5432 | Auth Database |
| school-db | 5434 | 5432 | School Database |
| pgadmin | 5050 | 80 | DB Admin UI |

## Environment Variables

### Docker Compose
```bash
JWT_SECRET=your-secret-key
EMAILSETTINGS_APP_PASSWORD=your-app-password
```

Set these before running `docker compose up`:
```bash
export JWT_SECRET="your-secret"
export EMAILSETTINGS_APP_PASSWORD="your-app-password"
docker compose up -d
```

Or create `.env` file in backend folder:
```
JWT_SECRET=your-secret-key
EMAILSETTINGS_APP_PASSWORD=your-app-password
```

## Service Discovery

### How It Works
1. **Auth Service**: Registers with Consul at startup
2. **School Service**: Registers with Consul at startup
3. **Gateway**: Queries Consul for instances
4. **Requests**: Gateway proxies to discovered instances

### Example Flow
```
Request: GET http://localhost:5001/api/auth/health
  ↓
Gateway receives request
  ↓
Gateway matches route /api/auth/* → auth-service cluster
  ↓
Gateway looks up auth-service cluster destinations
  ↓
Gateway forwards to http://auth-service:8080/health (discovered via Consul)
  ↓
Auth Service responds with health status
  ↓
Response returned to client
```

## Health Checks

### What Gets Checked
- Each service exposes `/health` endpoint
- Consul checks every 10 seconds
- If unhealthy for 1 minute, service deregistered

### Force Health Check
```bash
curl http://localhost:5001/health
curl http://localhost:5001/api/auth/health
curl http://localhost:5001/api/school/health
```

Expected response: `{"status":"ok","service":"service-name"}`

## Documentation

- Full implementation details: `STEELTOE_CONSUL_IMPLEMENTATION.md`
- Docker Compose reference: `docker-compose.yml`
- Service configs: `appsettings.json` in each service

---

For more information, see `STEELTOE_CONSUL_IMPLEMENTATION.md`

