ARG DEVELOPSY_BASE_TAG=1.0-focal

FROM developsy/base:${DEVELOPSY_BASE_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ARG NVM_VERSION=V0.35.3
ARG NODE_VERSION=v14.13.1

ENV NVM_DIR $HOME/.nvm
ENV NPM_HOME $HOME/.npm-global
ENV PATH $PATH:${NVM_DIR}/versions/node/${NODE_VERSION}/bin:$NPM_HOME/bin:$HOME/.yarn/bin

RUN set -ex; \
  # installing yarn
  curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | sudo apt-key add - \
  && echo "deb https://dl.yarnpkg.com/debian/ stable main" | sudo tee /etc/apt/sources.list.d/yarn.list \
  && sudo apt update \
  && sudo apt-get install --no-install-recommends -y yarn \
  # intalling node version manager
  && mkdir -p $NVM_DIR \
  && curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  # intalling vue
  && npm install -g @vue/cli \
  # installing
  && pip3 install --user pynvim \
  && coc-install \
    --plugin \
    --extensions \
    "coc-snippets coc-yaml coc-docker coc-json coc-vetur coc-css coc-tsserver coc-sh coc-tailwindcss coc-svg coc-emmet" \
  # clean
  && sudo apt-get autoremove -y \
  && sudo apt-get clean \
  && sudo rm -rf /var/lib/apt/lists/*

COPY nvim /tmp/nvim
COPY nvim/coc-settings.json $HOME/.config/nvim/coc-settings.json
COPY bashrc-additions.sh /tmp/bashrc-additions.sh

RUN set -ex; \
  cat /tmp/nvim/plugin.vim >> $HOME/.config/nvim/plugin.vim \
  && cat /tmp/nvim/post-plugin.vim >> $HOME/.config/nvim/post-plugin.vim \
  && sudo rm -rf /tmp/nvim \
  && cat /tmp/bashrc-additions.sh >> $HOME/.bashrc \
  && sudo rm -rf /tmp/bashrc-additions.sh

VOLUME [ "$HOME/.npm", "$HOME/.cache/yarn" ]

CMD ["/bin/bash"]
