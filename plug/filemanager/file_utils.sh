MODE=$1
SOURCE=$2
DESTINATION=$3

CURR_DIR=pwd

case "$MODE" in
	# file creation
    "-f")
        touch "$SOURCE"
        echo "Successfully created empty file at \"$SOURCE\""
        ;;
    # folder creation
    "-c")
        mkdir -p "$SOURCE"
        echo "Successfully created empty folder at \"$SOURCE\""
        ;;
    # file duplication
    "-d")
        cp "$SOURCE" "$DESTINATION"
        echo "Successfully duplicated file from \"$SOURCE\" to \"$DESTINATION\""
        ;;
    # non-existent mode
    *)
        echo "Invalid mode! Mode can only by -f (create empty file), -d (create empty folder) or -d (duplicate file to another file)"
        ;;
esac
