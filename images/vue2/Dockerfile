ARG DEVELOPSY_BASE_TAG=ubuntu

FROM developsy/base:${DEVELOPSY_BASE_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ENV LSP_SERVERS $LSP_SERVERS;tailwindcss;tsserver;vuels;eslint;emmet_ls
ENV PARSERS css;scss;html;javascript;typescript;tsx;vue

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -ex; \
  eval "$(anyenv init -)" && \
  npm install --quiet --no-progress -g \
    vue@2.6.14 \
    typescript@4.4.4 \
    yarn@1.22.17

VOLUME [ "$HOME/.npm", "$HOME/.cache/yarn" ]
