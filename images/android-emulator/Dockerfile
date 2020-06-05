FROM developsy/base-android:sdk

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

SHELL ["/bin/bash", "-c"]

ARG ANDROID_API_LEVEL=29
ARG ANDROID_BUILD_TOOLS_LEVEL=29.0.3
ARG ANDROID_IMAGE=google_apis
ARG EMULATOR_NAME=pixel_10.0
ARG ARCH=x86

ENV EMULATOR_NAME ${EMULATOR_NAME}

RUN set -ex; \
  yes Y | sudo sdkmanager --install \
    "system-images;android-${ANDROID_API_LEVEL};${ANDROID_IMAGE};${ARCH}" \
    "platforms;android-${ANDROID_API_LEVEL}" \
    "build-tools;${ANDROID_BUILD_TOOLS_LEVEL}"

RUN echo "no" | avdmanager --verbose create avd --force \
    --name "${EMULATOR_NAME}" \
    --device "pixel" \
    --package "system-images;android-${ANDROID_API_LEVEL};${ANDROID_IMAGE};${ARCH}" \
    --tag "${ANDROID_IMAGE}" \
    --abi "${ARCH}"

COPY config.ini $HOME/.android/avd/$EMULATOR_NAME.avd/config.ini
COPY --chown=$USER:$USER ./scripts $HOME/bin
RUN sudo chmod -R +x $HOME/bin/

CMD ["android-dev-startup.sh"]
