#!/usr/bin/env bash
set -e

cd /home/arman/rising-ci

# Remove specific directories
rm -rf .repo/local_manifests
rm -rf .repo/projects/device/$BRAND
rm -rf .repo/projects/vendor/$BRAND
rm -rf .repo/projects/vendor/risingOTA.git
rm -rf .repo/projects/kernel/$BRAND
rm -rf out/error*.log
rm -rf out/target/product/$CODENAME
rm -rf vendor/risingOTA

nuke_rising_dependencies() {
  local initial_dependencies_file=""

  # 1. Check for device-specific dependencies
  local device_specific_dependencies="device/$BRAND/$CODENAME/rising.dependencies"
  if [[ -f "$device_specific_dependencies" ]]; then
    echo "Found initial device-specific dependencies: $device_specific_dependencies"
    initial_dependencies_file="$device_specific_dependencies"
  elif [[ -f "rising.dependencies" ]]; then
    echo "Found initial primary dependencies: rising.dependencies"
    initial_dependencies_file="rising.dependencies"
  else
    echo "Error: No initial rising.dependencies file found in device/$BRAND/$CODENAME or the root directory." >&2
    return 1
  fi

  process_dependencies_file() {
    local file="$1"
    echo "Processing dependencies file: $file"
    local target_paths=$(jq -r '.[].target_path' "$file" 2>/dev/null)

    if [[ -z "$target_paths" ]]; then
      echo "Warning: No target_path entries found in $file or jq failed." >&2
      return 0
    fi

    while IFS= read -r path; do
      if [[ -n "$path" ]]; then
        local full_path="/home/arman/rising-ci/$path"
        local nested_dependencies="$full_path/rising.dependencies"

        echo "Debugging: Checking target path: $path" # Debugging line

        if [[ -f "$nested_dependencies" ]]; then
          echo "Found nested dependencies in target path: $nested_dependencies"
          process_dependencies_file "$nested_dependencies" # Recursive call
        else
          echo "Debugging: No nested dependencies found in $path" # Debugging line
        fi

        if [[ -d "$full_path" ]]; then
          echo "Removing directory: $full_path"
          rm -rf "$full_path"
          # Remove associated .repo project
          local repo_base_path=".repo/project"
          local repo_path="$repo_base_path/$(echo "$path" | sed 's/\//./g').git"
          if [[ -d "$repo_path" ]]; then
            echo "Removing .repo project: $repo_path"
            rm -rf "$repo_path"
          else
            echo "Debugging: .repo project not found: $repo_path" # Debugging line
          fi
        else
          echo "Debugging: Directory not found: $full_path" # Debugging line
        fi
      fi
    done <<< "$target_paths"
  }

  # Start processing the initial dependencies file
  if [[ -n "$initial_dependencies_file" ]]; then
    process_dependencies_file "$initial_dependencies_file"
  fi
}

nuke_rising_dependencies

# Explicitly remove the device-specific directory
echo "Removing device-specific directory: device/$BRAND/$CODENAME"
rm -rf "device/$BRAND/$CODENAME"

echo "Cleanup complete."
