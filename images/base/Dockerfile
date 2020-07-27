ARG UBUNTU_RELEASE=focal

FROM ubuntu:${UBUNTU_RELEASE}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM screen-256color
ENV EDITOR nvim

ARG NON_ROOT_USER=dev
ENV USER ${NON_ROOT_USER}
ENV HOME /home/${USER}

ARG SUDO_VERSION=1.9.2
ARG TMUX_VERSION=3.1b

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN set -ex; \
  apt-get update \
  && apt-get upgrade -y \
  # reinstall stuff to include man pages...
  && rm /etc/dpkg/dpkg.cfg.d/excludes \
  && dpkg -l | grep ^ii | cut -d' ' -f3 | grep -v '^libgcc-s1:amd64$' | xargs apt-get install -y --reinstall \
  # Install essentials tools
  && apt-get install --no-install-recommends -y \
    tree \
    curl \
    wget \
    xclip \
    man-db \
    htop \
    dnsutils \
    net-tools \
    tcpflow \
    tcpdump \
    strace \
    bash-completion \
    openssh-client \
    cloc \
    less \
    jq \
    inetutils-ping \
    inetutils-traceroute iproute2 \
    netcat \
    zip \
    unzip \
    p7zip-full \
    unrar \
    build-essential \
    pkgconf \
    neovim \
    fzf \
    software-properties-common \
    shellcheck \
    exuberant-ctags \
    python3-pip \
    editorconfig \
    powerline \
    powerline-gitstatus \
    language-pack-en-base \
  # Install sudo
  && curl -fLo /tmp/sudo.deb https://www.sudo.ws/sudo/dist/packages/$SUDO_VERSION/sudo_$SUDO_VERSION-1_ubu2004_amd64.deb \
  && dpkg -i /tmp/sudo.deb \
  && rm -rf /tmp/sudo.deb \
  # Install tmux
  && apt-get install --no-install-recommends -y libevent-2.1-7 libevent-dev libncurses-dev \
  && curl -fLo /tmp/tmux-$TMUX_VERSION.tar.gz https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/tmux-$TMUX_VERSION.tar.gz \
  && tar xzf /tmp/tmux-$TMUX_VERSION.tar.gz --directory /tmp \
  && cd /tmp/tmux-$TMUX_VERSION \
  && ./configure \
  && make && make install \
  && cd / \
  && rm -rf /tmp/tmux-$TMUX_VERSION* \
  # Install lastest git
  && apt-add-repository ppa:git-core/ppa \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    git \
  # cache is useless to keep
  && apt-get purge -y software-properties-common libevent-dev libncurses-dev \
  && apt-get autoremove -y \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

# Non root user
ARG PUID=1000
ARG PGID=1000
ENV PUID ${PUID}
ENV PGID ${PGID}

RUN groupadd -g ${PGID} ${USER} && \
  useradd -u ${PUID} -g ${USER} -G sudo -m -s /bin/bash ${USER} \
  && echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers \
  # The sudo message is annoying, so skip it
  && touch $HOME/.sudo_as_admin_successful \
  && chown $USER:$USER $HOME/.sudo_as_admin_successful \
  # Other setup
  && echo 'export HISTTIMEFORMAT="%d/%m/%y %T "' >>~/.bashrc

# Install docker dind
ARG DOCKER_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/script-library/docker-debian.sh"
ARG DOCKER_SCRIPT_SHA="dev-mode"
ARG ENABLE_NONROOT_DOCKER="true"
ARG SOURCE_SOCKET=/var/run/docker-host.sock
ARG TARGET_SOCKET=/var/run/docker.sock

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

# Set the user to be our newly created user by default.
USER ${USER}

ENV XDG_CONFIG_HOME "$HOME/.config"
ENV PATH $PATH:$HOME/.local/bin

# vim config
COPY --chown=${USER}:${USER} nvim "$HOME/.config/nvim"

RUN set -ex; \
  # Fix .config dir permissions
  sudo chown -R $USER:$USER $HOME/.config \
  # Install tpm and tmuxp
  && git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm \
	&& pip3 install --user tmuxp \
  # Install vim plug
  && sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' \
  # Install all vim plugins.
  && nvim +PlugInstall +qall \
  # Create vscode devserver directory
  && mkdir -p $HOME/.vscode-server/extensions

# script for install CoC.nvim
COPY coc-install /usr/local/bin/coc-install

# Copy configurations
COPY --chown=${USER}:${USER} inputrc "$HOME/.inputrc"
COPY --chown=${USER}:${USER} powerline "$HOME/.config/powerline"
COPY --chown=${USER}:${USER} .bash "$HOME/.bash"
COPY --chown=${USER}:${USER} .bashrc "$HOME/.bashrc"
COPY --chown=${USER}:${USER} .tmux.conf "$HOME/.tmux.conf"

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to
# the Docker socket if "overrideCommand": false is set in devcontainer.json.
# The script will also execute CMD if you need to alter startup behaviors.
ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]
CMD ["/bin/bash"]
