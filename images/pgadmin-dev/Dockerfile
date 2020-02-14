ARG PGADMIN_VERSION=latest
FROM dpage/pgadmin4:${PGADMIN_VERSION}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

###########################################################################
# Set Timezone
###########################################################################

USER root

ARG TZ=UTC
ENV TZ ${TZ}

RUN apk add --no-cache tzdata && \
    ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

USER pgadmin
