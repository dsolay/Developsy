ARG UBUNTU_RELEASE=21.10

FROM ubuntu:${UBUNTU_RELEASE}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ENV DEBIAN_FRONTEND noninteractive
ENV TERM screen-256color
ENV EDITOR nvim

# hadolint ignore=DL4006
RUN yes | unminimize && \
  rm -rf /var/lib/apt/lists/*

ENV LC_ALL en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US.UTF-8

RUN set -ex; \
  apt-get update && \
  apt-get install --no-install-recommends -y \
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
    universal-ctags \
    python3-pip \
    language-pack-en-base \
    git \
    shellcheck \
    zip \
    unzip \
    rar \
    unrar \
    man-db \
    stow \
    httpie \
    lynx \
    fzf \
    postgresql-client \
    mariadb-client && \
  apt-get autoremove -y && \
  apt-get clean  && \
  rm -rf /var/lib/apt/lists/*

ARG NVIM_VERSION
ARG BAT_VERSION
ARG LAZYGIT_VERSION

COPY ./requirements.txt /tmp/

RUN set -ex; \
  curl -fLo \
    /tmp/nvim.tar.gz \
    https://github.com/neovim/neovim/releases/download/v${NVIM_VERSION}/nvim-linux64.tar.gz && \
  tar xzf /tmp/nvim.tar.gz --directory /opt && \
  ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/ && \
  curl -fLo \
    /tmp/lazygit.tar.gz \
    https://github.com/jesseduffield/lazygit/releases/download/v$LAZYGIT_VERSION/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz && \
  tar xzf /tmp/lazygit.tar.gz --directory /tmp && \
  mv /tmp/lazygit /usr/local/bin/ && \
  curl -fLo \
    /tmp/bat.deb \
    https://github.com/sharkdp/bat/releases/download/v$BAT_VERSION/bat_${BAT_VERSION}_amd64.deb && \
  dpkg -i /tmp/bat.deb && \
  sh -c "$(curl -fsSL https://starship.rs/install.sh)" -- --yes && \
  pip3 install --no-cache-dir --requirement /tmp/requirements.txt && \
  rm -rf /tmp/*

ARG TMUX_VERSION
WORKDIR /usr/local/src
RUN set -ex; \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    libevent-2.1-7=2.1.12-stable-1 \
    libevent-dev=2.1.12-stable-1 \
    libncurses-dev=6.2+20201114-2build1 && \
  curl -fLO \
    https://github.com/tmux/tmux/releases/download/$TMUX_VERSION/tmux-$TMUX_VERSION.tar.gz && \
  tar xzf \
    /usr/local/src/tmux-$TMUX_VERSION.tar.gz \
    --strip-components 1 && \
  ./configure && \
  make && \
  make install && \
  apt-get autoremove -y && \
  apt-get clean  && \
  rm -rf \
    /var/lib/apt/lists/* \
    /usr/local/src/*

WORKDIR /

# Non root user
ARG NON_ROOT_USER=dev
ENV USER ${NON_ROOT_USER}

ARG PUID=1000
ARG PGID=1000
ENV PUID ${PUID}
ENV PGID ${PGID}

RUN set -ex; \
  groupadd -g ${PGID} ${USER} && \
  useradd -u ${PUID} -g ${USER} -m -l -s /bin/bash ${USER}

ENV HOME /home/${USER}

# installing dev tools
ARG NODE_VERSION
ARG GLOW_VERSION
ENV PATH $HOME/.anyenv/bin:$PATH

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -ex; \
  git clone https://github.com/anyenv/anyenv "$HOME"/.anyenv && \
  "$HOME"/.anyenv/bin/anyenv install --force-init && \
  anyenv install nodenv && \
  eval "$(anyenv init -)" && \
  git clone https://github.com/nodenv/node-build-update-defs.git \
    "$(nodenv root)"/plugins/node-build-update-defs && \
  nodenv install "$NODE_VERSION" && \
  nodenv global "$NODE_VERSION" && \
  npm install -g --quiet --no-progress \
    markdownlint-cli@0.29.0 \
    fixjson@1.1.2 \
    prettier@2.4.1 \
    prettier-plugin-sh@0.7.1 && \
  curl -sSfLo /tmp/dotenv-linter.sh https://git.io/JLbXn && \
  sh /tmp/dotenv-linter.sh && \
  curl -fLo \
    /tmp/glow.tar.gz \
    https://github.com/charmbracelet/glow/releases/download/v${GLOW_VERSION}/glow_${GLOW_VERSION}_linux_x86_64.tar.gz && \
    tar xzf /tmp/glow.tar.gz --directory /usr/local/bin glow && \
    rm -rf /tmp/glow.tar.gz /tmp/dotenv-linter.sh

ARG LSP_SERVERS="bashls diagnosticls jsonls yamlls vimls sumneko_lua"

COPY ./dotfiles/ "$HOME"/.dotfiles/
RUN set -ex; \
  rm -rf "$HOME"/.profile "$HOME/.bashrc" && \
  stow -S -d "$HOME"/.dotfiles -t $HOME nvim shell starship tmux && \
  eval "$(anyenv init -)" && \
  nvim --headless \
    -c "autocmd User PackerComplete sleep 100m | quitall" \
    -c PackerSync && \
  nvim --headless \
    -c "LspInstall --sync ${LSP_SERVERS}" \
    -c q

# final tocuh
SHELL ["/bin/sh", "-c"]
RUN set -ex; \
  mkdir -p "$HOME"/.vscode-server/extensions && \
  chown -R ${USER}:${USER} ${HOME}

ENV SHELL /bin/bash
USER ${USER}
WORKDIR $HOME

CMD ["/bin/bash", "-l"]
