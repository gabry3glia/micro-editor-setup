# Java Utils Micro Plugin
This plugin makes it possible to have some Java related utilities for the Micro editor.

## Features
- Build project
- Run (with or without debug flags enabled)
- Hot swap (only with debug flags enabled)

The plugin requires java, openjdk, javac and jdb to be installed.
Run the `setup.sh` script to make sure you have all the requirements.

### Build Project
A project is defined by a folder with all the files needed and the `build.jp` file defining the project files, similar to a CMakeLists.txt:
```jp
TARGET: PROJECT_NAME.jar
MAIN_CLASS: com.example.Main
src/com/example/Main.java
src/com/example/OtherClasse.java
src/com/example/Utility.java
```
Once you have this file you can build the project using the `javaBuild` command in the micro command line.

This will generate the jar file ready for release.

### Run
The generated jar file can be easily runned with `javaRunRelease`.

### Hot Swap
To change the code while the program is running (hot swap) you need to first run the jar file with the debug flags enabled.
You can do so with the command `javaDebug`. Note that this will open the java console in the current tab of your micro instance.
To change the code just open a java source file of your program, edit it and save it.
This will automatically run the hot swap and the changes will show up in a couple seconds.
Note that hot swap only works with edits to methods bodies.
Class variables and function names cannot be updated.
Also remember that changes to the code that is directly inside the public static void main method will be ignored.

## About
Made by G3Dev
