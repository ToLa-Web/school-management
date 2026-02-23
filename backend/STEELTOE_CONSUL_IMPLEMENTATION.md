# Steeltoe + Consul Service Discovery Implementation

## Overview
This document describes the Steeltoe-inspired service discovery implementation using HashiCorp Consul for the school management backend microservices. All services can now discover and communicate with each other through the API Gateway using Consul service registry.

## Architecture

### Services
- **api-gateway** (YARP Reverse Proxy): Routes requests to backend services via Consul discovery
- **auth-service**: Authentication/authorization service, self-registers with Consul
- **school-service**: School data management service, self-registers with Consul
- **consul**: Service registry and configuration management

### Network
- All services run on the `school_network` bridge network
- Container-to-container communication uses service names (e.g., `auth-service:8080`)
- Services exposed on host:
  - api-gateway: `localhost:5001` → container port `8080`
  - auth-service: `localhost:5002` → container port `8080`
  - school-service: `localhost:5003` → container port `8080`
  - consul: `localhost:8500` → container port `8500`

## Components Implemented

### 1. Consul Configuration
- **Image**: consul:1.15.4
- **Ports**: 8500 (HTTP API), 8600 (DNS)
- **Mode**: Development (single server bootstrap)
- **Health Checks**: Automatic health checking via HTTP endpoints

### 2. Auth Service
**File**: `backend/services/auth-service/AuthService/AuthService.API/Program.cs`

**Key Features**:
- Consul client registration with exponential backoff retry (6 attempts)
- Database connection retry with exponential backoff (10 attempts)
- Health endpoint: `GET /health` returns `{ status = "ok", service = "auth-service" }`
- Automatic deregistration on shutdown

**Service Registration**:
```csharp
var registration = new AgentServiceRegistration()
{
    ID = "auth-service-" + Guid.NewGuid().ToString(),
    Name = "auth-service",
    Address = "auth-service",
    Port = 8080,
    Tags = new[] { "auth", "api" },
    Check = new AgentServiceCheck
    {
        HTTP = "http://auth-service:8080/health",
        Interval = TimeSpan.FromSeconds(10),
        DeregisterCriticalServiceAfter = TimeSpan.FromMinutes(1)
    }
};
```

### 3. School Service
**File**: `backend/services/school-service/SchoolService/SchoolService.API/Program.cs`

**Key Features**:
- Identical to auth-service: Consul registration with retry
- Database connection retry for PostgreSQL
- Health endpoint: `GET /health`
- Automatic deregistration on shutdown

### 4. API Gateway (YARP)
**Files**:
- `backend/services/api-gateway/ApiGateway/Program.cs`
- `backend/services/api-gateway/ApiGateway/DiscoveryProxyConfigProvider.cs`

**Key Features**:
- Queries Consul on startup to discover services
- Builds YARP cluster config dynamically from Consul instances
- Routes `/api/auth/*` → auth-service cluster
- Routes `/api/school/*` → school-service cluster
- Falls back to docker-compose service names if Consul instances not found

**Discovery Flow**:
```csharp
var (routes, clusters) = ApiGateway.DiscoveryConfigFactory.BuildFromConsul(consulHost, consulPort);
builder.Services.AddReverseProxy().LoadFromMemory(routes, clusters);
```

### 5. Docker Compose Configuration
**File**: `backend/docker-compose.yml`

**Key Changes**:
- Added `depends_on: consul` to auth-service and school-service
- Added `ASPNETCORE_URLS: "http://+:8080"` to all services (explicit container binding)
- All services on `school_network` bridge
- Consul container pre-configured

## Startup Flow

### 1. Consul Starts First
```
consul_server starts → listening on 0.0.0.0:8500
```

### 2. Database Services Start
```
auth-db (Postgres) → ready
school-db (Postgres) → ready
```

### 3. Auth Service Starts
```
AuthService container starts
  → Retries connecting to auth-db (up to 10 attempts, 2s backoff)
  → Runs migrations and seeding
  → Retries registering with Consul (up to 6 attempts, 2s backoff)
  → Prints "AuthService registered with Consul"
  → Ready to serve requests
```

