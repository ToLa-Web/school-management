# Team Onboarding Guide

Welcome to the School Management System development team! This guide will help you get started quickly.

## 📋 What You Need

### Required Software
- **Docker Desktop** - For running the backend
  - Windows: https://www.docker.com/products/docker-desktop
  - Mac: https://www.docker.com/products/docker-desktop
  - Linux: https://docs.docker.com/engine/install/

- **Git** - For version control
  - https://git-scm.com/

- **Flutter SDK** (if working on frontend)
  - https://flutter.dev/docs/get-started/install

### Hardware Requirements
- 8GB RAM minimum (16GB recommended)
- 20GB free disk space (for Docker images and database)
- Stable internet connection

---

## 🚀 Day 1 - Initial Setup

### 1. Clone the Repository
```bash
git clone https://github.com/ToLa-Web/school-management.git
cd school-management
```

### 2. Configure Backend

```bash
cd backend
cp .env.example .env
```

Edit `.env` and add your email service credentials:
```env
EMAILSETTINGS_APP_PASSWORD=your_app_specific_password_here
```

Get this from Gmail: https://myaccount.google.com/apppasswords

### 3. Start Backend Services

```bash
docker compose up -d
```

Wait 15-20 seconds for initialization.

### 4. Verify Setup

```bash
# Check containers
docker compose ps

# Test API
curl http://localhost:5001/swagger
```

Expected output: Swagger UI loads at http://localhost:5001/swagger

---

## 🧪 Testing Your Setup

### Test Login with Admin Account
```bash
curl -X POST http://localhost:5001/api/auth/authenticate \
  -H "Content-Type: application/json" \
  -d '{"email":"admin@school.com","password":"Password123!"}'
```

Expected: Token and user info returned

### Test with Other Credentials
- **Teacher:** teacher1@school.com / Password123!
- **Student:** student1@school.com / Password123!
- **Parent:** parent1@school.com / Password123!

---

## 💡 Key Resources

### Documentation
- **README:** [../README.md](../README.md)
- **Backend Setup:** [README.md](README.md)
- **API Docs:** http://localhost:5001/swagger (after starting backend)
- **Setup Checklist:** [SETUP_VERIFICATION.md](SETUP_VERIFICATION.md)

### Database Access
- **PgAdmin:** http://localhost:5050
- **Default Email:** admin@school.com
- **Default Password:** admin123

Add PostgreSQL server with:
- Host: `auth-db`
- Port: `5432`
- Database: `auth_db`
- Username: `auth_user`
- Password: `auth_pass`

---

## 📦 Project Structure

```
school-management/
├── backend/                    # .NET Microservices
│   ├── docker-compose.yml      # Service orchestration
│   ├── .env.example            # Environment template
│   ├── README.md               # Backend documentation
│   └── services/
│       └── auth-service/       # Authentication service
├── frontend/                   # Flutter Application
│   ├── pubspec.yaml
│   ├── lib/
│   └── test/
└── README.md                   # Main documentation
```

---

## 🔧 Common Backend Commands

### Services Management
```bash
# Start services
docker compose up -d

# Stop services
docker compose down

# Restart services
docker compose restart

# View logs
docker compose logs -f

# View specific service logs
docker compose logs -f auth-service
```

### Database Commands
```bash
# Access database
docker exec -it auth_db bash

# PostgreSQL CLI
docker exec -it auth_db psql -U auth_user -d auth_db

# Run query
docker exec -it auth_db psql -U auth_user -d auth_db -c "SELECT * FROM \"Users\" LIMIT 5;"
```

### Troubleshooting
```bash
# Rebuild services
docker compose up -d --build

# Reset database (WARNING: deletes all data)
docker compose down -v
docker compose up -d

# Check container health
docker ps
```

---

## 🌳 Git & Development Workflow

### Creating a Feature Branch
```bash
git checkout main
git pull origin main
git checkout -b feature/your-feature-name
```

### Regular Commits
```bash
git add .
git commit -m "feat: add user authentication"
git push origin feature/your-feature-name
```

### Pull Request
1. Push your branch to GitHub
2. Create Pull Request on GitHub
3. Ask for code review
4. Wait for approval
5. Merge to main
6. Delete your branch

### Commit Message Format
```
type: short description

Optional longer description explaining the change

feat:    new feature
fix:     bug fix
docs:    documentation
refactor: code restructuring
test:    test additions
```

---

## 🔐 Important Security Notes

### Never Commit
- `.env` file (contains secrets)
- Database passwords
- API keys
- Personal credentials

### For Frontend Developers
- Store API tokens securely
- Use encrypted storage for sensitive data
- Never log credentials

### For Backend Developers
- Hash passwords before storage (already done)
- Validate all inputs
- Use HTTPS in production
- Rotate secrets periodically

---

## 📞 Getting Help

### Common Issues

**1. Port Already in Use**
```bash
# Check what's using the port
netstat -ano | findstr :5001

# Use different port in docker-compose.yml
```

**2. Docker Not Running**
```bash
# Start Docker Desktop manually
# Or on Linux: sudo systemctl start docker
```

**3. Permission Denied**
```bash
# On Linux, add user to docker group
sudo usermod -aG docker $USER
newgrp docker
```

**4. No Seed Data**
```bash
# Restart with fresh database
docker compose down -v
docker compose up -d
```

### Where to Get Help
1. Check logs: `docker compose logs`
2. Read documentation: [README.md](README.md)
3. Ask senior developer
4. Check GitHub issues
5. Team Slack/Chat

---

## 📚 Learning Resources

### For .NET Developers
- [Microsoft .NET Documentation](https://docs.microsoft.com/dotnet)
- [Entity Framework Core](https://docs.microsoft.com/en-us/ef/core/)
- [ASP.NET Core](https://docs.microsoft.com/en-us/aspnet/core)

### For Frontend Developers
- [Flutter Documentation](https://flutter.dev)
- [Dart Language Guide](https://dart.dev/guides)

### For DevOps
- [Docker Documentation](https://docs.docker.com)
- [Docker Compose](https://docs.docker.com/compose/)
- [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

## ✅ Onboarding Checklist

By the end of Week 1, you should have:

- [ ] Repository cloned locally
- [ ] Docker installed and running
- [ ] Backend services started (`docker compose up -d`)
- [ ] Admin account login working
- [ ] Database access via PgAdmin verified
- [ ] Git configured with your name and email
- [ ] First feature branch created
- [ ] Able to read logs and troubleshoot basic issues
- [ ] Familiar with project structure
- [ ] Access to team communication channels

---

## 🎓 Week 1 Tasks

### Day 1-2: Setup
- [ ] Complete this onboarding guide
- [ ] Get all services running
- [ ] Explore the API documentation

### Day 3-4: Understanding
- [ ] Read backend README.md
- [ ] Explore database schema via PgAdmin
- [ ] Review seed data
- [ ] Check recent commits

### Day 5: First Contribution
- [ ] Create feature branch
- [ ] Make small change (e.g., documentation)
- [ ] Create pull request
- [ ] Get feedback from senior dev

---

## 🚦 Next Steps

1. **Complete Setup:** Follow SETUP_VERIFICATION.md
2. **Watch Demo:** Ask for project walkthrough
3. **Read Code:** Explore services/auth-service/AuthService
4. **Ask Questions:** Don't hesitate to ask the team
5. **Make First PR:** Start with a small documentation update

---

**Welcome aboard! 🎉**

If you need help, reach out to the team lead.

**Document Version:** 1.0  
**Last Updated:** 2026-02-16
