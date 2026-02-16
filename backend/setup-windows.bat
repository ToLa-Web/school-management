@echo off
echo Starting School Management Backend...
echo.

if not exist ".env" (
    echo Creating .env file...
    copy .env.example .env
    echo [!] Edit .env file and add EMAILSETTINGS_APP_PASSWORD
    echo [!] Get password from: https://myaccount.google.com/apppasswords
    pause
)

echo.
echo Starting Docker services...
docker compose up -d

echo.
echo Waiting 15 seconds for services to start...
timeout /t 15 /nobreak

echo.
echo Done! Access at:
echo   API: http://localhost:5001/swagger
echo   Database: http://localhost:5050
echo   Credentials: admin@school.com / Password123!
echo.
pause
