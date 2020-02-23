FROM developsy/base-android:sdk

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

SHELL ["/bin/bash", "-c"]

ARG ANDROID_API_LEVEL=29
ARG ANDROID_BUILD_TOOLS_LEVEL=29.0.3
ARG EMULATOR_NAME=pixel_10.0
ARG ARCH=x86

ENV EMULATOR_NAME ${EMULATOR_NAME}

RUN set -ex; \
  yes Y | sudo sdkmanager --install \
    "system-images;android-${ANDROID_API_LEVEL};google_apis;${ARCH}" \
    "platforms;android-${ANDROID_API_LEVEL}" \
    "build-tools;${ANDROID_BUILD_TOOLS_LEVEL}" && \
  echo "no" | avdmanager --verbose create avd --force \
    --name "${EMULATOR_NAME}" \
    --device "pixel" \
    --package "system-images;android-${ANDROID_API_LEVEL};google_apis;${ARCH}" \
    --tag "google_apis" \
    --abi "${ARCH}"

COPY config.ini /tmp/config.ini
RUN cat /tmp/config.ini >> $HOME/.android/avd/$EMULATOR_NAME.avd/config.ini && \
  sudo rm -rf /tmp/config.ini

COPY --chown=$USER:$USER ./scripts $HOME/bin
RUN sudo chmod -R +x $HOME/bin/

CMD ["android-dev-startup.sh"]
