#!/bin/bash

# File containing the mappings
mapping_file="mappings.txt"

# Read the file line by line and store mappings in an array
declare -a find_replace_pairs
while IFS= read -r line; do
  find_replace_pairs+=("$line")
done < "$mapping_file"

# Find all *.gradle files recursively from the current directory
find . -name "*.gradle" | while read -r file; do
  # Loop through the find/replace pairs
  for ((i=0; i<${#find_replace_pairs[@]}; i+=2)); do
    find_text="${find_replace_pairs[$i]}"
    replace_text="${find_replace_pairs[$i+1]}"
    
    # Use sed to perform find and replace on the file
    sed -i '' "s|$find_text|$replace_text|g" "$file"
  done
done

echo "Find and replace completed."