### 4. School Service Starts
```
SchoolService container starts
  → Retries connecting to school-db (up to 10 attempts, 2s backoff)
  → Runs EnsureCreated and seeding
  → Retries registering with Consul (up to 6 attempts, 2s backoff)
  → Prints "SchoolService registered with Consul"
  → Ready to serve requests
```

### 5. API Gateway Starts
```
ApiGateway container starts
  → Queries Consul for "auth-service" instances
  → Queries Consul for "school-service" instances
  → Builds YARP routes and clusters from discovered instances
  → Falls back to docker-compose service names if no instances
  → Ready to proxy requests
```

## Health Checks

### Service Health Endpoints
Each service exposes a `/health` endpoint:

**Request**:
```bash
curl http://localhost:5001/health
curl http://localhost:5001/api/auth/health
curl http://localhost:5001/api/school/health
```

**Response** (200 OK):
```json
{
  "status": "ok",
  "service": "auth-service"
}
```

### Consul Health Monitoring
- Consul checks each service health every 10 seconds
- If service becomes unresponsive, Consul waits 1 minute before deregistration
- Services automatically re-register after coming back online

## Packages Used

### Production
- **Consul** v1.7.14.10 - HashiCorp Consul .NET client
- **Yarp.ReverseProxy** v2.2.0 - Microsoft YARP reverse proxy

### Why No Steeltoe?
The implementation uses the Consul .NET client directly instead of Steeltoe Discovery because:
- Simpler dependency management (fewer transitive dependencies)
- Better control over registration/discovery logic
- Explicit error handling with retries
- Works reliably across .NET 6/7/8
- No package version compatibility issues

## API Gateway Routing

### Routes
| Path | Target | Service |
|------|--------|---------|
| `/api/auth/*` | auth-service cluster | auth-service |
| `/api/school/*` | school-service cluster | school-service |
| `/health` | Gateway health | api-gateway |

### Example Requests
```bash
# Direct service calls (from host, via Docker port mapping)
curl http://localhost:5002/health                    # auth-service directly
curl http://localhost:5003/health                    # school-service directly

# Via gateway (service discovery)
curl http://localhost:5001/api/auth/health           # proxied to auth-service
curl http://localhost:5001/api/school/health         # proxied to school-service
```

## Troubleshooting

### Service Not Registering
**Symptoms**: Service logs show "Attempt N to register with Consul failed"

**Causes**:
1. Consul not reachable (wrong host/port)
2. Network connectivity issue
3. Service registration takes longer than timeout

**Solutions**:
1. Check Consul is running: `docker compose ps consul_server`
2. Test connectivity: `docker exec -it auth_service curl http://consul:8500/v1/agent/self`
3. Check service logs: `docker compose logs auth-service | grep -i "consul\|attempt"`

### Database Connection Failed
**Symptoms**: Service logs show "Attempt N to connect/migrate DB failed"

**Causes**:
1. PostgreSQL not ready
2. Connection string incorrect
3. Network connectivity issue

**Solutions**:
1. Check DB is running: `docker compose ps auth-db school-db`
2. Verify connection string: check `appsettings.json` and `docker-compose.yml`
3. Check Docker network: `docker network inspect school_network`

### Gateway Returns 502 Bad Gateway
**Symptoms**: `curl http://localhost:5001/api/auth/health` returns 502

**Causes**:
1. Backend service not registered in Consul
2. Backend service not healthy
3. Gateway didn't discover instances

**Solutions**:
1. Check Consul services: `curl http://localhost:8500/v1/agent/services`
2. Check service health: `docker compose logs auth-service | tail -50`
3. Restart gateway to re-discover services: `docker compose restart api-gateway`

## Monitoring

### View Service Registrations
```bash
curl http://localhost:8500/v1/agent/services
```

### View Service Details
```bash
curl http://localhost:8500/v1/catalog/service/auth-service
```

### View Consul Logs
```bash
docker compose logs consul -f
```

### View Service Logs
```bash
docker compose logs auth-service -f
docker compose logs school-service -f
docker compose logs api-gateway -f
```

