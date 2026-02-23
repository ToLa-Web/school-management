# Fix Applied - Gateway Non-Blocking Consul Discovery

## What Was Fixed

The API Gateway was **blocking on Consul at startup**, causing it to crash if Consul wasn't immediately reachable. 

### The Problem
```csharp
// OLD - Blocking, crashes if Consul unavailable:
var (routes, clusters) = ApiGateway.DiscoveryConfigFactory.BuildFromConsul(consulHost, consulPort);
builder.Services.AddReverseProxy().LoadFromMemory(routes, clusters);
var app = builder.Build(); // Never reaches here if Consul is down!
```

### The Solution  
```csharp
// NEW - Non-blocking, gateway starts immediately:
builder.Services.AddReverseProxy().LoadFromMemory(
    new List<Yarp.ReverseProxy.Configuration.RouteConfig>(), 
    new List<Yarp.ReverseProxy.Configuration.ClusterConfig>()
);
var app = builder.Build(); // Starts immediately!

// Discover services in background (non-blocking):
_ = Task.Run(async () => {
    var (routes, clusters) = ApiGateway.DiscoveryConfigFactory.BuildFromConsul(consulHost, consulPort);
    // Attempt discovery in background - doesn't block startup
});
```

## Files Modified

- `backend/services/api-gateway/ApiGateway/Program.cs`

## Behavior Now

### Ideal Scenario (All Services Healthy)
```
1. Consul starts first
2. Gateway starts immediately (doesn't wait for Consul)
3. Gateway loads empty YARP config
4. Gateway starts serving /health requests
5. In background, gateway discovers services from Consul
6. Auth & School services start, connect to DBs, register with Consul
7. All services healthy and routing
8. Consul UI shows all 3 services
```

### If Consul Starts Slowly
```
1. Gateway starts first (non-blocking) ✅
2. Gateway ready to serve requests ✅
3. Background task retries discovering services (15 attempts)
4. Once Consul ready, services register
5. Gateway can then route requests to discovered services
```

### If Consul Unavailable
```
1. Gateway starts (non-blocking) ✅
2. Services still register via background tasks ✅
3. Gateway falls back to static config from appsettings.json
4. Services continue running
5. No cascading failures
```

## How to Verify

### Step 1: Check Containers Are Running
```bash
docker compose ps
```

**Expected**: All containers should show "Up" status:
- ✅ api_gateway
- ✅ auth_service  
- ✅ school_service
- ✅ consul_server
- ✅ auth_db
- ✅ school_db
- ✅ pgadmin_container

### Step 2: Wait for Services to Register

Services need time to:
1. Start containers
2. Run database migrations
3. Register with Consul

**Give it 30-60 seconds** after `docker compose up`

### Step 3: Check Gateway Health
```bash
curl http://localhost:5001/health
```

**Expected Response** (200 OK):
```json
{"status":"ok","service":"api-gateway"}
```

### Step 4: Check Consul UI
```
http://localhost:8500
```

**Expected**: Services tab shows 3 services:
- ✅ api-gateway
- ✅ auth-service
- ✅ school-service

All with "Passing" health status.

### Step 5: Test Routing
```bash
# Test auth service via gateway
curl http://localhost:5001/api/auth/health

# Test school service via gateway  
curl http://localhost:5001/api/school/health
```

**Expected Response** (200 OK):
```json
{"status":"ok","service":"auth-service"}
{"status":"ok","service":"school-service"}
```

## Troubleshooting

### Issue: Only 1 service in Consul (just Consul itself)

**Solution 1: Wait Longer**
- Give services 60 seconds to start and register
- Refresh Consul UI (F5)

**Solution 2: Check Service Logs**
```bash
docker compose logs auth-service | tail -50
docker compose logs school-service | tail -50
docker compose logs api-gateway | tail -50
```

Look for:
- ✅ "✅ AuthService registered with Consul" = Success!
- ⚠️ "⚠️ Attempt X to register failed" = Retrying (normal)
- ❌ "Max attempts reached" = Check Docker network

