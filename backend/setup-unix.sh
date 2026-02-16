#!/bin/bash

echo "Starting School Management Backend..."
echo ""

if [ ! -f ".env" ]; then
    echo "Creating .env file..."
    cp .env.example .env
    echo "[!] Edit .env file and add EMAILSETTINGS_APP_PASSWORD"
    echo "[!] Get password from: https://myaccount.google.com/apppasswords"
    read -p "Press Enter when done..."
fi

echo ""
echo "Starting Docker services..."
docker compose up -d

echo ""
echo "Waiting 15 seconds for services to start..."
sleep 15

echo ""
echo "Done! Access at:"
echo "  API: http://localhost:5001/swagger"
echo "  Database: http://localhost:5050"
echo "  Credentials: admin@school.com / Password123!"
echo ""
