ARG DEVELOPSY_BASE_TAG=ubuntu

FROM developsy/base:${DEVELOPSY_BASE_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

RUN set -ex; \
  mkdir -p $HOME/.cache \
  # intalling vue
  && npm install --quiet --no-progress -g @vue/cli \
  # installing CoC.nvim
  && coc-install --extensions \
    "coc-vetur coc-css coc-tsserver coc-tailwindcss coc-svg coc-emmet"

COPY nvim /tmp/nvim
COPY nvim/coc-settings.json $HOME/.config/nvim/coc-settings.json
COPY nvim/ftplugin $HOME/.config/nvim/ftplugin
COPY bashrc-additions.sh /tmp/bashrc-additions.sh

RUN set -ex; \
  # install vim plugins
  cat /tmp/nvim/plugin.vim >> $HOME/.config/nvim/plugin.vim \
  && cat /tmp/nvim/post-plugin.vim >> $HOME/.config/nvim/post-plugin.vim \
  && sudo rm -rf /tmp/nvim \
  && nvim +PlugInstall +qall \
  # add extra bashrc config
  && cat /tmp/bashrc-additions.sh >> $HOME/.bashrc \
  && sudo rm -rf /tmp/bashrc-additions.sh

VOLUME [ "$HOME/.npm", "$HOME/.cache/yarn" ]

CMD ["/bin/bash"]
