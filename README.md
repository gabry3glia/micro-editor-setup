# Micro setup
This is a micro setup I made primarely for my needs feel free to use it or edit it as you need.

## Plugins
This setup contains a couple plugins that make using micro easier, here is the full list:
- altfzf (1.0.0-G3Dev): implements fuzzy text and regex search across all files inside the current directory
- detectindent (1.1.1)
- filemanager (3.5.1-modified): a modified version of https://github.com/NicolaiSoeborg/filemanager-plugin that includes commands that also work outside of the tree tab
- fzfinder (0.1.0)
- javautils (1.0.0-G3Dev): java utilities (inclued project building, running and hot swap)
- manipulator (1.4.0)
- mlsp (0.2.0-modified): a modified version of https://github.com/Andriamanitra/mlsp that adapts the hints format to a more readble one
- resize (1.0.0)
- autoclose (built-in)
- comment (built-in)
- diff (built-in)
- ftoptions (built-in)
- linter (built-in)
- literate (built-in)
- status (built-in)

### Altfzf
Alternative Fuzzy Finder is enabled by 

### filemanager - modified
I added three commands you can always use to create an empty file, empty folder or to duplicate a file into another.
Here are the commands:
- `file <path/to/file/name>`: creates an empty file
- `dir <path/to/file/name>`: creates an empty directory
- `duplicate <path/to/source/name> <path/to/dest/name>`: duplicates the source file into the destination file
Note that all paths are relative to the current directory (which you can see using the default `pwd` micro command)

### JavaUtils
The plugin implements Java project building, Java program running and hot swap utilities.

#### Build
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

#### Run
The generated jar file can be easily runned with `javaRunRelease`.

#### Hot Swap
To change the code while the program is running (hot swap) you need to first run the jar file with the debug flags enabled.
You can do so with the command `javaDebug`. Note that this will open the java console in the current tab of your micro instance.
To change the code just open a java source file of your program, edit it and save it.
This will automatically run the hot swap and the changes will show up in a couple seconds.
Note that hot swap only works with edits to methods bodies.
Class variables and function names cannot be updated.
Also remember that changes to the code that is directly inside the public static void main method will be ignored.

### mlsp - modified
Two settings flags where added for changing the default hints format:
- `mlsp.only_names`: false by default, if true, it will only show the symbol names as hints (only for non Java languages)
- `mlsp.java_hints_format`: "detailed" by default, it can also be set to "simple" (only for the Java language)
	- "simple" format works as follows:
		- variables: "name [v]"
		- functions: "name [f]"
	- "detailed" format works as follows:
		visibility = p (public), r (private), c (protected), i (package)
		- variable: name [visibility-v: type]
		- static variable: name[visibility-vs: type]
		- final variable: name [visibility-vf: type]
		- static final variable: name [visibility-vsf: type]
		- function: name [visibility: (comma separated input types or "..." for undefined number of arguments) -> return type]
		Examples:
		- The variable `static final int TIME = 10` will be shown as "TIME [ivsf: int]"
		- The function `public void sayHello(int times)` will be shown as "sayHello [p: (int) -> void]"
		- The function `private int calculate(float percentage)` will be shown as "calculate [r: (float) -> int]"
To change these settings just set the flags in the `settings.json` file of your micro configuration:
```json
{
	"mlsp.only_names": true,
	"mlsp.java_hints_format": "simple"
}
```

## Requirements
The setup only works if the following programs are installed in your computer:
- open-jdk
- javac
- fzf
- ripgrep

You can verify the requirements with the following commands:
```bash
java --version
javac --version
jdb -version
fzf --version
rg --version
```
Then install the missing ones.

For mlsp to show language suggestions you need to have that specific language LSP installed on you machine.
You can find a list of language servers in the following file: [LSP list](LSPs.md).

Keep in mind this setup was only tested on Linux, thus it could break on other systems.

## About
Micro (https://micro-editor.github.io/) is a terminal-based text editor.
The listed plugins that show the "G3Dev" flag after the version number were made by me.
The listed plugins that show the "modified" flag after the version number are modified versions of existing plugins.
