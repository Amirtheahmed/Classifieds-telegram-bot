FROM ibrunotome/php:8.0-fpm

ARG COMPOSER_FLAGS

WORKDIR /var/www

COPY --chown=www-data:www-data . /var/www


RUN composer install $COMPOSER_FLAGS \
    && mv php.ini /usr/local/etc/php/php.ini \
    && mv www.conf /usr/local/etc/php-fpm.d/www.conf \
    && chown -R www-data:www-data /var/www \
    && find /var/www -type f -exec chmod 664 {} \; \
    && find /var/www -type d -exec chmod 775 {} \; \
    && chgrp -R www-data storage bootstrap/cache \
    && chmod -R ug+rwx storage bootstrap/cache

RUN usermod -u 1000 www-data

USER www-data

CMD ["/usr/local/sbin/php-fpm"]

EXPOSE 9000
