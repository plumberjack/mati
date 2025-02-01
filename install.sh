#!/bin/bash

# Define the directory name
MATI_DIR="$HOME/.mati"

# Create .mati directory
mkdir -p "$MATI_DIR"

# Download the JS scripts into .mati directory
curl -o "$MATI_DIR/bin/cli.js" https://raw.githubusercontent.com/plumberjack/mati/refs/heads/main/bin/cli.js

# Create a wrapper script for `mati` command
cat << 'EOF' > "$MATI_DIR/mati"
#!/bin/bash
node "$(dirname "$0")/cli.js" "$@"
EOF

# Make the wrapper script executable
chmod +x "$MATI_DIR/mati"

# Add .mati to $PATH
if [[ ":$PATH:" != *":$MATI_DIR:"* ]]; then
  echo "export PATH=\"\$PATH:$MATI_DIR\"" >> "$HOME/.bashrc"
  echo "export PATH=\"\$PATH:$MATI_DIR\"" >> "$HOME/.zshrc"
fi

# Notify
echo "Installation complete! You can now use the 'mati' command."
echo "Please restart your terminal or run 'source ~/.bashrc' (or 'source ~/.zshrc') to apply changes."