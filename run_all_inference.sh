#!/bin/bash

# Define the root folder containing the dataset
ROOT_FOLDER="./dit/object_detection/fidelity_dataset/"

# Define the Python script and configuration files
PYTHON_SCRIPT="./dit/object_detection/inference.py"
CONFIG_FILE="./dit/object_detection/publaynet_configs/cascade/cascade_dit_base.yaml"
#CONFIG_FILE="./dit/object_detection/publaynet_configs/cascade/cascade_dit_doclaynet.yaml"
#MODEL_WEIGHTS="./dit/object_detection/saved_models/publaynet_dit-b_cascade.pth"
MODEL_WEIGHTS="./dit/object_detection/output/model_0017999.pth"

# Recursively find all .jpg files in the dataset folder and its subfolders
find "$ROOT_FOLDER" -type f -name "*.TIF" | while read -r IMAGE_FILE; do
  # Get the base filename without extension
  BASENAME=$(basename -- "$IMAGE_FILE")
  FILENAME="${BASENAME%.*}"

  # Determine the output path based on the input file's location
  OUTPUT_FOLDER="./output/$(dirname "${IMAGE_FILE#$ROOT_FOLDER}")"
  OUTPUT_FILE="$OUTPUT_FOLDER/${FILENAME}.jpg"

  # Create the output folder if it doesn't exist
  mkdir -p "$OUTPUT_FOLDER"

  # Run the Python script with the current image
  python "$PYTHON_SCRIPT" --image_path "$IMAGE_FILE" --output_file_name "$OUTPUT_FILE" --config "$CONFIG_FILE" --opts MODEL.WEIGHTS "$MODEL_WEIGHTS"

  # Print a message indicating the processing of the current image
  echo "Processed $IMAGE_FILE and saved result to $OUTPUT_FILE"
done
