FROM php:8.2-alpine

RUN apk update && apk add --no-cache \
    curl \
    libpng-dev \
    oniguruma-dev \
    libxml2-dev \
    libxrender-dev \
    libxext-dev \
    zip \
    unzip \
    nginx \
    jpeg-dev \
    libzip-dev \
    mysql-client


# Copy nginx.conf from devops/ into container
# RUN rm -rf /etc/nginx/sites-enabled/default
# COPY ./devops/nginx.conf /etc/nginx/sites-enabled/nginx.conf

RUN docker-php-ext-configure gd --with-jpeg && \
    docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip opcache

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

WORKDIR /var/www/html

COPY composer.json composer.lock ./
RUN composer install --no-scripts --no-autoloader

COPY . .

RUN composer dump-autoload --optimize && \
    mkdir -p /usr/local/etc/php-fpm.d && \
    echo '[www]\nuser = www-data\ngroup = www-data\nlisten = 9000\npm = dynamic\npm.max_children = 5\npm.start_servers = 2\npm.min_spare_servers = 1\npm.max_spare_servers = 3' > /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/pm.start_servers = 2/pm.start_servers = 5/g' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/pm.min_spare_servers = 1/pm.min_spare_servers = 3/g' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/pm.max_spare_servers = 3/pm.max_spare_servers = 10/g' /usr/local/etc/php-fpm.d/www.conf && \
    sed -i 's/pm.max_children = 5/pm.max_children = 100/g' /usr/local/etc/php-fpm.d/www.conf && \
    echo 'request_terminate_timeout = 600s' >> /usr/local/etc/php-fpm.d/www.conf && \
    chown -R www-data:www-data /var/www/html/ && \
    chmod 777 storage && \
    chmod +x /var/www/html/entrypoint.sh

EXPOSE 5000
ENTRYPOINT ["/var/www/html/entrypoint.sh"]

