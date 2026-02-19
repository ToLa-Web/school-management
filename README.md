# School Management System

A comprehensive school management platform with Flutter frontend and .NET backend microservices.

## Project Overview

This is a full-stack application for managing:
- **Authentication & Authorization** - Role-based access control
- **User Management** - Teachers, Students, Parents, Admins
- **Activity & Course Management** - Track activities and courses
- **Mobile & Web Support** - Flutter frontend for mobile and web

---

## Quick Start

### 1. Backend Setup

Navigate to the backend directory:

```bash
cd backend
cat .env.example > .env
# Edit .env with your email credentials
docker compose up -d
```

Backend is ready at http://localhost:5001

### 2. Frontend Setup

```bash
cd frontend
flutter pub get
flutter run
```

---

## Default Credentials

All seed users use password: `Password123!`

### Admin
- Email: `admin@school.com`

### Teachers
- Email: `teacher1@school.com`, `teacher2@school.com`

### Students
- Email: `student1@school.com`, `student2@school.com`

### Parents
- Email: `parent1@school.com`, `parent2@school.com`

---

## System Requirements

- **Docker Desktop** (for backend)
- **Flutter SDK** (for frontend)
- **Git** (for version control)

---

## Documentation

- **[Backend README](./backend/README.md)** - Setup, API docs, troubleshooting
- **API Documentation** - http://localhost:5001/swagger

---

## Quick Commands

```bash
# Start backend
cd backend && docker compose up -d

# Stop backend
cd backend && docker compose down

# View logs
docker compose logs -f

# Start frontend
cd frontend && flutter run

# Run tests
cd frontend && flutter test
```

---

## Important Notes

- ⚠️ Never commit `.env` file (contains secrets)
- ✅ Seed data auto-runs on first startup
- ✅ Database persists in Docker volume
- 🔒 All passwords are hashed

---

## Team Setup

1. Clone repository: `git clone <url>`
2. Copy backend/.env.example to backend/.env
3. Add email credentials to .env
4. Start backend: `docker compose up -d` (from backend folder)
5. Start frontend: `flutter run` (from frontend folder)

---

**Version:** 1.0  
**Last Updated:** 2026-02-16