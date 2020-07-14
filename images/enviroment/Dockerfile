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
# Install docker dind
###########################################################################

# Docker script args, location, and expected SHA - SHA generated on release
ARG DOCKER_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/script-library/docker-debian.sh"
ARG DOCKER_SCRIPT_SHA="dev-mode"
ARG ENABLE_NONROOT_DOCKER="true"
ARG SOURCE_SOCKET=/var/run/docker-host.sock
ARG TARGET_SOCKET=/var/run/docker.sock

USER root

RUN apt-get update \
  # Use Docker script from script library to set things up
  && curl -sSL $DOCKER_SCRIPT_SOURCE -o /tmp/docker-setup.sh \
  && ([ "${DOCKER_SCRIPT_SHA}" = "dev-mode" ] || (echo "${DOCKER_SCRIPT_SHA} */tmp/docker-setup.sh" | sha256sum -c -)) \
  && /bin/bash /tmp/docker-setup.sh "${ENABLE_NONROOT_DOCKER}" "${SOURCE_SOCKET}" "${TARGET_SOCKET}" "${USER}" \
  && rm /tmp/docker-setup.sh \
  #
  # Clean up
  && apt-get autoremove -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/*

USER ${USER}

###########################################################################
# Creating folder for volume extensions in dev container
###########################################################################

RUN mkdir -p /home/$USER/.vscode-server/extensions \
    && chown -R $USER \
        /home/$USER/.vscode-server

###########################################################################
# Creating folder for user bin
###########################################################################

RUN mkdir -p $HOME/bin
ENV PATH $PATH:$HOME/bin

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to
# the Docker socket if "overrideCommand": false is set in devcontainer.json.
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD ["/bin/bash"]
