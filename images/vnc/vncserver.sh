#!/bin/bash
# entrypoint.sh file for starting the xvfb with better screen resolution, configuring and running the vnc server, pulling the code from git and then running the test.
unset SESSION_MANAGER
unset DBUS_SESSION_BUS_ADDRESS
Xvfb :20 -screen 0 1920x1080x24 &
x11vnc -rfbauth ~/.passwordvnc -display :20 -N -forever &
exec openbox-session
wait
