ARG ANDROID_API_LEVEL=28

FROM developsy/android-emulator:api${ANDROID_API_LEVEL}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ARG FLUTTER_VERSION=v1.12.13+hotfix.8-stable

# install flutter
RUN set -ex; \
  curl -L -o /tmp/flutter.tar.xz https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}.tar.xz && \
  tar xf /tmp/flutter.tar.xz -C $HOME && \
  rm -rf /tmp/flutter.tar.xz

ENV PATH "$PATH:$HOME/flutter/bin"

# Disable analytics and crash reporting on the builder.
RUN flutter config  --no-analytics

# Perform an artifact precache so that no extra assets need to be downloaded on demand.
RUN flutter precache

CMD ["/bin/bash"]
