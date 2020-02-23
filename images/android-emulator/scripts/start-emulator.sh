#!/usr/bin/env bash

function wait_emulator_to_be_ready() {
  adb devices | grep emulator | cut -f1 | while read line; do adb -s $line emu kill; done
  emulator "@$1" \
    -memory 2048 \
    -no-audio \
    -no-boot-anim \
    -netdelay none \
    -accel on \
    -gpu swiftshader_indirect \
    -no-snapshot \
    -wipe-data &

  boot_completed=false
  while [ "$boot_completed" == false ]; do
    status=$(adb wait-for-device shell getprop sys.boot_completed | tr -d '\r')
    echo "Boot Status: $status"

    if [ "$status" == "1" ]; then
      boot_completed=true
    else
      sleep 1
    fi
  done
}

function disable_animation() {
  adb shell "settings put global window_animation_scale 0.0"
  adb shell "settings put global transition_animation_scale 0.0"
  adb shell "settings put global animator_duration_scale 0.0"
}

function fix_100_cpu() {
  adb shell "su root pm disable com.google.android.googlequicksearchbox"
}

function use_skia() {
  adb shell "su root setprop debug.hwui.renderer skiagl"
  adb shell "su root stop"
  adb shell "su root start"
}

emulator=$1
if [ -z "$emulator" ];
then
  emulator=$EMULATOR_NAME
fi

wait_emulator_to_be_ready $emulator
sleep 1
disable_animation
fix_100_cpu
use_skia
