#!/bin/bash

# Define the directory name
MATI_DIR="$HOME/.mati"
TEMP_ZIP="$MATI_DIR/mati-main.zip"
REPO_URL="https://github.com/plumberjack/mati/archive/main.zip"

# Check if mati is installed
if [ -d "$MATI_DIR" ]; then
  echo ""
  read -p "Do you want to remove previous installation of mati? (Yes/no): " REMOVE_MATI
  if [[ "$REMOVE_MATI" == "no" || "$REMOVE_MATI" == "No" || "$REMOVE_MATI" == "NO" ]]; then
    echo "New version of mati will not be installed. Exiting installation."
    echo ""
    exit 0
  else
    echo ""
    echo "Removing $MATI_DIR for fresh install..."
    rm -rf "$MATI_DIR"
  fi
fi


# Check if bun is installed
if ! command -v bun &> /dev/null; then
  echo ""
  echo "bun is not installed. It is required to run the 'mati' CLI."
  read -p "Do you want to install bun to continue? (yes/no): " INSTALL_BUN

  if [[ "$INSTALL_BUN" == "yes" || "$INSTALL_BUN" == "y" ]]; then
    echo "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
    # Ensure bun is available in the current session
    export PATH="$HOME/.bun/bin:$PATH"
    echo "Bun installed..."
  else
    echo "bun is required to proceed. Exiting installation."
    exit 1
  fi
fi

# Create the .mati directory
mkdir -p "$MATI_DIR"

# Download the repository as a ZIP file
echo "Downloading the repository..."
curl -fsSL "$REPO_URL" -o "$TEMP_ZIP"

# Check if the download was successful
if [ ! -f "$TEMP_ZIP" ]; then
  echo "Failed to download the repository. Please check your internet connection."
  exit 1
fi

# Extract the /bin directory from the ZIP file
echo "Extracting the /bin directory..."
unzip -q "$TEMP_ZIP" "mati-main/bin/*" -d "$MATI_DIR/core"

# Move the contents of /bin to the .mati directory 
mv "$MATI_DIR/core/mati-main/bin"/* "$MATI_DIR/core" 

# Clean up
echo "Cleaning up temporary files..."
rm -rf "$TEMP_ZIP" "$MATI_DIR/core/mati-main"
 
echo "Registering 'mati' locally..."

# Create a wrapper script for `mati` and make it executable
MATI_EXE="$MATI_DIR/mati"
cat << 'EOF' > "$MATI_EXE"
#!/bin/bash
# Pass all arguments to cli.js
bun run "$(dirname "$0")/core/cli.js" "$@"
EOF
chmod +x "$MATI_EXE"

# Register the wrapper script
add_to_path() {
  local FILE="$1"
  if [ -f "$FILE" ]; then
    if ! grep -q "export PATH=\"\$PATH:$MATI_DIR\"" "$FILE"; then
      echo "Adding $MATI_DIR to PATH in $FILE..."
      echo "export PATH=\"\$PATH:$MATI_DIR\"" >> "$FILE" 
    fi
  fi
}

add_to_path "$HOME/.bashrc"
add_to_path "$HOME/.zshrc"


# Notify the user
echo ""
echo "Installation complete! You can now use 'mati'!"
echo "Restart your terminal or run 'source ~/.bashrc' (source ~/.zshrc) for changes."
echo ""