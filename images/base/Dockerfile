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

ARG NVIM_VERSION=0.5.1
ARG BAT_VERSION=0.18.2
ARG LAZYGIT_VERSION=0.29

RUN set -ex; \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    curl=7.74.0-1.3ubuntu2 \
    wget=1.21-1ubuntu3 \
    bc=1.07.1-2build3\
    ripgrep=12.1.1-1 \
    xclip=0.13-2 \
    dnsutils=1:9.16.15-1ubuntu1 \
    net-tools=1.60+git20181103.0eebece-1ubuntu2 \
    tcpflow=1.6.1-1 \
    tcpdump=4.99.0-2 \
    strace=5.13-0ubuntu1 \
    bash-completion=1:2.11-2ubuntu1 \
    openssh-client=1:8.4p1-6ubuntu2\
    less=551-2 \
    inetutils-ping=2:2.0-1 \
    inetutils-traceroute=2:2.0-1 \
    iproute2=5.10.0-4ubuntu1 \
    netcat=1.217-3ubuntu1 \
    p7zip-full=16.02+dfsg-8 \
    build-essential=12.9ubuntu2 \
    pkgconf=1.7.4~git20210206+dcf529b-3 \
    universal-ctags=5.9.20210829.0-1 \
    python3-pip=20.3.4-4 \
    language-pack-en-base=1:21.10+20211008\
    git=1:2.32.0-1ubuntu1\
    shellcheck=0.7.1-1build1.1 \
    zip=3.0-12build1\
    unzip=6.0-26ubuntu1 \
    rar=2:5.5.0-1build1 \
    unrar=1:6.0.5-1 \
    man-db=2.9.4-2 \
    stow=2.3.1-1 \
    httpie=2.4.0-1 \
    lynx=2.9.0dev.6-3 && \
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
  pip3 install --no-cache-dir \
    pynvim==0.4.3 \
    trash-cli==0.21.7.24 && \
  apt-get autoremove -y && \
  apt-get clean  && \
  rm -rf /var/lib/apt/lists/* /tmp/*

ARG TMUX_VERSION=3.2a
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
ARG NODE_VERSION=17.0.1
ARG GLOW_VERSION=1.4.1
ENV PATH $HOME/.anyenv/bin:$PATH

RUN set -ex; \
  git clone https://github.com/anyenv/anyenv "$HOME"/.anyenv && \
  "$HOME"/.anyenv/bin/anyenv install --force-init && \
  anyenv install nodenv && \
  eval "$(anyenv init -)" && \
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

RUN set -ex; \
  git clone \
    --depth 1 \
    -b developsy-base \
    --recurse-submodules \
    --remote-submodules \
    https://github.com/dsolay/dotfiles.git \
    "$HOME"/.dotfiles && \
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
COPY ./base-init.sh /usr/local/bin/
SHELL ["/bin/sh", "-c"]
RUN set -ex; \
  mkdir -p "$HOME"/.vscode-server/extensions && \
  chown -R ${USER}:${USER} ${HOME} && \
  chmod +x /usr/local/bin/base-init.sh

ENV SHELL /bin/bash
USER ${USER}
WORKDIR $HOME

ENTRYPOINT [ "base-init.sh" ]

CMD ["/bin/bash", "-l"]
