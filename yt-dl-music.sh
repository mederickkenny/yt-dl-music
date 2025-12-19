#!/bin/bash

# Check if URL argument is provided
if [ $# -eq 0 ]; then
  echo "Usage: $0 <youtube_url>"
  echo "Example: $0 https://youtube.com/watch?v=dQw4w9WgXcQ"
  echo ""
  echo "Requirements: yt-dlp, keyfinder-cli (or aubio)"
  echo "Install keyfinder-cli: brew install keyfinder-cli (macOS) or apt install keyfinder-cli (Ubuntu)"
  exit 1
fi

# Get the YouTube URL from the first argument
URL="$1"

# Create a temporary filename for initial download
TEMP_FILE="temp_audio_$(date +%s)"

echo "Downloading audio..."
# Download audio using yt-dlp with temporary filename
yt-dlp -x \
  --audio-format mp3 \
  --audio-quality 0 \
  -o "${TEMP_FILE}.%(ext)s" \
  "$URL"

# Find the actual downloaded file (in case the extension changed)
DOWNLOADED_FILE=$(find . -name "${TEMP_FILE}.*" -type f | head -1)

if [ ! -f "$DOWNLOADED_FILE" ]; then
  echo "Error: Download failed or file not found"
  exit 1
fi

echo "Analyzing musical key..."

# Try to detect key using keyfinder-cli (preferred) or aubio
KEY=""
if command -v keyfinder-cli &>/dev/null; then
  KEY=$(keyfinder-cli "$DOWNLOADED_FILE" 2>/dev/null | grep -o '[A-G][#b]*[mM]*' | head -1)
elif command -v aubiokey &>/dev/null; then
  KEY=$(aubiokey "$DOWNLOADED_FILE" 2>/dev/null | awk '{print $1}' | head -1)
else
  echo "Warning: No key detection tool found. Install keyfinder-cli or aubio for key detection."
  KEY="unknown"
fi

# If key detection failed, use "unknown"
if [ -z "$KEY" ]; then
  KEY="unknown"
fi

echo "Detected key: $KEY"

# Get video info for proper filename
echo "Getting video information..."
TITLE=$(yt-dlp --get-title "$URL" | tr '/' '_' | tr '"' '_' | tr '<' '_' | tr '>' '_' | tr ':' '_' | tr '|' '_' | tr '?' '_' | tr '*' '_')
VIDEO_ID=$(yt-dlp --get-id "$URL")

# Create final filename
FINAL_FILENAME="${TITLE}-[${VIDEO_ID}]-[${KEY}].mp3"

# Rename the file
mv "$DOWNLOADED_FILE" "$FINAL_FILENAME"

echo "Download completed: $FINAL_FILENAME"