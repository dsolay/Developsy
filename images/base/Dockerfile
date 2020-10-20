ARG UBUNTU_RELEASE=focal

FROM ubuntu:${UBUNTU_RELEASE}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM screen-256color
ENV EDITOR nvim

ARG NON_ROOT_USER=dev
ENV USER ${NON_ROOT_USER}

ARG SUDO_VERSION=1.9.3
ARG TMUX_VERSION=3.1b

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN set -ex; \
  apt-get update \
  && apt-get upgrade -y \
  # Install essentials tools
  && apt-get install --no-install-recommends -y \
    curl \
    wget \
    bc \
    ripgrep \
    xclip \
    dnsutils \
    net-tools \
    tcpflow \
    tcpdump \
    strace \
    bash-completion \
    openssh-client \
    less \
    inetutils-ping \
    inetutils-traceroute \
    iproute2 \
    netcat \
    p7zip-full \
    build-essential \
    pkgconf \
    software-properties-common \
    universal-ctags \
    python3-pip \
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
  # Install lastest git and neovim
  && apt-add-repository ppa:git-core/ppa \
  && add-apt-repository ppa:neovim-ppa/stable \
  && apt-get update \
  && apt-get install --no-install-recommends -y \
    git \
    neovim \
  # install bat
  && curl -fsSL https://github.com/sharkdp/bat/releases/download/v0.16.0/bat_0.16.0_amd64.deb --output /tmp/bat.deb \
  && dpkg -i /tmp/bat.deb \
  && rm -rf /tmp/bat.deb \
  # intall neovim python plugin
  && pip3 install pynvim \
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
useradd -u ${PUID} -g ${USER} -m -s /bin/bash ${USER} \
&& echo "${USER} ALL=(ALL) NOPASSWD:ALL" >>/etc/sudoers

ENV HOME /home/${USER}

# Install docker dind
ARG INSTALL_DOCKER_DIND=false
ARG DOCKER_SCRIPT_SOURCE="https://raw.githubusercontent.com/microsoft/vscode-dev-containers/master/script-library/docker-debian.sh"
ARG DOCKER_SCRIPT_SHA="dev-mode"
ARG ENABLE_NONROOT_DOCKER="true"
ARG SOURCE_SOCKET=/var/run/docker-host.sock
ARG TARGET_SOCKET=/var/run/docker.sock

RUN set -ex; \
  if [ "$INSTALL_DOCKER_DIND" = "true" ]; then \
    apt-get update \
    # Use Docker script from script library to set things up
    && curl -sSL $DOCKER_SCRIPT_SOURCE -o /tmp/docker-setup.sh \
    && ([ "${DOCKER_SCRIPT_SHA}" = "dev-mode" ] || (echo "${DOCKER_SCRIPT_SHA} */tmp/docker-setup.sh" | sha256sum -c -)) \
    && /bin/bash /tmp/docker-setup.sh "${ENABLE_NONROOT_DOCKER}" "${SOURCE_SOCKET}" "${TARGET_SOCKET}" "${USER}" \
    && rm /tmp/docker-setup.sh \
    # Clean up
    && apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/* ; \
  fi

# Set the user to be our newly created user by default.
USER ${USER}

ARG NVM_VERSION=v0.36.0
ARG NODE_VERSION=v14.14.0

ENV NVM_DIR $HOME/.nvm
ENV NPM_HOME $HOME/.npm-global
ENV XDG_CONFIG_HOME $HOME/.config
ENV PATH $HOME/bin:$HOME/.local/bin:${NVM_DIR}/versions/node/${NODE_VERSION}/bin:NPM_HOME/bin:$PATH

# neovim config
COPY nvim $HOME/.config/nvim

# script for install CoC.nvim
COPY coc-install /usr/local/bin/coc-install

RUN set -ex; \
  # Crete bin directory in home
  mkdir $HOME/bin \
  # fix permissions of home directory
  && sudo chown -R $USER:$USER $HOME \
  # intsll tmux plugin manager
  && git clone https://github.com/tmux-plugins/tpm $HOME/.tmux/plugins/tpm \
  # intalling fzf
  && git clone --depth 1 https://github.com/junegunn/fzf.git $HOME/.local/share/fzf \
  && $HOME/.local/share/fzf/install --bin \
  && ln -sf $HOME/.local/share/fzf/bin/fzf $HOME/bin/fzf \
  # Install vim plug
  && sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim' \
  # intalling node version manager
  && mkdir -p $NVM_DIR \
  && curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/$NVM_VERSION/install.sh" | bash \
  && . $NVM_DIR/nvm.sh \
  && nvm install $NODE_VERSION \
  # Install nvim plugins
  && nvim +PlugInstall +qall \
  # installing CoC.nvim extensions
  && sudo chmod +x /usr/local/bin/coc-install \
  && coc-install --extensions \
    "coc-snippets coc-yaml coc-docker coc-json coc-sh coc-fzf-preview" \
  # install starship prompt
  && curl -fsSL https://starship.rs/install.sh --output /tmp/starship.sh \
  && sudo chmod +x /tmp/starship.sh \
  && sudo bash /tmp/starship.sh --yes \
  && rm -rf /tmp/starship.sh \
  # add support for vs code devcontainer
  && mkdir -p $HOME/.vscode-server/extensions \
  # add an alias for it that opens vim with the conflicted plugin activated
  && git config --global alias.conflicted '!nvim +Conflicted'

# Copy configurations
COPY --chown=${USER}:${USER} inputrc "$HOME/.inputrc"
COPY --chown=${USER}:${USER} .bash "$HOME/.bash"
COPY --chown=${USER}:${USER} .bashrc "$HOME/.bashrc"
COPY --chown=${USER}:${USER} .tmux.conf "$HOME/.tmux.conf"

WORKDIR $HOME

# Setting the ENTRYPOINT to docker-init.sh will configure non-root access to
# the Docker socket if "overrideCommand": false is set in devcontainer.json.
# The script will also execute CMD if you need to alter startup behaviors.
# ENTRYPOINT [ "/usr/local/share/docker-init.sh" ]

CMD ["/bin/bash"]
