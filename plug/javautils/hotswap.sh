#!/bin/bash

PORT=5005
CLASS_NAME=$1
JAVA_FILE=$2

# Get the current working directory to prevent relative path issues within Micro
CURRENT_DIR=$(pwd)
BIN_DIR="$CURRENT_DIR/bin"

# Create the binary output directory if it does not exist
mkdir -p "$BIN_DIR"

# Give Micro a brief moment to finish writing any generated files to disk
sleep 0.1

# PRE-CHECK: Check if the debug session is running on port 5005
if ! ss -tuln | grep -q ":$PORT"; then
    # Wipe any .class file generated in the root right after Micro finished saving
    rm "$CURRENT_DIR"/*.class 2>/dev/null
    echo "NOT_RUNNING"
    exit 0
fi

# 1. Instantly compile ONLY the modified Java file, forcing all dependencies into -d
javac -cp "$BIN_DIR:." -sourcepath "." -d "$BIN_DIR" "$JAVA_FILE"

# 2. Change directory to bin so jdb resolves package structures properly
cd "$BIN_DIR" || exit

# 3. Inject the newly compiled class into the running JVM via jdb
# FIX: Use absolute path for the .class file so JDB can resolve it properly
ABS_CLASS_PATH="$BIN_DIR/${CLASS_NAME//./\/}.class"
echo "redefine $CLASS_NAME $ABS_CLASS_PATH" | jdb -attach $PORT > /dev/null

# Final sweep of the root folder to ensure zero pollution
# FIX: Use explicit CURRENT_DIR absolute path since pwd changed due to cd
rm "$CURRENT_DIR"/*.class 2>/dev/null

echo "Successfully completed hot swap for class \"$CLASS_NAME\"!"
exit 0
