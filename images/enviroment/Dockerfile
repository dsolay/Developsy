ARG BASE_TAG=1.0-bionic

FROM developsy/base:${BASE_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ENV XDG_CONFIG_HOME "$HOME/.config"

COPY ./powerline "$HOME/.config/powerline"

COPY ./.tmux.conf "$HOME/.tmux.conf"

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

COPY ./nvim "$HOME/.config/nvim"
COPY ./ycm-install /usr/local/bin/ycm-install

COPY ./fzf "$HOME/.bash"

ARG TMUX_VERSION=3.0a
ENV TMUX_VERSION ${TMUX_VERSION}

COPY ./build.sh /tmp/build.sh

RUN bash /tmp/build.sh && \
	sudo rm /tmp/build.sh

###########################################################################
# Creating folder for volume extensions in dev container
###########################################################################

RUN mkdir -p /home/$USER/.vscode-server/extensions \
    && chown -R $USER \
        /home/$USER/.vscode-server

CMD ["/bin/bash"]