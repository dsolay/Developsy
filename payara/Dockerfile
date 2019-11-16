FROM payara/server-full

# MariaDB Connector/J version (2.4.0)
ARG MARIADB_CONNECTOR_VERSION=2.4.0
ARG MARIADB_CONNECTOR_NAME=mariadb-java-client-${MARIADB_CONNECTOR_VERSION}
# http://downloads.mariadb.com/Connectors/java/connector-java-2.4.0/mariadb-java-client-2.4.0.jar
ARG MARIADB_CONNECTOR_URL=http://downloads.mariadb.com/Connectors/java/connector-java-${MARIADB_CONNECTOR_VERSION}/${MARIADB_CONNECTOR_NAME}.jar
ARG MARIADB_CONNECTOR_SHA1=87f88656d9cf5381fc3c11c8e52d42f9eb23247c

# MySQL Connector/J version (2.4.0)
ARG MYSQL_CONNECTOR_VERSION=8.0.16
ARG MYSQL_CONNECTOR_NAME=mysql-connector-java-${MYSQL_CONNECTOR_VERSION}
ARG MYSQL_CONNECTOR_URL=http://dev.mysql.com/get/Downloads/Connector-J/${MYSQL_CONNECTOR_NAME}.tar.gz
ARG MYSQL_CONNECTOR_MD5=3cd3a2cfa510b48fc54fadfc1db5db61


ENV PAYARA_LIBS_DIR=${PAYARA_DIR}/glassfish/domains/${DOMAIN_NAME}/lib

RUN wget --no-verbose -O /tmp/${MARIADB_CONNECTOR_NAME}.jar ${MARIADB_CONNECTOR_URL} && \
    echo "${MARIADB_CONNECTOR_SHA1} /tmp/${MARIADB_CONNECTOR_NAME}.jar" | sha1sum -c - && \
    # mysql driver
    wget --no-verbose -O /tmp/${MYSQL_CONNECTOR_NAME}.tar.gz ${MYSQL_CONNECTOR_URL} && \
    echo "${MYSQL_CONNECTOR_MD5} /tmp/${MYSQL_CONNECTOR_NAME}.tar.gz" | md5sum -c - && \
    tar -C /tmp -xzvf /tmp/${MYSQL_CONNECTOR_NAME}.tar.gz && \
    mv /tmp/${MARIADB_CONNECTOR_NAME}.jar /tmp/${MYSQL_CONNECTOR_NAME}/${MYSQL_CONNECTOR_NAME}.jar ${PAYARA_LIBS_DIR} && \
    rm -rf /tmp/${MARIADB_CONNECTOR_NAME}.jar /tmp/${MYSQL_CONNECTOR_NAME}.tar.gz /tmp/${MYSQL_CONNECTOR_NAME}