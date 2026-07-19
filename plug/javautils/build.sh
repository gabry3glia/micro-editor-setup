#!/bin/bash

if [ ! -f "build.jp" ]; then
    echo "BUILD_STATUS:ERROR - build.jp file not found in the current directory!"
    exit 1
fi

BUILD_FILE="build.jp"

# 1. Robust Parsing of build.jp (Removes Windows carriage returns \r and handles spaces dynamically)
JAR_NAME=$(grep -i "^TARGET:" $BUILD_FILE | sed 's/[[:space:]]*//g' | cut -d':' -f2 | tr -d '\r')
MAIN_CLASS=$(grep -i "^MAIN_CLASS:" $BUILD_FILE | sed 's/[[:space:]]*//g' | cut -d':' -f2 | tr -d '\r')

# Extract source files, ignoring TARGET, MAIN_CLASS, empty lines, and cleaning \r
JAVA_FILES=$(grep -v -i "^TARGET:" $BUILD_FILE | grep -v -i "^MAIN_CLASS:" | grep -v "^$" | tr -d '\r')

if [ -z "$JAR_NAME" ] || [ -z "$MAIN_CLASS" ] || [ -z "$JAVA_FILES" ]; then
    echo "BUILD_STATUS:ERROR - Invalid build.jp format. Missing TARGET, MAIN_CLASS, or source files."
    exit 1
fi

TEMP_BIN="build_output"
mkdir -p "$TEMP_BIN"

# 2. Compilation of all listed Java files (Adding -cp bin to resolve existing dependencies if needed)
if ! javac -cp "./bin:." -sourcepath "." -d "$TEMP_BIN" $JAVA_FILES; then
    echo "BUILD_STATUS:ERROR - Compilation failed!"
    rm -rf "$TEMP_BIN"
    exit 1
fi

# 3. Create a clean Manifest file
echo "Manifest-Version: 1.0" > manifest.tmp
echo "Main-Class: $MAIN_CLASS" >> manifest.tmp
echo "" >> manifest.tmp

# 4. Generate the JAR package
if ! jar cfm "$JAR_NAME" manifest.tmp -C "$TEMP_BIN" .; then
    echo "BUILD_STATUS:ERROR - Failed to create JAR file!"
    rm -rf "$TEMP_BIN" manifest.tmp
    exit 1
fi

# 5. Cleanup temporary items
rm -rf "$TEMP_BIN" manifest.tmp

echo "BUILD_STATUS:SUCCESS - Generated $JAR_NAME successfully!"
exit 0
