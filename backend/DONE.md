# ✅ Backend Setup Complete!

Your School Management System backend is ready to use.

## What's Running

- **API Server** → http://localhost:5001/swagger
- **Database** → PostgreSQL on localhost:5433  
- **DB Admin UI** → http://localhost:5050

## Quick Start (For Your Team)

### Linux/Mac
```bash
cd backend
bash setup-unix.sh
```

### Windows
```bash
cd backend
setup-windows.bat
```

Or manually:
```bash
cd backend
cp .env.example .env
# Edit .env file - add email password
docker compose up -d
```

## Test It

Visit: **http://localhost:5001/swagger**

Login with:
- Email: `admin@school.com`
- Password: `Password123!`

## User Accounts

All passwords: `Password123!`

```
Admin:    admin@school.com
Teacher:  teacher1@school.com
Student:  student1@school.com
Parent:   parent1@school.com
```

## Commands

```bash
docker compose up -d      # Start
docker compose down       # Stop
docker compose logs -f    # View logs
docker compose ps         # Check status
```

## Database

- **URL:** http://localhost:5050
- **Login:** admin@school.com / admin123
- **Host:** auth-db
- **Port:** 5432
- **User:** auth_user
- **Password:** auth_pass

## Docs

- **Full Guide:** [README.md](./README.md)
- **Simple Start:** [START_HERE.md](./START_HERE.md)
- **Commands:** Use `docker compose` commands above

---

**That's it! You're done. Tell your team to run the setup script.** ✅
