#!/usr/bin/env sh

# Determine the working directory
if [ -n "$ANDROID_HOME" ]; then
    WORKING_DIR="$ANDROID_HOME"
else
    WORKING_DIR="$( cd "$( dirname "$0" )" && pwd )"
fi

exec "$WORKING_DIR/gradle/wrapper/gradle-wrapper.jar" "$@"
