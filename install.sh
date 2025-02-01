#!/bin/bash

# Define the directory name
MATI_DIR="$HOME/.mati"
REPO_URL="https://github.com/plumberjack/mati/archive/main.zip"
TEMP_ZIP="$MATI_DIR/mati-main.zip"

# Create the .mati directory
mkdir -p "$MATI_DIR"

# Check if bun is installed
if ! command -v bun &> /dev/null; then
  echo "bun is not installed. It is required to run the 'mati' CLI."
  read -p "Do you want to install bun to continue? (yes/no): " INSTALL_BUN

  if [[ "$INSTALL_BUN" == "yes" || "$INSTALL_BUN" == "y" ]]; then
    echo "Installing bun..."
    curl -fsSL https://bun.sh/install | bash
    # Ensure bun is available in the current session
    export PATH="$HOME/.bun/bin:$PATH"
  else
    echo "bun is required to proceed. Exiting installation."
    exit 1
  fi
fi

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
unzip -q "$TEMP_ZIP" "mati-main/bin/*" -d "$MATI_DIR"

# Move the contents of /bin to the .mati directory
mv "$MATI_DIR/mati-main/bin"/* "$MATI_DIR/"

# Clean up
rm -rf "$TEMP_ZIP" "$MATI_DIR/mati-main"

# Create a wrapper script for the `mati` command
echo "Creating the 'mati' command..."
cat << 'EOF' > "$MATI_DIR/mati"
#!/bin/bash
# Pass all arguments to cli.js
node "$(dirname "$0")/cli.js" "$@"
EOF

# Make the wrapper script executable
chmod +x "$MATI_DIR/mati"

# Add the .mati directory to the PATH in the user's shell configuration
if [[ ":$PATH:" != *":$MATI_DIR:"* ]]; then
  echo "Adding $MATI_DIR to PATH..."
  echo "export PATH=\"\$PATH:$MATI_DIR\"" >> "$HOME/.bashrc"
  echo "export PATH=\"\$PATH:$MATI_DIR\"" >> "$HOME/.zshrc"
fi

# Notify the user
echo "Installation complete! You can now use 'mati'!"
echo "Restart your terminal or run 'source ~/.bashrc' (or 'source ~/.zshrc') to apply changes."