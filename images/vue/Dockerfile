ARG DEVELOPSY_BASE_TAG=ubuntu

FROM developsy/base:${DEVELOPSY_BASE_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ARG LSP_SERVERS="tailwindcss tsserver volar eslint emmet_ls"
ENV PARSERS css;scss;html;javascript;typescript;tsx;vue

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -ex; \
  eval "$(anyenv init -)" && \
  npm install --quiet --no-progress -g \
    vue@2.6.14 \
    typescript@4.4.4 && \
  nvim --headless \
    -c "LspInstall --sync ${LSP_SERVERS}" \
    -c q

# final tocuh
SHELL ["/bin/sh", "-c"]
RUN chown -R "${USER}":"${USER}" "${HOME}"

VOLUME [ "$HOME/.npm", "$HOME/.cache/yarn" ]

USER dev
