#!/bin/bash

# Function to insert namespace into the build.gradle file
insert_namespace() {
    manifest_file="$1"
    gradle_file="$2"

    # Extract the namespace (package attribute value) from the AndroidManifest.xml file
    namespace=$(grep 'package=' "$manifest_file" | sed 's/.*package="//;s/".*//')

    # Check if the namespace is found
    if [[ -n "$namespace" ]]; then
        echo "Adding namespace \"$namespace\" to $gradle_file"

        # Check if the build.gradle already contains a namespace declaration
        if grep -q "namespace " "$gradle_file"; then
            echo "Namespace already exists in $gradle_file, skipping."
        else
            # Insert the namespace into the android block
            sed -i '' '/android {/a\
    namespace "'"$namespace"'"\
' "$gradle_file"
            echo "Namespace \"$namespace\" added to $gradle_file."
        fi
    else
        echo "No package found in $manifest_file, skipping."
    fi
}

# Recursively search for AndroidManifest.xml files in src/main directories
find . -path "*/src/main/AndroidManifest.xml" | while read -r manifest_file; do
    # Determine the module's build.gradle file path by navigating up two directories
    module_dir=$(dirname "$(dirname "$(dirname "$manifest_file")")")
    gradle_file="$module_dir/build.gradle"

    # Check if the build.gradle file exists
    if [[ -f "$gradle_file" ]]; then
        insert_namespace "$manifest_file" "$gradle_file"
    else
        echo "No build.gradle found for $manifest_file, skipping."
    fi
done

echo "Namespace insertion completed."