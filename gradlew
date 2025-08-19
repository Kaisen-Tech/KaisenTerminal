#!/usr/bin/env sh
#
# Copyright 2017 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##############################################################################
##
##  Gradle start up script for UN*X
##
##############################################################################

# Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS.
# DEFAULT_JVM_OPTS=""

APP_NAME="Gradle"
APP_BASE_NAME=$(basename "$0")

# Use the trap to ensure we have a clean exit in the event of failure
trap "exit 1" INT

# OS specific support (must be 'true' or 'false').
cygwin=false
darwin=false
mingw=false
case "`uname`" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
  MINGW* )
    mingw=true
    ;;
esac

# For Cygwin, ensure paths are in UNIX format before anything else.
if $cygwin ; then
  [ -n "$GRADLE_HOME" ] && GRADLE_HOME=`cygpath --unix "$GRADLE_HOME"`
fi

# Determine the working directory
if [ -n "$GRADLE_HOME" ] ; then
    WORKING_DIR="$GRADLE_HOME"
elif [ -d "$(dirname "$0")" ] ; then
    WORKING_DIR="$( cd "$( dirname "$0" )" && pwd )"
else
    WORKING_DIR="$(pwd)"
fi

# The location of the wrapper properties file
if [ -f "$WORKING_DIR/gradle/wrapper/gradle-wrapper.properties" ] ; then
    GRADLE_WRAPPER_PROPERTIES="$WORKING_DIR/gradle/wrapper/gradle-wrapper.properties"
else
    # The wrapper is often used from a subdirectory, so search up the tree
    GRADLE_WRAPPER_PROPERTIES=$(
        (
        startDir=$(pwd)
        while [ ! -f "$GRADLE_WRAPPER_PROPERTIES" -a "$(pwd)" != "/" ] ; do
            GRADLE_WRAPPER_PROPERTIES="$(pwd)/gradle/wrapper/gradle-wrapper.properties"
            cd ..
        done
        if [ ! -f "$GRADLE_WRAPPER_PROPERTIES" ] ; then
            echo "Cannot find 'gradle/wrapper/gradle-wrapper.properties' in any parent directory." >&2
            exit 1
        fi
        echo "$GRADLE_WRAPPER_PROPERTIES"
        cd "$startDir"
        )
    )
fi
GRADLE_WRAPPER_PROPERTIES=$(echo "$GRADLE_WRAPPER_PROPERTIES" | sed -e 's/\\\\/\\//g')
if [ ! -f "$GRADLE_WRAPPER_PROPERTIES" ] ; then
    exit 1
fi

# Find the location of the wrapper JAR. It's in the same directory as the properties file.
GRADLE_WRAPPER_JAR="$(dirname "$GRADLE_WRAPPER_PROPERTIES")/gradle-wrapper.jar"
if [ ! -f "$GRADLE_WRAPPER_JAR" ] ; then
    echo "Cannot find wrapper JAR '$GRADLE_WRAPPER_JAR'." >&2
    echo "Did you run 'gradle wrapper'?" >&2
    exit 1
fi

# Find the location of the 'app' directory, which is the parent of the root project's 'build.gradle' file
APP_HOME="$( cd "$(dirname "$GRADLE_WRAPPER_PROPERTIES")" && cd .. && cd .. && pwd )"

# Set the classpath and the Java home
CLASSPATH=$CLASSPATH:"$GRADLE_WRAPPER_JAR"

# Add the wrapper JAR to the classpath
exec "$JAVA_HOME/bin/java" "-classpath" "$CLASSPATH" "org.gradle.wrapper.GradleWrapperMain" "$@"
