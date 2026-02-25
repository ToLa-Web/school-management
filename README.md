# School Management System

Full-stack school management platform — Flutter mobile app + .NET microservices backend.

---

## What it does

- Role-based login (Admin, Teacher, Student, Parent)
- User, student, course, and activity management
- JWT authentication with email verification and password reset
- Google & Facebook OAuth
- Mobile + Web (Flutter)

---

## Architecture

```
Flutter App  ──►  API Gateway :5001
                      │
              ┌───────┴────────┐
         Auth Service      School Service
              │                  │
          auth-db            school-db
              └───────┬────────┘
                    Consul
                (service registry)
```

| Container      | Local Port | Purpose                        |
|----------------|-----------|--------------------------------|
| api-gateway    | 5001      | Single entry point for the app |
| auth-service   | 5002      | Login, register, JWT, OAuth    |
| school-service | 5003      | School data & role checks      |
| auth-db        | 5433      | PostgreSQL for auth            |
| school-db      | 5434      | PostgreSQL for school data     |
| consul         | 8500      | Service discovery              |
| pgadmin        | 5050      | Database admin UI              |
| admin-web      | 3000      | Next.js admin panel            |

---

## Default accounts

All seed accounts use password: `Password123!`

| Role    | Emails                                          |
|---------|-------------------------------------------------|
| Admin   | admin@school.com                                |
| Teacher | teacher1@school.com, teacher2@school.com, teacher3@school.com |
| Student | student1@school.com … student45@school.com      |
| Parent  | parent1@school.com, parent2@school.com          |

Teacher classes:
- `teacher1` → Grade 10 (Class 10-A, 10-B, 10-C)
- `teacher2` → Grade 11 (Class 11-A, 11-B, 11-C)
- `teacher3` → Grade 12 (Class 12-A, 12-B, 12-C)

Each class has 15 students.

---

## Quick start

```bash
# 1. Backend
cd backend
docker compose up --build

# 2. Frontend (new terminal)
cd frontend
flutter pub get
flutter run
```

Full instructions → [SETUP.md](./SETUP.md)
All commands → [COMMANDS.md](./COMMANDS.md)

---

## Useful links (after backend starts)

- Swagger API docs: http://localhost:5001/swagger
- Consul dashboard: http://localhost:8500
- PgAdmin: http://localhost:5050 — `admin@school.com` / `admin123`
