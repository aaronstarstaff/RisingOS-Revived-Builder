#!/usr/bin/env bash
set -e

# Uploads a file to Gofile and returns the download link
upload_to_gofile() {
  local file="$1"
  SERVER=$(curl -s https://api.gofile.io/servers | jq -r '.data.servers[0].name')
  
  # Attempt upload to Gofile and extract the download link
  LINK=$(curl -s -F "file=@$file" "https://${SERVER}.gofile.io/uploadFile" | jq -r '.data.downloadPage') 2>/dev/null
  
  # Check if the upload succeeded
  if [[ -n "$LINK" ]]; then
    echo "$LINK"  # Print ONLY the link to stdout
    return 0
  else
    echo "Error: Gofile upload failed for $file." >&2
    return 1
  fi
}

TARGET_DIR="/home/arman/rising-ci/out/target/product/${CODENAME}"
if [ ! -d "$TARGET_DIR" ]; then
  echo "Error: Target directory '$TARGET_DIR' does not exist." >&2
  exit 1
fi

cd "$TARGET_DIR"

ROM_GOFILE_LINKS=""
BOOT_IMG_LINK=""
DTBO_IMG_LINK=""
VENDOR_BOOT_IMG_LINK=""
RECOVERY_IMG_LINK=""

# Upload RisingOS .zip files
FILES=(RisingOS_Revived*.zip)
for FILE in "${FILES[@]}"; do
  if [ ! -e "$FILE" ]; then
    echo "Error: File '$FILE' not found in $TARGET_DIR." >&2
    exit 1
  fi
  echo "Attempting to upload $FILE to Gofile." >&2
  GOFILE_LINK=$(upload_to_gofile "$FILE") || exit 1
  ROM_GOFILE_LINKS="$ROM_GOFILE_LINKS $GOFILE_LINK"
done

# Upload boot, dtbo, vendor_boot, recovery images if they exist
IMAGES=("boot.img" "dtbo.img" "vendor_boot.img" "recovery.img")
for IMAGE in "${IMAGES[@]}"; do
  if [ -e "$IMAGE" ]; then
    echo "Attempting to upload $IMAGE to Gofile." >&2
    IMAGE_LINK=$(upload_to_gofile "$IMAGE")
    
    # Store the link based on the image type
    case "$IMAGE" in
      "boot.img")
        BOOT_IMG_LINK="$IMAGE_LINK"
        ;;
      "dtbo.img")
        DTBO_IMG_LINK="$IMAGE_LINK"
        ;;
      "vendor_boot.img")
        VENDOR_BOOT_IMG_LINK="$IMAGE_LINK"
        ;;
      "recovery.img")
        RECOVERY_IMG_LINK="$IMAGE_LINK"
        ;;
    esac
  fi
done

echo "Upload process completed." >&2

# Save the links as GitHub Actions environment variables
echo "ROM_GOFILE_LINKS=${ROM_GOFILE_LINKS}" >> $GITHUB_ENV
echo "BOOT_IMG_LINK=${BOOT_IMG_LINK}" >> $GITHUB_ENV
echo "DTBO_IMG_LINK=${DTBO_IMG_LINK}" >> $GITHUB_ENV
echo "VENDOR_BOOT_IMG_LINK=${VENDOR_BOOT_IMG_LINK}" >> $GITHUB_ENV
echo "RECOVERY_IMG_LINK=${RECOVERY_IMG_LINK}" >> $GITHUB_ENV

