ARG DEVELOPSY_BASE_TAG=ubuntu

FROM developsy/base:${DEVELOPSY_BASE_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ENV LSP_SERVERS $LSP_SERVERS;tailwindcss;tsserver;vuels;eslint;emmet_ls
ENV PARSERS css;scss;html;javascript;typescript;tsx;vue

USER root
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -ex; \
  eval "$(anyenv init -)" && \
  npm install --quiet --no-progress -g \
    vue@2.6.14 \
    typescript@4.4.4

COPY nvim/lua/servers/vue.lua "$HOME"/.config/nvim/lua/servers/vue.lua
COPY nvim/lua/servers/eslint.lua "$HOME"/.config/nvim/lua/servers/eslint.lua
COPY nvim/lua/servers/jsonls.lua "$HOME"/.config/nvim/lua/servers/jsonls.lua

# final tocuh
SHELL ["/bin/sh", "-c"]
RUN chown -R "${USER}":"${USER}" "${HOME}"

VOLUME [ "$HOME/.npm", "$HOME/.cache/yarn" ]

USER dev
