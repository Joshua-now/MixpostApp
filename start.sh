#!/bin/bash
set -e

echo "[START] Publishing Mixpost migrations and assets..."
php artisan vendor:publish --provider="Inovector\\Mixpost\\MixpostServiceProvider" --tag="migrations" --force 2>/dev/null || true
php artisan vendor:publish --provider="Inovector\\MixpostAuth\\MixpostAuthServiceProvider" --tag="migrations" --force 2>/dev/null || true

echo "[START] Running database migrations..."
php artisan migrate --force

echo "[START] Linking storage..."
php artisan storage:link 2>/dev/null || true

echo "[START] Caching config..."
php artisan config:cache 2>/dev/null || true
php artisan route:cache 2>/dev/null || true

echo "[START] Starting FrankenPHP..."
exec /start-container.sh
