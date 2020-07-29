ARG DEVELOPSY_BASE_TAG=1.0-focal

FROM developsy/base:${DEVELOPSY_BASE_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ARG PHP_VERSION=7.4
ENV PHP_VERSION $PHP_VERSION

RUN set -ex; \
  sudo apt-get update \
  && sudo apt-get install --no-install-recommends -y \
    postgresql-client \
    mysql-client \
    sqlite3 \
    php${PHP_VERSION}-common \
    php${PHP_VERSION}-cli \
    php${PHP_VERSION}-gd \
    php${PHP_VERSION}-curl \
    php${PHP_VERSION}-intl \
    php${PHP_VERSION}-mbstring \
    php${PHP_VERSION}-bcmath \
    php${PHP_VERSION}-imap \
    php${PHP_VERSION}-xml \
    php${PHP_VERSION}-zip \
    php${PHP_VERSION}-mysql \
    php${PHP_VERSION}-pgsql \
    php${PHP_VERSION}-sqlite3 \
    php${PHP_VERSION}-xdebug \
    # Install composer and add its bin to the PATH.
    && curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer \
    # Cleanups
    && sudo apt-get autoremove -y \
    && sudo apt-get clean \
    && sudo rm -rf /var/lib/apt/lists/*

ENV NPM_CONFIG_PREFIX $HOME/.npm-global
ENV PATH $HOME/.npm-global/bin:$HOME/.composer/vendor/bin:$PATH

COPY composer.json $HOME/.composer/composer.json

RUN set -ex; \
  sudo chown -R $USER:$USER $HOME/.composer \
  && cd $HOME/.composer && composer install \
  # Setup nvim for PHP
	&& pip3 install --user pynvim \
  && coc-install --plugin --extensions "coc-snippets coc-yaml coc-docker coc-json coc-phpls coc-sh" \
  && mkdir -p $HOME/.npm-global \
  && npm install -g intelephense

COPY nvim /tmp/nvim
COPY alias-additions.sh /tmp/alias-additions.sh

RUN set -ex; \
	cat /tmp/nvim/plugin.vim >> $HOME/.config/nvim/plugin.vim \
	&& nvim +PlugInstall +qall \
	&& cat /tmp/nvim/post-plugin.vim >> $HOME/.config/nvim/post-plugin.vim \
	&& sudo rm -rf /tmp/nvim \
	&& cat /tmp/alias-additions.sh >> $HOME/.bash/aliases.sh \
	&& sudo rm -rf /tmp/alias-additions.sh

CMD ["/bin/bash"]
