ARG BASE_TAG=1.0-bionic

FROM developsy/base:${BASE_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ENV XDG_CONFIG_HOME "$HOME/.config"

COPY ./powerline "$HOME/.config/powerline"

COPY ./.tmux.conf "$HOME/.tmux.conf"

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

COPY ./init.vim "$HOME/.config/nvim/init.vim"
COPY ./plugin.vim "$HOME/.config/nvim/plugin.vim"
COPY ./post-plugin.vim "$HOME/.config/nvim/post-plugin.vim"

COPY ./ycm-install /usr/local/bin/ycm-install

ENV TMUX_VERSION 3.0a

COPY ./build.sh /tmp/build.sh

RUN bash /tmp/build.sh && \
	sudo rm /tmp/build.sh

CMD ["/bin/bash"]