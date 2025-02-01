#!/bin/bash

# Define the directory name
MATI_DIR="$HOME/.mati"

# Remove the .mati directory
if [ -d "$MATI_DIR" ]; then
  echo "Removing $MATI_DIR..."
  rm -rf "$MATI_DIR"
else
  echo "$MATI_DIR does not exist. Skipping removal."
fi

# Remove .mati from PATH in shell configuration files
remove_from_path() {
  local FILE="$1"
  if [ -f "$FILE" ]; then
    if grep -q "export PATH=\"\$PATH:$MATI_DIR\"" "$FILE"; then
      echo "Removing $MATI_DIR from PATH in $FILE..."
      sed -i.bak "/export PATH=\"\$PATH:$MATI_DIR\"/d" "$FILE"
    else
      echo "$MATI_DIR not found in PATH in $FILE. Skipping."
    fi
  else
    echo "$FILE does not exist. Skipping."
  fi
}

# Remove from .bashrc and .zshrc
remove_from_path "$HOME/.bashrc"
remove_from_path "$HOME/.zshrc"

# Notify the user
echo "Uninstallation complete! 'mati' has been removed!"
echo "Restart your terminal or run 'source ~/.bashrc' (or 'source ~/.zshrc') to apply changes."