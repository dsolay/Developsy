ARG UBUNTU_RELEASE=bionic

FROM ubuntu:${UBUNTU_RELEASE}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

ARG UBUNTU_RELEASE

ENV UBUNTU_RELEASE ${UBUNTU_RELEASE}

ENV DEBIAN_FRONTEND noninteractive

###########################################################################
# Add a non-root user to prevent files being created with root permissions on host machine.
###########################################################################
ARG PUID=1000
ENV PUID ${PUID}
ARG PGID=1000
ENV PGID ${PGID}

ARG USERNAME=dev
ENV USERNAME ${USERNAME}

RUN set -xe; \
    apt-get update && \
    apt-get install sudo -y && \
    groupadd -g ${PGID} ${USERNAME} && \
    useradd -u ${PUID} -g ${USERNAME} -G sudo -m -s /bin/bash ${USERNAME} && \
    # Give passwordless sudo. This is only acceptable as it is a private
    # development environment not exposed to the outside world. Do NOT do this on
    # your host machine or otherwise.
    echo "${USERNAME} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers && \
    # The sudo message is annoying, so skip it
    touch /home/${USERNAME}/.sudo_as_admin_successful && \
    chown ${USERNAME}:${USERNAME} /home/${USERNAME}/.sudo_as_admin_successful && \
    apt-get autoremove -y && \
	apt-get clean && \
	rm -rf /var/lib/apt/lists/*

##########################################################################
# Locales
##########################################################################

# {{{ lang stuff

ENV LC_ALL=en_US.UTF-8
ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
RUN apt-get update && \
	apt-get install -y language-pack-en-base && \
	rm -rf /var/lib/apt/lists/*

# }}}

###########################################################################
# Set Timezone
###########################################################################

ARG TZ=UTC
ENV TZ ${TZ}

# Required for `clear` command to work, etc.
ENV TERM screen-256color

COPY ./build.sh /tmp/build.sh

RUN bash /tmp/build.sh && \
	rm /tmp/build.sh

# For some reason, this environment variable isn't set by docker.
ENV USER ${USERNAME}

ENV HOME /home/${USERNAME}

# This will determine where we will start when we enter the container.
WORKDIR /home/${USERNAME}

# Set the user to be our newly created user by default.
USER ${USERNAME}

COPY --chown=${USERNAME}:${USERNAME} ./inputrc "$HOME/.inputrc"

COPY --chown=${USERNAME}:${USERNAME} ./.bash "$HOME/.bash"

COPY --chown=${USERNAME}:${USERNAME} ./.bashrc "$HOME/.bashrc"

CMD ["/bin/bash"]