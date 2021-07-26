ARG DEVELOPSY_BASE_TAG=ubuntu

FROM developsy/base:${DEVELOPSY_BASE_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ARG TAILWIND_INTELLISENSE_VERSION=0.6.8
ENV LSP_SERVERS $LSP_SERVERS;tailwindcss;tsserver;vuels
ENV PARSERS css;html;javascript;scss;tsx;typescript;vue

USER root
RUN set -ex; \
  eval "$(anyenv init -)" && \
  npm install --quiet --no-progress -g \
    vls@0.7.4 \
    typescript@4.3.5 \
    typescript-language-server@0.5.4 && \
  curl -Lo \
    /tmp/tailwindcss-intellisense.vsix \
    https://github.com/tailwindlabs/tailwindcss-intellisense/releases/download/v${TAILWIND_INTELLISENSE_VERSION}/vscode-tailwindcss-${TAILWIND_INTELLISENSE_VERSION}.vsix && \
  unzip /tmp/tailwindcss-intellisense.vsix -d /opt/tailwindcss-intellisense && \
  echo "#\!/usr/bin/env bash" > \
    /opt/tailwindcss-intellisense/tailwindcss-language-server && \
  echo "node /opt/tailwindcss-intellisense/extension/dist/server/tailwindServer.js \$*" \
    >> /opt/tailwindcss-intellisense/tailwindcss-language-server && \
  chmod a+x /opt/tailwindcss-intellisense/tailwindcss-language-server && \
  ln -sf /opt/tailwindcss-intellisense/tailwindcss-language-server \
    /usr/local/bin/tailwindcss-language-server && \
  rm -rf /tmp/tailwindcss-intellisense.vsix

COPY nvim/lua/servers/vue.lua "$HOME"/.config/nvim/lua/servers/vue.lua

# final tocuh
RUN chown -R "${USER}":"${USER}" "${HOME}"

VOLUME [ "$HOME/.npm", "$HOME/.cache/yarn" ]

USER dev
