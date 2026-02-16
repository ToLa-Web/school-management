# School Management Backend - Simple Setup Guide

## Prerequisites
- Docker Desktop installed
- Git installed

## Quick Start (5 minutes)

### 1. Setup Environment
```bash
cd backend
cp .env.example .env
```
Edit `.env` and add your email password from Gmail App Passwords.

### 2. Start Services
```bash
docker compose up -d
```

### 3. Access Services
- **API Docs:** http://localhost:5001/swagger
- **Database Admin:** http://localhost:5050
- **Test Login:** admin@school.com / Password123!

## Default Credentials

| Role | Email | Password |
|------|-------|----------|
| Admin | admin@school.com | Password123! |
| Teacher | teacher1@school.com | Password123! |
| Student | student1@school.com | Password123! |
| Parent | parent1@school.com | Password123! |

## Basic Commands

```bash
# Start backend
docker compose up -d

# Stop backend
docker compose down

# View logs
docker compose logs -f

# Check status
docker compose ps

# Reset database (deletes all data!)
docker compose down -v && docker compose up -d
```

## Troubleshooting

| Issue | Solution |
|-------|----------|
| Port 5001 in use | Change port in docker-compose.yml |
| Can't start services | Check Docker is running |
| API not responding | Run: `docker compose logs auth_service` |
| Database connection error | Run: `docker compose restart auth_db` |

## What's Running

- **API Server** - http://localhost:5001 (port 5001)
- **PostgreSQL Database** - localhost:5433 (port 5433)
- **PgAdmin UI** - http://localhost:5050 (port 5050)

## Database Access

**Via PgAdmin UI:**
- URL: http://localhost:5050
- Email: admin@school.com
- Password: admin123

**Via Command Line:**
```bash
docker exec -it auth_db psql -U auth_user -d auth_db
```

## Development

The backend auto-builds and runs on startup. Changes to code require:

```bash
# Option 1: Auto-reload (if enabled)
docker compose logs -f auth_service

# Option 2: Manual rebuild
docker compose up -d --build
```

## That's It!

You're ready to develop. Just:
1. Keep the services running with `docker compose up -d`
2. Access API at http://localhost:5001/swagger
3. Test endpoints with provided credentials
4. Check logs if anything fails

**For help:** Read the full README.md in this directory.
