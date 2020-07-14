ARG ENVIROMENT_TAG=1.0-bionic

FROM developsy/enviroment:${ENVIROMENT_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

# Add the composer.json
COPY ./composer.json "$HOME/.composer/composer.json"

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh
COPY ./alias-additions.sh /tmp/alias-additions.sh

ARG PHP_VERSION=7.4
ENV PHP_VERSION ${PHP_VERSION}

COPY ./build.sh /tmp/build.sh

RUN bash /tmp/build.sh && \
	sudo rm /tmp/build.sh

# Xdebug config
COPY ./xdebug.ini /etc/php/${PHP_VERSION}/mods-available/xdebug.ini

CMD ["/bin/bash"]
