#!/bin/bash

# Check if $RUN_DT is provided as an argument
if [ $# -ne 1 ]; then
    echo "Usage: $0 RUN_DT"
    exit 1
fi

# Assign the provided argument to RUN_DT
RUN_DT="$1"

# Define the base directory and target folder
BASE_DIR="/path/to/$MYENVVARIABLE/mave/"
TARGET_FOLDER="/MAVE/idqt_reports/"

# Find the latest folder for SCV with the provided RUN_DT
latest_scv=$(find "$BASE_DIR" -type d -name "out_2_*_${RUN_DT}*SCV" | sort -r | head -n 1)

# Find the latest folder for EXC with the provided RUN_DT
latest_exc=$(find "$BASE_DIR" -type d -name "out_2_*_${RUN_DT}*EXC" | sort -r | head -n 1)

# Function to check and move files
check_and_move() {
    local folder="$1"
    local file_pattern="$2"
    local label="$3"

    if [ -d "$folder" ]; then
        success_file="$folder/_SUCCESS"
        if [ -f "$success_file" ]; then
            csv_file=$(ls "$folder/$file_pattern" 2>/dev/null | head -n 1)
            if [ -n "$csv_file" ]; then
                filename=$(basename "$csv_file")
                new_filename="$TARGET_FOLDER/${label}_${filename%.*}_IDQT_DETAIL_REPORT_RUN_DT.csv"
                mv "$folder/$csv_file" "$new_filename"
                echo "Moved $csv_file to $new_filename"
            fi
        fi
    fi
}

# Check and move for SCV
check_and_move "$latest_scv" "part*.csv" "SCV"

# Check and move for EXC
check_and_move "$latest_exc" "part*.csv" "EXC"
