ARG DEVELOPSY_BASE_TAG=ubuntu

FROM developsy/base:${DEVELOPSY_BASE_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

USER root

RUN set -exu; \
  \
  apt-get update; \
  apt-get install -y --no-install-recommends \
		xz-utils=5.2.5-2 \
    postgresql-client=13+226 \
    mysql-client=8.0.25-0ubuntu3 \
    sqlite3=3.35.5-1 \
    libtidy5deb1=2:5.6.0-11 \
    libonig5=6.9.6-1.1 \
    libxslt1.1=1.1.34-4 \
    libzip4=1.7.3-1ubuntu1 \
    imagemagick=8:6.9.11.60+dfsg-1ubuntu1 \
    libtool=2.4.6-15 \
	; \
	rm -rf /var/lib/apt/lists/*

ARG PHP_VERSION=8.0.7

# hadolint ignore=DL4006,SC2086
RUN set -ex; \
  \
  savedAptMark="$(apt-mark showmanual)"; \
  apt-get update; \
  apt-get install --no-install-recommends -y \
    autoconf=2.69-14 \
    dpkg-dev=1.20.9ubuntu2 \
    file=1:5.39-3 \
    g++=4:10.3.0-1ubuntu3 \
    gcc=4:10.3.0-1ubuntu3 \
    libc6-dev=2.33-0ubuntu7 \
    make=4.3-4ubuntu1 \
    pkg-config=0.29.2-1ubuntu1 \
    re2c=2.0.3-1 \
    \
    libxml2-dev=2.9.10+dfsg-6.7 \
    libssl-dev=1.1.1j-1ubuntu4 \
    libsqlite3-dev=3.35.5-1 \
    zlib1g-dev=1:1.2.11.dfsg-2ubuntu6 \
    libbz2-dev=1.0.8-4ubuntu3 \
    libcurl4-gnutls-dev=7.74.0-1.2ubuntu3 \
    libpng-dev=1.6.37-3build3 \
    libjpeg-dev=8c-2ubuntu8 \
    libonig-dev=6.9.6-1.1 \
    libpq-dev=13.3-1build1 \
    libedit-dev=3.1-20191231-2 \
    libreadline-dev=8.1-2 \
    libtidy-dev=2:5.6.0-11 \
    libxslt1-dev=1.1.34-4 \
    libzip-dev=1.7.3-1ubuntu1 \
    libargon2-dev=0~20171227-0.2build21.04.0 \
    libmagickwand-dev=8:6.9.11.60+dfsg-1ubuntu1 \
  ; \
  anyenv install phpenv && \
  eval "$(anyenv init -)" && \
  PHP_BUILD_CONFIGURE_OPTS="\
    --enable-intl \
    --with-pdo-pgsql \
    --with-pgsql \
    --with-pear" \
    phpenv install "$PHP_VERSION" && \
  phpenv global "$PHP_VERSION" && \
  pecl channel-update pecl.php.net && \
  yes '' | pecl install imagick-3.5.0 && \
  chmod a+x "$(php-config --extension-dir)"/imagick.so && \
  echo "extension=imagick" > "$(php-config --ini-dir)"/imagick.ini && \
  apt-mark auto '.*' > /dev/null; \
	apt-mark manual $savedAptMark; \
	find /usr/local -type f -executable -exec ldd '{}' ';' \
		| awk '/=>/ { print $(NF-1) }' \
		| sort -u \
		| xargs -r dpkg-query --search \
		| cut -d: -f1 \
		| sort -u \
		| xargs -r apt-mark manual \
	; \
	apt-get purge \
    -y \
    --auto-remove \
    -o APT::AutoRemove::RecommendsImportant=false; \
  rm -rf \
    /var/lib/apt/lists/* \
    /tmp/php-* \
    /tmp/pear \
    ~/.pearrc \
    /tmp/phpenv.*

ARG INTELEPHENSE_LICENSE_KEY
ENV INTELEPHENSE_LICENSE_KEY=${INTELEPHENSE_LICENSE_KEY}
ENV LSP_SERVERS $LSP_SERVERS;intelephense
ENV PARSERS php

SHELL ["/bin/bash", "-c"]
RUN set -eux; \
  \
  eval "$(anyenv init -)" && \
  npm install --quiet --no-progress -g \
    intelephense@1.7.1 \
  ; \
  composer global require \
    friendsofphp/php-cs-fixer \
    phpstan/phpstan \
    laravel/installer

COPY nvim/lua/servers/intelephense.lua "$HOME"/.config/nvim/lua/servers/intelephense.lua
COPY nvim/after "$HOME"/.config/nvim/
COPY .bash/aliases.sh /tmp/alias-additions.sh

# final touch
RUN set -eux; \
  cat /tmp/alias-additions.sh >> "$HOME"/.bash/aliases.sh; \
  chown -R "${USER}":"${USER}" "${HOME}"; \
  rm -rf /tmp/alias-additions.sh

USER dev
