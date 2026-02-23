# Setup Guide

## Prerequisites

| Tool | Required for | Download |
|------|-------------|----------|
| Docker Desktop | Backend | https://www.docker.com/products/docker-desktop |
| Flutter SDK | Frontend | https://docs.flutter.dev/get-started/install |
| Git | Both | https://git-scm.com |

Minimum specs: 8 GB RAM, 20 GB free disk.

---

## 1. Clone the project

```bash
git clone https://github.com/ToLa-Web/school-management.git
cd school-management
```

---

## 2. Configure secrets

The `.env` file inside `backend/` holds two secrets Docker needs at startup.
It is already filled in for development — do not commit it to git.

```
backend/.env
├── JWT_SECRET=...          ← signs all JWT tokens
└── EMAILSETTINGS_APP_PASSWORD=...  ← Gmail app password for sending emails
```

If you are setting up from scratch:

```bash
cd backend
cp .env.example .env
# open .env and fill both values
```

---

## 3. Start the backend

```bash
cd backend
docker compose up --build
```

First run takes 3-5 minutes to pull images and build.
Wait until you see `Application started` in the logs for all services.

Verify everything is running:
```bash
docker compose ps
```

All containers should show status `running` or `healthy`.

---

## 4. Run the Flutter app

### Android emulator
```bash
cd frontend
flutter pub get
flutter run
```
The emulator uses `10.0.2.2` to reach your localhost — already handled in `api_config.dart`.

### Physical phone (most common)
Your phone and computer must be on the **same Wi-Fi network**.

1. Find your computer's local IP:
   - Windows: run `ipconfig`, look for `IPv4 Address` under Wi-Fi
   - Mac/Linux: run `ifconfig | grep inet`

2. Open `frontend/lib/services/api_config.dart` and update line 10:
   ```dart
   static const String baseUrl = 'http://YOUR_IP_HERE:5001';
   ```

3. Run the app:
   ```bash
   flutter run
   ```

---

## 5. Verify it works

- Swagger UI: http://localhost:5001/swagger
- Try logging in: `admin@school.com` / `Password123!`
- Consul dashboard: http://localhost:8500 (all 3 services should appear green)
- Admin web panel: http://localhost:3000 — log in with `admin@school.com` / `Password123!`

---

## Sharing with someone (teacher / teammate)

1. Run the zip script from the project root:
   ```powershell
   powershell -ExecutionPolicy Bypass -File make-zip.ps1
   ```
   This creates `school-management-for-teacher.zip` with all build artifacts excluded.

2. Send the zip. The recipient unzips it, then follows steps 2-5 above.
   The **only** line they need to change is `baseUrl` in `api_config.dart`.

---

## Troubleshooting

| Symptom | Fix |
|---------|-----|
| `docker compose up` errors immediately | Make sure Docker Desktop is open and running |
| Port 5001 already in use | `docker compose down` first, or change the port in `docker-compose.yml` |
| App says "Connection refused" on phone | Wrong IP in `api_config.dart`, or phone not on same Wi-Fi |
| App says 401 Unauthorized | Backend is fine — register a new account or use seed credentials |
| Emails not sending | Check `EMAILSETTINGS_APP_PASSWORD` in `.env` is a valid Gmail App Password |
| Want to wipe all data and start fresh | `docker compose down -v && docker compose up --build` |
