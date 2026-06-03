# Use the official PHP image with Apache
FROM php:8.2-apache

# Install system dependencies, PHP extensions, and unzip/git for Composer
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libzip-dev \
    unzip \
    git \
    && docker-php-ext-configure gd --with-jpeg --with-webp \
    && docker-php-ext-install gd pdo pdo_mysql mysqli exif zip \
    && a2enmod rewrite

# Install Composer globally by copying it from the official Composer Docker image
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Set the working directory
WORKDIR /var/www/html/

# Copy your repository's code into the container
COPY . /var/www/html/

# Run Composer to install Chevereto's dependencies (This creates the vendor/ folder!)
# We use --no-dev to exclude testing tools, making the app lighter
RUN composer install --no-dev --optimize-autoloader

# Update permissions so the web server can read/write where necessary
RUN chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/

# Expose port 80 for Render's internal routing
EXPOSE 80
