# Use the official PHP image with Apache
FROM php:8.2-apache

# Install the system dependencies and PHP extensions Chevereto requires
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libwebp-dev \
    libzip-dev \
    unzip \
    && docker-php-ext-configure gd --with-jpeg --with-webp \
    && docker-php-ext-install gd pdo pdo_mysql mysqli exif zip \
    && a2enmod rewrite

# Set the working directory
WORKDIR /var/www/html/

# Copy your fully populated repository (including the vendor/ folder) into the container
COPY . /var/www/html/

# Update permissions so the web server can read/write where necessary
RUN chown -R www-data:www-data /var/www/html/ \
    && chmod -R 755 /var/www/html/

# Expose port 80 for Render's internal routing
EXPOSE 80