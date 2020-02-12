ARG ENVIROMENT_TAG=1.0-bionic

FROM developsy/enviroment:${ENVIROMENT_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

COPY ./build.sh /tmp/build.sh

COPY ./plugin.vim /tmp/plugin.vim

COPY ./post-pluggin.vim /tmp/post-plugin.vim

COPY ./repl /usr/local/bin/repl

ARG NVM_VERSION=v0.35.2
ENV NVM_VERSION ${NVM_VERSION}

ENV NPM_HOME $HOME/.npm-global
ENV NVM_DIR $HOME/.nvm

RUN /tmp/build.sh && sudo rm /tmp/build.sh

COPY --chown=$USER:$USER .nodejs-version $HOME/.nodejs-version
RUN . ${NVM_DIR}/nvm.sh && \
	nvm install "$(cat $HOME/.nodejs-version)" && \
	nvm alias default stable && \
    mkdir -p "$NPM_HOME/bin" "$HOME/.npm" && \
	yarn global add javascript-typescript-langserver && \
	yarn cache clean

VOLUME $HOME/.npm

VOLUME $HOME/.cache/yarn

CMD ["/bin/bash"]
