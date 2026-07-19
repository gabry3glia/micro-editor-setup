#!/bin/bash

rm -rf bin/
find . -type f -name "*.class" -delete
find . -type f -name "*.jar" -delete
echo "Successfully removed all \"bin/\" \"*.class\" and \"*jar\" files"
exit 0
