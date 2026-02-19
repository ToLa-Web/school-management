# Quick Reference Card - Backend Commands

Print this or bookmark it! All commands should run from the `backend` directory.

---

## 🚀 Service Management

| Command | Purpose | Notes |
|---------|---------|-------|
| `docker compose up -d` | Start services | Runs in background, takes 15-20 sec |
| `docker compose down` | Stop services | Keeps data in database |
| `docker compose restart` | Restart services | Reconnects to same database |
| `docker compose logs -f` | View live logs | Press Ctrl+C to exit |
| `docker compose ps` | Check status | Should show 3 running containers |

---

## 🔍 Monitoring & Debugging

| Command | Purpose |
|---------|---------|
| `docker compose logs -f auth_service` | Backend logs only |
| `docker compose logs -f auth_db` | Database logs only |
| `docker compose logs --tail 100` | Last 100 lines |
| `docker stats` | Container resource usage |
| `docker compose exec auth_service ping auth_db` | Test container connectivity |

---

## 💾 Database Management

| Command | Purpose | ⚠️ WARNING |
|---------|---------|-----------|
| `docker compose exec auth_db psql -U auth_user -d auth_db` | PostgreSQL CLI | Interactive mode |
| `docker compose exec auth_db bash -c 'PGPASSWORD=auth_pass psql -U auth_user -d auth_db -c "SELECT * FROM \"Users\";"'` | Query users | Read-only |
| `docker compose down -v` | Reset database | Deletes ALL data! |
| `docker compose up -d --build` | Rebuild & restart | Use after code changes |

---

## 🌐 Access Points

| Service | URL | Purpose |
|---------|-----|---------|
| API Documentation | http://localhost:5001/swagger | Browse & test endpoints |
| Database Admin | http://localhost:5050 | Manage database |
| API Base URL | http://localhost:5001/api | Make HTTP requests to |

---

## 🧪 Testing

```bash
# Test authentication endpoint
curl -X POST http://localhost:5001/api/auth/authenticate \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@school.com","password":"Password123!"}'

# Should return: access token + user info
```

---

## 🛠️ Development Workflow

```bash
# Code changes in .NET files
↓
# Option 1: Auto-reload (development mode)
docker compose logs -f auth_service
# Watch for changes

# Option 2: Manual rebuild
docker compose up -d --build

# Option 3: Stop & restart
docker compose down
docker compose up -d
```

---

## 🔧 Advanced Troubleshooting

```bash
# Force rebuild from scratch
docker compose down
docker volume rm backend_auth_db_data
docker compose up -d --build

# Check Docker resource limits
docker stats

# Clean unused Docker resources
docker system prune

# View service environment variables
docker compose exec auth_service env | grep -i connection
```

---

## 🚨 Emergency Commands

```bash
# If port 5001 is stuck
netstat -ano | findstr :5001

# Force remove containers
docker compose down
docker rm -f auth_service auth_db

# Check if services are locked
docker ps -a

# Restart Docker daemon (nuclear option)
# On Windows: Restart Docker Desktop
# On Mac: Restart Docker Desktop  
# On Linux: sudo systemctl restart docker
```

---

## 📝 File Locations

| File | Location | Purpose |
|------|----------|---------|
| Environment Config | `backend/.env` | Secrets (never commit!) |
| Services Config | `backend/docker-compose.yml` | Container setup |
| Documentation | `backend/README.md` | Full guide |
| Seed Data | `AuthService.Infrastructure/Seed/` | Initial users |
| Database Context | `AuthService.Infrastructure/Data/` | EF Core config |

---

## 🔐 Security Reminders

⚠️ **DO NOT:**
- Commit `.env` file
- Share database passwords
- Use production credentials in development
- Run SQL drop commands on production

✅ **DO:**
- Use strong passwords
- Keep dependencies updated
- Review logs regularly
- Use HTTPS in production

---

## 📊 Performance Tips

```bash
# Check container resource usage
docker compose stats

# Optimize database queries
# Access PgAdmin: http://localhost:5050

# View slow queries (PostgreSQL)
docker compose exec auth_db bash -c 'PGPASSWORD=auth_pass psql -U auth_user -d auth_db -c "SELECT * FROM pg_stat_statements LIMIT 10;"'
```

---

## 🆘 Common Issues & Fixes

| Issue | Command |
|-------|---------|
| Port 5001 in use | Change in docker-compose.yml |
| Can't access database | `docker compose restart auth_db` |
| API not responding | `docker compose logs auth_service` |
| Seed data missing | `docker compose down -v && docker compose up -d` |
| Migrations not applied | `docker compose up -d --build` |

---

## 🎯 Pre-commit Checklist

Before pushing code:
```bash
# Test everything locally
docker compose up -d

# Verify no errors
docker compose logs

# Test API endpoints
curl http://localhost:5001/swagger

# Check git status
git status

# Verify .env is NOT being committed
git diff .env

# Ready to commit!
git add .
git commit -m "feat: description"
```

---

## 📚 Additional Resources

- **Full Docs:** See `backend/README.md`
- **Setup Help:** See `backend/SETUP_VERIFICATION.md`
- **Onboarding:** See `backend/TEAM_ONBOARDING.md`
- **Setup Summary:** See `backend/SETUP_SUMMARY.md`

---

**Print Date:** 2026-02-16  
**For:** School Management Backend  
**Keep Handy!** 📌
