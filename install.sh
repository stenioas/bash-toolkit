#!/usr/bin/env bash

# ----------------------------------------------------------------------------
# INITIALIZATION

set -euo pipefail

trap "tput cnorm" EXIT # Ensures the cursor returns to normal
trap "exit 1" INT      # Ensures the script stops with Ctrl+C
sudo -v                # Ensures the sudo password is ready

# ----------------------------------------------------------------------------
# .ENV

LIB_URL="https://raw.githubusercontent.com/stenioas/bash-toolkit/main/bash-toolkit.lib"
LIB_TMP_DIR="/tmp/bash-toolkit-lib"
LIB_PATH="$LIB_TMP_DIR/bash-toolkit.lib"

# ----------------------------------------------------------------------------
# FUNCTIONS

_check_dependencies() {
    if command -v curl &> /dev/null; then
        DOWNLOADER="curl -fsSL"
        echo "Using curl for download."
    elif command -v wget &> /dev/null; then
        DOWNLOADER="wget -qO-"
        echo "Using wget for download."
    else
        echo "ERROR: 'curl' or 'wget' is required to continue." >&2
        exit 1
    fi
}

# ----------------------------------------------------------------------------
# EXECUTION

main() {
  _check_dependencies

  mkdir -p "$LIB_TMP_DIR"

  # If the file does not exist or is too old (e.g., +24h), download it again
  if [ ! -f "$LIB_PATH" ] || [ $(find "$LIB_PATH" -mtime +1) ]; then
    echo "Downloading updated library: bash-toolkit.lib..."
    curl -sL "$LIB_URL" -o "$LIB_PATH" || {
      echo "ERROR: Failed to download the library from $LIB_URL" >&2
      exit 1
    }
  fi

  source "$LIB_PATH"

  echo "Library 'bash-toolkit.lib' imported successfully!"
}

main
