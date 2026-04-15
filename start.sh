#!/bin/bash
set -e

echo "[START] Running database migrations..."
php artisan migrate --force

echo "[START] Creating admin user if not exists..."
php artisan tinker --execute="if(!App\Models\User::where('email','jbbrown09@gmail.com')->exists()){App\Models\User::create(['name'=>'Joshua','email'=>'jbbrown09@gmail.com','password'=>bcrypt('FluidOS2024!')]);echo 'User created';} else {echo 'User exists';}" 2>/dev/null || true

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
