#!/bin/bash
set -e

echo "[START] Running database migrations..."
php artisan session:table 2>/dev/null || true
php artisan migrate --force

echo "[START] Creating admin user if not exists..."
php artisan tinker --execute="
\$pass = env('ADMIN_PASSWORD', 'Fluid2024');
App\\Models\\User::firstOrCreate(
    ['email' => 'jbbrown09@gmail.com'],
    ['name' => 'Joshua', 'password' => bcrypt(\$pass)]
);
echo 'Admin ready';
" 2>/dev/null || true

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
