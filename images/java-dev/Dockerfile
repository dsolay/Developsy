ARG ENVIROMENT_TAG=1.0-bionic

FROM developsy/enviroment:${ENVIROMENT_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ENV JDTLS_HOME /usr/local/share/jdtls
ARG JDK_VERSION=8

RUN set -ex; \
  sudo apt-get update && \
  sudo apt-get install --no-install-recommends -y openjdk-${JDK_VERSION}-jdk && \
  sudo apt-get autoremove -y && \
  sudo apt-get clean && \
  sudo rm -rf /var/lib/apt/lists/*

ENV JAVA_HOME /usr/lib/jvm/java-${JDK_VERSION}-openjdk-amd64

# Install Maven

ARG MAVEN_VERSION=3.6.3
ENV MAVEN_VERSION ${MAVEN_VERSION}

RUN set -ex; \
  curl -L -o /tmp/maven.zip https://downloads.apache.org/maven/maven-3/${MAVEN_VERSION}/binaries/apache-maven-${MAVEN_VERSION}-bin.zip && \
  sudo mkdir -p /opt/maven && \
  sudo unzip -d /opt/maven/ /tmp/maven.zip && \
  rm -rf /tmp/maven.zip

# Install Gradle

ARG GRADLE_VERSION=6.2
ENV GRADLE_VERSION ${GRADLE_VERSION}

RUN set -ex; \
  curl -L -o /tmp/gradle.zip https://services.gradle.org/distributions/gradle-${GRADLE_VERSION}-bin.zip && \
  sudo mkdir -p /opt/gradle && \
  sudo unzip -d /opt/gradle/ /tmp/gradle.zip && \
  rm -rf /tmp/gradle.zip

ENV GRADLE_HOME /opt/gradle/gradle-${GRADLE_VERSION}

# Gradle wrapper
RUN set -ex; \
  sudo mkdir -p /opt/gradlew && \
  sudo $GRADLE_HOME/bin/gradle wrapper --gradle-version $GRADLE_VERSION --distribution-type all -p /opt/gradlew

COPY ./build.sh /tmp/build.sh

COPY ./jdtls /usr/local/bin/jdtls

COPY ./post-plugin.vim /tmp/post-plugin.vim
COPY ./plugin.vim /tmp/plugin.vim

RUN /tmp/build.sh && sudo rm /tmp/build.sh

ENV PATH $PATH:$GRADLE_HOME/bin:/opt/gradlew:/opt/maven/apache-maven-$MAVEN_VERSION/bin

CMD ["/bin/bash"]
