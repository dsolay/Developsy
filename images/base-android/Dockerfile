ARG JAVA_TAG=1.0-bionic
ARG VNC_TAG=1.0-bionic

FROM developsy/java-dev:${JAVA_TAG} as java

FROM developsy/vnc:${VNC_TAG} as vncserver

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ARG JDK_VERSION=8
ARG GRADLE_VERSION=6.2
ENV GRADLE_HOME /opt/gradle/gradle-${GRADLE_VERSION}

SHELL ["/bin/bash", "-c"]

# copy gradle
COPY --from=java $GRADLE_HOME $GRADLE_HOME
COPY --from=java /opt/gradlew /opt/gradlew

RUN set -ex; \
  sudo apt-get update && \
  sudo apt-get install --no-install-recommends -y \
    libglu1 \
    libpulse-dev \
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
    openjdk-${JDK_VERSION}-jdk \
    lib32ncurses5 \
    lib32stdc++6 && \
  sudo apt-get autoremove -y && \
  sudo apt-get clean && \
  sudo rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk${JDK_VERSION}-installer

ENV JAVA_HOME /usr/lib/jvm/java-${JDK_VERSION}-openjdk-amd64

ARG SKD=4333796

RUN set -ex; \
  curl -L -o /tmp/sdk-tools.zip https://dl.google.com/android/repository/sdk-tools-linux-${SKD}.zip && \
  sudo unzip -d /opt/android /tmp/sdk-tools.zip && \
  sudo chmod -R +x /opt/android/tools/bin && \
  rm -rf /tmp/sdk-tools.zip && \
  /opt/android/tools/bin/sdkmanager --update && \
  yes Y | /opt/android/tools/bin/sdkmanager --licenses && \
  yes Y | sudo /opt/android/tools/bin/sdkmanager --install \
    "platform-tools" \
    "emulator"

ENV ANDROID_HOME=/opt/android

ENV PATH "$PATH:$GRADLE_HOME/bin:/opt/gradlew:$ANDROID_HOME/emulator:$ANDROID_HOME/tools/bin:$ANDROID_HOME/platform-tools"
ENV LD_LIBRARY_PATH "$ANDROID_HOME/emulator/lib64:$ANDROID_HOME/emulator/lib64/qt/lib"

CMD ["/bin/bash"]
