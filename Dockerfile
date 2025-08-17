FROM php:8.2-fpm

# Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

# 必要なPHP拡張
RUN apt-get update && \
    apt-get install -y unzip libzip-dev libonig-dev && \
    docker-php-ext-install pdo_mysql zip && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# PHP設定ファイルをコピー
COPY php.ini /usr/local/etc/php/conf.d/custom.ini

WORKDIR /var/www/html

# ソースコードコピー
COPY ./src /var/www/html

# 起動スクリプトをコピー
COPY docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# storage/cache の権限設定（開発用）
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Laravel key生成（初回ビルド用）
RUN composer install --no-interaction \
    && php artisan key:generate

# デフォルトコマンド
CMD ["/usr/local/bin/docker-entrypoint.sh"]
