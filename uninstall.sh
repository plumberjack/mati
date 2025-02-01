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
  local DIR="$2"
  if [ -f "$FILE" ]; then
    if grep -q "export PATH=\"\$PATH:$DIR\"" "$FILE"; then
      echo "Removing $DIR from PATH in $FILE..."
      sed -i.bak "/export PATH=\"\$PATH:$DIR\"/d" "$FILE"
    else
      echo "$DIR not found in PATH in $FILE. Skipping."
    fi
  else
    echo "$FILE does not exist. Skipping."
  fi
}

# Remove from .bashrc and .zshrc
remove_from_path "$HOME/.bashrc" "$MATI_DIR"
remove_from_path "$HOME/.zshrc" "$MATI_DIR"

# Check if bun is installed and ask if the user wants to remove it
if command -v bun &> /dev/null; then
  read -p "Do you want to remove bun? (default: no) [yes/no]: " REMOVE_BUN
  REMOVE_BUN=${REMOVE_BUN:-no} # Default to "no" if no input is provided

  if [[ "$REMOVE_BUN" == "yes" || "$REMOVE_BUN" == "y" ]]; then
    echo "Removing bun..."
    rm -rf "$HOME/.bun"
    # Remove bun from PATH in shell configuration files
    remove_from_path "$HOME/.bashrc" "$HOME/.bun"
    remove_from_path "$HOME/.zshrc" "$HOME/.bun"
    echo "bun has been removed."
  else
    echo "Skipping bun removal."
  fi
else
  echo "bun is not installed. Skipping removal."
fi

# Notify the user
echo "Uninstallation complete! 'mati' has been removed!"
echo "Restart your terminal or run 'source ~/.bashrc' (or 'source ~/.zshrc') to apply changes."