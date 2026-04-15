#!/bin/bash
set -e

echo "[START] Running database migrations..."
php artisan migrate --force

echo "[START] Publishing Mixpost frontend assets..."
php artisan mixpost:publish-assets --force=true
php artisan vendor:publish --tag=mixpost-auth-assets --force
php artisan vendor:publish --tag=laravel-assets --ansi --force 2>/dev/null || true

echo "[START] Linking storage..."
php artisan storage:link 2>/dev/null || true

echo "[START] Caching config and routes..."
php artisan config:cache 2>/dev/null || true
php artisan route:cache 2>/dev/null || true

echo "[START] Starting FrankenPHP..."
exec /start-container.sh
