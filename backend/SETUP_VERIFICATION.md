# Backend Setup Verification Checklist

Use this checklist to verify your backend setup is working correctly.

## Pre-requisites Verification

- [ ] Docker Desktop installed and running
- [ ] Git installed
- [ ] Repository cloned locally
- [ ] Terminal/Command Prompt open in `backend` directory

## Setup Steps

### Step 1: Prepare Environment
- [ ] Copy `.env.example` to `.env`
- [ ] Add `EMAILSETTINGS_APP_PASSWORD` to `.env`
- [ ] Save `.env` file

### Step 2: Start Services
- [ ] Run: `docker compose up -d`
- [ ] Wait 15-20 seconds for services to start
- [ ] Run: `docker compose ps` (verify all containers show "Up")

### Step 3: Verify Services

#### Check Containers
```bash
docker compose ps
```
Expected output - all should show "Up":
- [ ] auth_service (Port 5001)
- [ ] auth_db (Port 5433)
- [ ] pgadmin_container (Port 5050)

#### Test Database Connection
```bash
docker exec -it auth_db bash -c 'PGPASSWORD=auth_pass psql -U auth_user -d auth_db -c "SELECT COUNT(*) FROM \"Users\";"'
```
Expected: Should show a number (count of users)

- [ ] Database responds
- [ ] Users table exists with data

#### Test API
Open browser and go to: http://localhost:5001/swagger

- [ ] API accessible
- [ ] Swagger documentation loads
- [ ] Can see endpoints (auth/register, auth/authenticate, etc.)

#### Test Login
Using Swagger UI or curl:
```bash
curl -X POST http://localhost:5001/api/auth/authenticate \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@school.com","password":"Password123!"}'
```

Expected: Should receive access token and user info
- [ ] Get successful response with accessToken
- [ ] User role shows as 4 (Admin)

### Step 4: Verify Seed Data

All of these credentials should be able to login:

#### Admin
- [ ] Email: `admin@school.com` / Password: `Password123!`

#### Teachers  
- [ ] Email: `teacher1@school.com` / Password: `Password123!`
- [ ] Email: `teacher2@school.com` / Password: `Password123!`

#### Students
- [ ] Email: `student1@school.com` / Password: `Password123!`
- [ ] Email: `student2@school.com` / Password: `Password123!`

#### Parents
- [ ] Email: `parent1@school.com` / Password: `Password123!`
- [ ] Email: `parent2@school.com` / Password: `Password123!`

### Step 5: Database Administration

#### Access PgAdmin
```
URL: http://localhost:5050
Email: admin@school.com
Password: admin123
```

- [ ] PgAdmin loads and login succeeds
- [ ] Can add PostgreSQL server with settings:
  - Host: `auth-db`
  - Port: `5432`
  - Database: `auth_db`
  - Username: `auth_user`
  - Password: `auth_pass`

### Step 6: Logs Verification

View logs to ensure no errors:
```bash
docker compose logs auth_service
```

- [ ] No critical errors in logs
- [ ] Service shows it's accepting requests
- [ ] Migrations completed successfully

## Troubleshooting

### Issue: Port Already in Use
```bash
# Find what's using port 5001
netstat -ano | findstr :5001

# Stop the backend
docker compose down

# Change port in docker-compose.yml if needed
```
- [ ] Changed port in docker-compose.yml (if needed)
- [ ] Restarted services

### Issue: Database Not Initializing
```bash
# Clear everything and restart
docker compose down -v
docker compose up -d
```
- [ ] Services restarted fresh
- [ ] Seed data re-created

### Issue: Seed Data Not Present
```bash
# Check logs
docker logs auth_service | grep -i "seed"

# If not present, verify Users table
docker exec -it auth_db bash -c 'PGPASSWORD=auth_pass psql -U auth_user -d auth_db -c "\dt"'
```
- [ ] Users table exists
- [ ] Data was seeded (should see INSERT statements in logs)

## Common Commands

For team reference:

```bash
# Start backend
docker compose up -d

# Stop backend
docker compose down

# Stop and remove volumes (WARNING: deletes database)
docker compose down -v

# View logs
docker compose logs -f

# Specific service logs
docker compose logs -f auth_service

# Rebuild services
docker compose up -d --build

# Check container status
docker compose ps

# Access database shell
docker exec -it auth_db bash

# Access PostgreSQL CLI
docker exec -it auth_db psql -U auth_user -d auth_db
```

## Final Verification Summary

When all checks are complete:

- ✅ Docker containers running
- ✅ API responding on http://localhost:5001
- ✅ Database accessible
- ✅ Seed data present (7+ users)
- ✅ All credentials working
- ✅ PgAdmin accessible
- ✅ No critical errors in logs

**Status:** Backend is ready for development!

---

## For New Team Members

1. Clone repository
2. cd backend
3. Copy .env.example to .env and add email password
4. Run: `docker compose up -d`
5. Wait 15 seconds
6. Run health check: `docker compose ps`
7. Test API: http://localhost:5001/swagger
8. Use credentials from Step 4 above to test login

---

**Document Version:** 1.0  
**Last Updated:** 2026-02-16
