#!/bin/bash
set -e

echo "[START] Running database migrations..."
php artisan migrate --force

echo "[START] Upserting admin user with env password..."
php artisan tinker --execute="
\$pass = env('ADMIN_PASSWORD', 'Fluid2024');
\$u = App\Models\User::updateOrCreate(
    ['email' => 'jbbrown09@gmail.com'],
    ['name' => 'Joshua', 'password' => bcrypt(\$pass)]
);
echo 'Admin ready (id=' . \$u->id . ')';
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
