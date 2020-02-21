ARG ENVIROMENT_TAG=1.0-bionic

FROM developsy/enviroment:${ENVIROMENT_TAG}

LABEL maintainer="Roman Gonzalez <roman.gonzalez.ea@gmail.com>"

RUN set -ex; \
  sudo apt-get update && \
  sudo apt-get install --no-install-recommends -y \
    xterm \
    xvfb \
    x11vnc \
    menu \
    dbus \
    dbus-x11 \
    ffmpeg \
    openbox \
    xfonts-base \
    x11-utils \
    xbase-clients \
    libasound2 \
    libpulse0 && \
  sudo apt-get autoremove -y && \
  sudo apt-get clean && \
  sudo rm -rf /var/lib/apt/lists/*

# copy .Xresources
COPY --chown=$USER:$USER ./.Xresources $HOME

# config openbox
COPY --chown=$USER:$USER openbox $HOME/.config/openbox
RUN sudo chmod +x $HOME/.config/openbox/autostart

COPY --chown=$USER:$USER ./openbox/menu.xml $HOME/.config/openbox/

# set pass to connect vnc server
ARG VNC_PASS

RUN x11vnc -storepasswd ${VNC_PASS} $HOME/.passwordvnc && \
  sudo chmod 400 $HOME/.passwordvnc

#Set envirnmental variable for display
ENV DISPLAY :20

#Expose port 5920 to view display using VNC Viewer
EXPOSE 5920

COPY --chown=$USER:$USER ./vncserver.sh $HOME/bin
RUN sudo chmod +x $HOME/bin/vncserver.sh

CMD [ "vncserver.sh" ]