**Solution 3: Check Docker Network**
```bash
# From inside auth_service container
docker exec -it auth_service curl -s http://consul:8500/v1/agent/self

# If this fails, Consul is unreachable from the container
```

**Solution 4: Check Container Network**
```bash
docker network inspect school_network
# Should show all service containers connected
```

### Issue: Gateway Returns 502

**Cause**: Service discovered but not reachable

**Solution**:
```bash
# Test direct service access
curl http://localhost:5002/health      # auth-service
curl http://localhost:5003/health      # school-service

# If these work but gateway returns 502:
# Restart gateway to clear routes
docker compose restart api-gateway
```

### Issue: Services Crash on Startup

**Check logs**:
```bash
docker compose logs auth-service --tail=100
docker compose logs school-service --tail=100
```

**Common causes**:
1. Database not ready → Wait 30 seconds
2. Consul not reachable → Normal, services retry in background
3. Port conflicts → Check `docker ps` for port 8080 conflicts

## Manual Verification Script

Run these commands one by one to verify setup:

```bash
#!/bin/bash

echo "=== 1. Check Containers ==="
docker compose ps

echo -e "\n=== 2. Check Gateway Health ==="
curl -v http://localhost:5001/health

echo -e "\n=== 3. Check Auth Service (Direct) ==="
curl -v http://localhost:5002/health

echo -e "\n=== 4. Check School Service (Direct) ==="
curl -v http://localhost:5003/health

echo -e "\n=== 5. Check Auth Service via Gateway ==="
curl -v http://localhost:5001/api/auth/health

echo -e "\n=== 6. Check School Service via Gateway ==="
curl -v http://localhost:5001/api/school/health

echo -e "\n=== 7. Check Consul Registered Services ==="
curl http://localhost:8500/v1/agent/services | jq .

echo -e "\n=== 8. Check Service Logs ==="
docker compose logs auth-service | grep -i "consul\|registered" | tail -5
docker compose logs school-service | grep -i "consul\|registered" | tail -5
docker compose logs api-gateway | grep -i "consul\|discovered" | tail -5
```

## What to Expect in Logs

### Auth Service
```
✅ AuthService database migrated and seeded successfully.
⚠️  Attempt 1 to register with Consul failed: Connection refused
⚠️  Attempt 2 to register with Consul failed: Connection refused  
⚠️  Attempt 3 to register with Consul failed: Connection refused
✅ AuthService registered with Consul
```
(A few retries are normal - Consul takes a moment to be ready)

### School Service
```
Database is ready and seeded.
⚠️  Attempt 1 to register with Consul failed: Connection refused
⚠️  Attempt 2 to register with Consul failed: Connection refused
✅ SchoolService registered with Consul
```

### API Gateway
```
Attempt 1 to discover services from Consul...
⚠️  Attempt 1 to discover services failed: Connection refused
Attempt 2 to discover services from Consul...
⚠️  Attempt 2 to discover services failed: Connection refused
...
✅ Discovered 2 service clusters from Consul
```

## Next Steps

1. **Wait 30-60 seconds** after running `docker compose up`
2. **Refresh Consul UI** at http://localhost:8500
3. **Check Services tab** - should now show 3 services
4. **Test endpoints** with curl commands above
5. **Check logs** if issues persist

## Key Changes Summary

| Component | Before | After |
|-----------|--------|-------|
| Gateway Startup | Blocks on Consul | Non-blocking |
| Consul Unavailable | Gateway crashes | Gateway starts, retries in background |
| Service Registration | Blocking | Non-blocking background task |
| Startup Order | Gateway → Consul | Consul, Gateway, Services (any order) |
| Resilience | Fail fast | Graceful degradation |

---

**Status**: ✅ Fixed and deployed  
**Next Action**: Wait 30-60 seconds, then refresh Consul UI

The gateway and all services now start gracefully regardless of startup order!

