#!/usr/bin/env bash

# If one command exits with an error, stop the script immediately.
set -eo pipefail

# Print every line executed to the terminal
set -x

echo '' >> /usr/local/etc/php/conf.d/php-phpmyadmin.ini \
echo '[PHP]' >> /usr/local/etc/php/conf.d/php-phpmyadmin.ini \
echo 'post_max_size = 2G' >> /usr/local/etc/php/conf.d/php-phpmyadmin.ini \
echo 'upload_max_filesize = 2G' >> /usr/local/etc/php/conf.d/php-phpmyadmin.ini