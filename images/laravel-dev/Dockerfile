ARG ENVIROMENT_TAG=1.0-bionic

FROM developsy/enviroment:${ENVIROMENT_TAG}

# Add the composer.json
COPY ./composer.json "$HOME/.composer/composer.json"

COPY ./bashrc-additions.sh /tmp/bashrc-additions.sh

COPY ./build.sh /tmp/build.sh

RUN bash /tmp/build.sh && \
	sudo rm /tmp/build.sh

CMD ["/bin/bash"]