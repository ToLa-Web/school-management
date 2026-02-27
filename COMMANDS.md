# Commands Reference

All docker commands run from the `backend/` folder.

---

## Daily use

```bash
docker compose up -d          # start everything in background
docker compose down           # stop everything (data is kept)
docker compose logs -f        # watch live logs (Ctrl+C to exit)
docker compose ps             # check what is running
```

---

## After changing backend code

```bash
docker compose up -d --build  # rebuild changed services and restart
```

---

## Targeting a specific service

```bash
docker compose logs -f auth-service      # logs for one service only
docker compose restart school-service    # restart one service
docker compose up -d --build auth-service  # rebuild one service only
```

---

## Database

```bash
# Open PostgreSQL CLI for auth database
docker compose exec auth-db psql -U auth_user -d auth_db

# Open PostgreSQL CLI for school database
docker compose exec school-db psql -U school_user -d school_db

# Quick query example (list users)
docker compose exec auth-db psql -U auth_user -d auth_db -c 'SELECT id, email, "Role" FROM "Users";'
```

PgAdmin UI (easier): http://localhost:5050 — login: admin@school.com / admin123

---

## Wipe and reset everything

```bash
docker compose down -v        # stops containers AND deletes all database data
docker compose up --build     # fresh start, seed data runs again
```

---

## Test the API from terminal

```bash
# Login
curl -X POST http://localhost:5001/api/auth/authenticate \
  -H "Content-Type: application/json" \
  -d "{\"email\":\"admin@school.com\",\"password\":\"Password123!\"}"

# Validate a token (replace TOKEN with your actual token)
curl -X POST http://localhost:5001/api/auth/validate \
  -H "Content-Type: application/json" \
  -d "{\"token\":\"TOKEN\"}"
```

Or use Swagger UI: http://localhost:5001/swagger

---

## Flutter 

```bash
cd frontend
flutter pub get               # install/update packages
flutter run                   # run on connected device or emulator
flutter run -d chrome         # run in Chrome browser
flutter build apk             # build Android APK
```

---

## Useful ports

| URL | What it is |
|-----|------------|
| http://localhost:5001/swagger | API docs + interactive tester |
| http://localhost:8500 | Consul — shows all registered services |
| http://localhost:5050 | PgAdmin — database browser |
