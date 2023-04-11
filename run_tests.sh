#!/bin/bash
# Tests executable script
# author: Daniel Patek (xpatek08)
# VUT FIT 2023

# Prolog executable
PROLOG=flp22-log

# Test directory
TEST_DIR=tests

# Counters for passing and failing tests
PASS=0
FAIL=0

#colors
RED='\033[0;31m'
GREEN='\033[0;32m'
NC='\033[0m'

# Loop through all input files in the test directory
for INPUT_FILE in $TEST_DIR/*.in; do
    # Construct output file name from input file name
    OUTPUT_FILE=${INPUT_FILE%.in}.out
    
    # Run the Prolog program with the input file and redirect output to a temporary file
    TEMP_FILE=$(mktemp)
    $PROLOG < $INPUT_FILE > $TEMP_FILE
    
    # Compare the output file to the temporary file
    if diff $OUTPUT_FILE $TEMP_FILE >/dev/null 2>&1; then
        # Test passed
        echo -e "${GREEN} $INPUT_FILE: PASS ${NC}"
        ((PASS++))
    else
        # Test failed
        echo -e "$INPUT_FILE: ${RED}FAIL ${NC}"
        echo "Current result:"
        cat $TEMP_FILE
        echo ""
        echo "Intended result:"
        cat $OUTPUT_FILE
        echo ""
        ((FAIL++))
    fi
    
    # Clean up the temporary file
    rm $TEMP_FILE
done

# Print the results
echo "======================="
echo -e "${GREEN}Tests passed: $PASS"
echo -e "${RED}Tests failed: $FAIL"