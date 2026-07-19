#!/bin/bash

# Ensure exactly 1 argument is provided to the script
if [ "$#" -ne 1 ]; then
    echo "Error: You must specify what java program to run with debug flags enabled!"
    echo "Usage: $0 <program_name_or_jar>"
    exit 1
fi

PROGRAM_NAME=$1

if [ ! -f "$PROGRAM_NAME" ]; then
    echo "Error: No jar/class file found, please build the program file first!"
    echo "Hint: you can use javaBuild to build a jar file of your project"
    exit 1
fi

FLAGS="-agentlib:jdwp=transport=dt_socket,server=y,suspend=n,address=5005"

# Dynamically check if the argument target is a pre-compiled .jar package
if [[ "$PROGRAM_NAME" == *.jar ]]; then
    echo "Starting JAR application in debug mode..."
    java $FLAGS -jar "$PROGRAM_NAME"
else
    echo "Starting standard Java class from classpath in debug mode..."
    java $FLAGS -cp ./bin "$PROGRAM_NAME"
fi
