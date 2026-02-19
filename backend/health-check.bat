@echo off
REM Backend Health Check Script

echo.
echo Checking backend health...
echo.

REM Check if containers are running
echo [1] Checking containers...
docker ps --filter "name=auth_service" --filter "status=running" >nul 2>&1
if %errorlevel% neq 0 (
    echo [✗] auth_service is NOT running
) else (
    echo [✓] auth_service is running
)

docker ps --filter "name=auth_db" --filter "status=running" >nul 2>&1
if %errorlevel% neq 0 (
    echo [✗] auth_db is NOT running
) else (
    echo [✓] auth_db is running
)

REM Check API connectivity
echo.
echo [2] Checking API connectivity...
curl -s http://localhost:5001/swagger/index.html >nul 2>&1
if %errorlevel% neq 0 (
    echo [✗] API is NOT responding (check if port 5001 is available)
) else (
    echo [✓] API is responding
)

REM Check database connectivity
echo.
echo [3] Checking database connectivity...
docker exec auth_db psql -U auth_user -d auth_db -c "SELECT 1;" >nul 2>&1
if %errorlevel% neq 0 (
    echo [✗] Database is NOT responding
) else (
    echo [✓] Database is responding
)

REM Count users in database
echo.
echo [4] Checking seed data...
for /f "tokens=*" %%i in ('docker exec auth_db psql -U auth_user -d auth_db -t -c "SELECT count(*) FROM \"Users\";" 2^>nul') do set user_count=%%i

if "%user_count%"=="" (
    echo [✗] Could not retrieve user count
) else (
    echo [✓] Found %user_count% users in database
)

echo.
echo Health check complete!
echo.

pause
