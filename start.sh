#!/bin/bash
set -e

echo "[START] Running database migrations..."
php artisan migrate --force

echo "[START] Seeding default settings..."
php artisan db:seed --class=MixpostSeeder --force 2>/dev/null || true

echo "[START] Caching config..."
php artisan config:cache 2>/dev/null || true

echo "[START] Linking storage..."
php artisan storage:link 2>/dev/null || true

echo "[START] Starting FrankenPHP..."
exec /start-container.sh
