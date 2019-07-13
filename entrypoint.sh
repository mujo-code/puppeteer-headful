#!/bin/sh

Xvfb :99 -screen 0 1024x768x24

export DISPLAY=:99.0
export PUPPETEER_EXEC_PATH="google-chrome-unstable"

for cmd in "$@"; do
    echo "Running '$cmd'..."
    if npm "$cmd"; then
        # no op
        echo "Successfully ran '$cmd'"
    else
        exit_code=$?
        echo "Failure running '$cmd', exited with $exit_code"
        exit $exit_code
    fi
done
