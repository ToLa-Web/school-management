# School Management Backend

Simple setup and run guide.

## 🚀 Get Started (5 minutes)

### 1. Prerequisites
- Docker Desktop installed
- Git installed

### 2. Setup
```bash
cd backend
cp .env.example .env
```
Edit `.env` and add email password (get from Gmail App Passwords)

### 3. Start
```bash
docker compose up -d
```

### 4. Access
- **API Docs:** http://localhost:5001/swagger
- **Database UI:** http://localhost:5050
- **Test Login:** admin@school.com / Password123!

## 👥 Default Users

All passwords: `Password123!`

| Role | Email |
|------|-------|
| Admin | admin@school.com |
| Teacher | teacher1@school.com |
| Student | student1@school.com |
| Parent | parent1@school.com |

## 📋 Commands

```bash
# Start backend
docker compose up -d

# Stop backend  
docker compose down

# View logs
docker compose logs -f

# Check status
docker compose ps

# Access database
docker exec -it auth_db bash

# Reset (deletes data!)
docker compose down -v && docker compose up -d
```

## 🔧 Troubleshooting

**Port 5001 in use?**
- Edit docker-compose.yml and change port

**Services not starting?**
- Check Docker is running
- Check logs: `docker compose logs`

**Can't login?**
- Verify seed data ran: `docker compose logs auth_service`
- Check .env has email password

**Database issue?**
- Restart: `docker compose restart auth_db`

## 📚 Documentation

- **Simple Start:** [START_HERE.md](./START_HERE.md)
- **Setup Done:** [DONE.md](./DONE.md)
- **Full Documentation:** [Full README with details]

## 🏗️ Architecture

```
docker-compose.yml
├── auth-service (API) - port 5001
├── auth-db (PostgreSQL) - port 5433
└── pgadmin (UI) - port 5050
```

## 🎯 For Your Team

1. Clone repository
2. Go to backend directory
3. Run `setup-windows.bat` (Windows) or `bash setup-unix.sh` (Mac/Linux)
4. Wait 15 seconds
5. Open http://localhost:5001/swagger
6. Done!

---

**Questions?** Check [DONE.md](./DONE.md) or [START_HERE.md](./START_HERE.md)

**Version:** 1.0  
**Last Updated:** 2026-02-16

