ARG PMA_VERSION=5-fpm-alpine
FROM phpmyadmin/phpmyadmin:${PMA_VERSION}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

###########################################################################
# Set Timezone
###########################################################################

ARG TZ=UTC
ENV TZ ${TZ}

RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

###########################################################################
#
###########################################################################

# Add volume for sessions to allow session persistence
VOLUME /sessions

COPY ./build.sh /tmp/build.sh

RUN bash /tmp/build.sh && \
	rm /tmp/build.sh

# We expose phpMyAdmin on port 80
EXPOSE 80
