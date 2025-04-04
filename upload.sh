#!/usr/bin/env bash
set -e

upload_to_gofile() {
  local file="$1"
  SERVER=$(curl -s https://api.gofile.io/servers | jq -r '.data.servers[0].name')
  LINK=$(curl -s -F "file=@$file" "https://${SERVER}.gofile.io/uploadFile" | jq -r '.data.downloadPage') 2>/dev/null
  if [[ -n "$LINK" ]]; then
    echo "$LINK"  # Print ONLY the link to stdout
    return 0
  else
    echo "Gofile Upload Failed for $file." >&2 # Print error to stderr
    return 1
  fi
}

TARGET_DIR="/home/arman/rising-ci/out/target/product/${CODENAME}"
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Target directory '$TARGET_DIR' does not exist." >&2
  exit 1
fi

cd "$TARGET_DIR"

ROM_GOFILE_LINKS=""  # Initialize an empty variable for ROM links

FILES=(RisingOS_Revived*.zip)
for FILE in "${FILES[@]}"; do
  if [ ! -e "$FILE" ]; then
    echo "Error: File '$FILE' not found in $TARGET_DIR." >&2
    exit 1
  fi
  echo "Attempting to upload $FILE to Gofile." >&2 # Print informational message to stderr
  GOFILE_LINK=$(upload_to_gofile "$FILE") || exit 1
  ROM_GOFILE_LINKS="$ROM_GOFILE_LINKS $GOFILE_LINK"  # Use space as separator
done

IMAGES=("boot.img" "dtbo.img" "vendor_boot.img" "recovery.img")
for IMAGE in "${IMAGES[@]}"; do
  if [ -e "$IMAGE" ]; then
    echo "Attempting to upload $IMAGE to Gofile." >&2 # Print informational message to stderr
    upload_to_gofile "$IMAGE" # We don't capture the link
  fi
done

echo "Upload process completed." >&2 # Print completion message to stderr
echo "ROM_GOFILE_LINKS=${ROM_GOFILE_LINKS}" >> $GITHUB_ENV  # Export ROM links
