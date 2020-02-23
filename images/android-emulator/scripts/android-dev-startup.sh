#!/usr/bin/env bash
set -eou pipefail

socat tcp-listen:5037,bind=$(hostname),fork tcp:127.0.0.1:5037 &
socat tcp-listen:5554,bind=$(hostname),fork tcp:127.0.0.1:5554 &
socat tcp-listen:5555,bind=$(hostname),fork tcp:127.0.0.1:5555 &

sleep infinity