### Check Container Status
```bash
docker compose ps
docker ps -a
```

## Operations

### Start Services
```bash
cd backend
docker compose up -d --build
```

### Stop Services
```bash
cd backend
docker compose stop
```

### Restart Services
```bash
cd backend
docker compose restart
```

### Rebuild and Restart
```bash
cd backend
docker compose down --remove-orphans
docker compose up -d --build --force-recreate
```

### View Logs
```bash
docker compose logs -f                    # all services
docker compose logs auth-service -f       # specific service
docker compose logs --tail=200            # last 200 lines
```

## Future Enhancements

### 1. YARP Config Refresh
Implement periodic refresh of YARP config to automatically detect newly registered services:
- Add background task that queries Consul every 30 seconds
- Update YARP memory config when services change

### 2. Consul KV Store
Use Consul KV store for centralized configuration:
- Database connection strings
- JWT secrets
- Feature flags
- Rate limiting config

### 3. Circuit Breaker
Add Polly circuit breaker for inter-service communication:
- Prevent cascading failures
- Automatic retry with backoff
- Health-based routing

### 4. Distributed Tracing
Integrate OpenTelemetry:
- Trace requests across services
- Performance monitoring
- Error tracking

### 5. Service Mesh (Optional)
Consider Consul Connect for:
- Mutual TLS between services
- Fine-grained access control
- Load balancing

## Security Considerations

### Current Implementation
- No TLS between services (dev mode)
- Services accessible directly on Docker network
- Consul UI publicly available on localhost:8500

### Production Hardening
1. Enable Consul ACLs
2. Use TLS for service communication
3. Restrict Consul UI access
4. Use secrets management (Vault)
5. Network segmentation
6. Rate limiting and DDoS protection

## Testing

### Health Check
```bash
curl -v http://localhost:5001/health
curl -v http://localhost:5001/api/auth/health
curl -v http://localhost:5001/api/school/health
```

### Service Discovery
```bash
# From host
curl http://localhost:8500/v1/agent/services

# From inside container
docker exec -it auth_service curl http://consul:8500/v1/agent/services
```

### Direct Service Calls
```bash
# Auth service directly
curl http://localhost:5002/health

# School service directly
curl http://localhost:5003/health

# Via gateway
curl http://localhost:5001/api/auth/health
curl http://localhost:5001/api/school/health
```

## Dependencies

### Docker Compose Services
- `consul:1.15.4` - Service registry
- `postgres:16` (auth-db, school-db) - Database
- `dpage/pgadmin4:latest` - DB administration
- Custom .NET 8 images for services

### .NET Packages
- `Consul` v1.7.14.10
- `Yarp.ReverseProxy` v2.2.0
- `Microsoft.EntityFrameworkCore`
- `Npgsql` - PostgreSQL driver
- Standard ASP.NET Core libraries

## Files Modified

```
backend/
├── docker-compose.yml (updated: added depends_on, ASPNETCORE_URLS)
├── services/
│   ├── api-gateway/ApiGateway/
│   │   ├── ApiGateway.csproj (added: Consul package)
│   │   ├── Program.cs (added: Consul discovery, YARP LoadFromMemory)
│   │   └── DiscoveryProxyConfigProvider.cs (new: Consul query factory)
│   ├── auth-service/AuthService/AuthService.API/
│   │   ├── AuthService.API.csproj (added: Consul package)
│   │   └── Program.cs (added: retry loops, Consul registration)
│   └── school-service/SchoolService/SchoolService.API/
│       ├── SchoolService.API.csproj (added: Consul package)
│       └── Program.cs (added: retry loops, Consul registration)
```

## Summary

✅ **Complete Implementation**:
- All services register with Consul on startup
- API Gateway discovers services and proxies requests
- Health checks monitor service availability
- Automatic deregistration on shutdown
- Resilient retry logic for transient failures
- Production-ready error handling and logging

✅ **Verified Working**:
- Services start without errors
- Services register with Consul
- Gateway routes requests to discovered services
- Health endpoints respond correctly
- Logs show successful registration and routing

**Status**: Ready for development and integration testing.

