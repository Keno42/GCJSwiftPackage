#!/bin/sh

# Directory Names
BASE_INPUT_FOLDER=./Input
BASE_OUTPUT_FOLDER=./Output
BASE_SOURCE_DIRECTORY=./Sources
ANSWER_DIR=Answer

# Require Swift
if [ -z "$(command -v swift)"  ]; then
    echo "Error: swift is not installed. For instructions please see\n\nhttps://swift.org/getting-started/#installing-swift"
    exit 126
fi

swift build

CURRENT_INPUT_FILE=`ls -t $BASE_INPUT_FOLDER | head -1`

# Require an input file
if [ -z "$CURRENT_INPUT_FILE" ]; then
    echo "No Files Found in ./Inputs"
    exit 126
fi

# Pass as input to Swift
OUTPUT_STRING=`.build/debug/GCJSwiftPackage < $BASE_INPUT_FOLDER/$CURRENT_INPUT_FILE`

# Prepare the answer files
INPUT_FILE_NAME=${CURRENT_INPUT_FILE%.*}
OUTPUT_FILE_DIRECTORY=$BASE_OUTPUT_FOLDER/$INPUT_FILE_NAME
if [ -d $OUTPUT_FILE_DIRECTORY ]; then
    rm -r $OUTPUT_FILE_DIRECTORY
fi

mkdir $OUTPUT_FILE_DIRECTORY
mkdir $OUTPUT_FILE_DIRECTORY/$ANSWER_DIR
OUTPUT_FILE=$OUTPUT_FILE_DIRECTORY/$ANSWER_DIR/$INPUT_FILE_NAME.out
printf "$OUTPUT_STRING" > $OUTPUT_FILE

cp $BASE_SOURCE_DIRECTORY/* $OUTPUT_FILE_DIRECTORY/$ANSWER_DIR/
zip -r -D $OUTPUT_FILE_DIRECTORY/$ANSWER_DIR/$INPUT_FILE_NAME.zip $OUTPUT_FILE_DIRECTORY/$ANSWER_DIR

# Copy over the source and input to make it easier to re-run
cp -r $BASE_SOURCE_DIRECTORY $OUTPUT_FILE_DIRECTORY/
cp -r $BASE_INPUT_FOLDER $OUTPUT_FILE_DIRECTORY/
