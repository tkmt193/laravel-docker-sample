#!/bin/bash
set -e

echo "Starting Laravel application setup..."

# 権限設定
echo "Setting permissions..."
chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Composer install
echo "Installing Composer dependencies..."
composer install --no-interaction

# マイグレーション実行
echo "Running database migrations..."
php artisan migrate --force

# サーバー起動
echo "Starting Laravel development server..."
php artisan serve --host=0.0.0.0 --port=8000
