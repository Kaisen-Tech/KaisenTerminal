#!/usr/bin/env sh
#
# Licensed to the Apache Software Foundation (ASF) under one or more
# contributor license agreements.  See the NOTICE file distributed with
# this work for additional information regarding copyright ownership.
# The ASF licenses this file to You under the Apache License, Version 2.0
# (the "License"); you may not use this file except in compliance with
# the License.  You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# This script is a wrapper for a Gradle project's `gradlew.bat` file.
# It makes the `gradlew.bat` file executable on Unix-like systems.

# Determine if this script is being executed on a Windows system
if [ -n "$COMSPEC" -a -x "$COMSPEC" ]; then
  exec "$0.bat" "$@"
fi

# Find the location of the wrapper properties file
if [ -f "gradle/wrapper/gradle-wrapper.properties" ]; then
    GRADLE_WRAPPER_PROPERTIES="gradle/wrapper/gradle-wrapper.properties"
else
    # The wrapper is often used from a subdirectory, so search up the tree
    GRADLE_WRAPPER_PROPERTIES=$(
        (
        startDir=$(pwd)
        while [ ! -f "gradle/wrapper/gradle-wrapper.properties" -a "$(pwd)" != "/" ]; do
            cd ..
        done
        if [ ! -f "gradle/wrapper/gradle-wrapper.properties" ]; then
            echo "Cannot find 'gradle/wrapper/gradle-wrapper.properties' in any parent directory." >&2
            exit 1
        fi
        pwd
        cd "$startDir"
        )
    )/gradle/wrapper/gradle-wrapper.properties
fi

# Determine the working directory
if [ -n "$JAVA_HOME" ]; then
    WORKING_DIR="$JAVA_HOME"
else
    WORKING_DIR="$( cd "$( dirname "$0" )" && pwd )"
fi

# Find the location of the wrapper JAR. It's in the same directory as the properties file.
GRADLE_WRAPPER_JAR="$(dirname "$GRADLE_WRAPPER_PROPERTIES")/gradle-wrapper.jar"
if [ ! -f "$GRADLE_WRAPPER_JAR" ]; then
    echo "Cannot find wrapper JAR '$GRADLE_WRAPPER_JAR'." >&2
    echo "Did you run 'gradle wrapper'?" >&2
    exit 1
fi

# Set the classpath and the Java home
CLASSPATH=$CLASSPATH:"$GRADLE_WRAPPER_JAR"

# Add the wrapper JAR to the classpath
exec "$JAVA_HOME/bin/java" "-classpath" "$CLASSPATH" "org.gradle.wrapper.GradleWrapperMain" "$@"
