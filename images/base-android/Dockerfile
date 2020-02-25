ARG VNC_TAG=1.0-bionic

FROM developsy/vnc:${VNC_TAG} as vncserver

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ARG JDK_VERSION=8

SHELL ["/bin/bash", "-c"]

RUN set -ex; \
  sudo apt-get update && \
  sudo apt-get install --no-install-recommends -y \
    libglu1-mesa \
    libc6  \
    libstdc++6 \
    libx11-6 \
    libx11-xcb1 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxi6 \
    libxtst6 \
    libnss3 \
    qemu-kvm \
    libvirt-bin \
    bridge-utils \
    kmod \
    openjdk-${JDK_VERSION}-jdk-headless \
    lib32ncurses5 \
    lib32stdc++6 && \
  sudo apt-get autoremove -y && \
  sudo apt-get clean && \
  sudo rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk${JDK_VERSION}-installer

ENV JAVA_HOME /usr/lib/jvm/java-${JDK_VERSION}-openjdk-amd64

# Install Gradle

ARG GRADLE_VERSION=6.2

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

# install android sdk tools
ARG SKD=4333796

RUN set -ex; \
  curl -L -o /tmp/sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-${SKD}.zip && \
  sudo unzip -d /opt/android /tmp/sdk-tools.zip && \
  sudo chmod -R +x /opt/android/tools/bin && \
  rm -rf /tmp/sdk-tools.zip && \
  /opt/android/tools/bin/sdkmanager --update && \
  touch $HOME/.android/repositories.cfg && \
  yes Y | sudo /opt/android/tools/bin/sdkmanager --licenses && \
  yes Y | sudo /opt/android/tools/bin/sdkmanager --install \
    "platform-tools" \
    "emulator"

ENV ANDROID_HOME=/opt/android

ENV PATH "$PATH:$GRADLE_HOME/bin:/opt/gradlew:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
ENV LD_LIBRARY_PATH "$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib"

CMD ["/bin/bash"]
