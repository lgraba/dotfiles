#!/usr/bin/env bash

export NVM_DIR="$HOME/.nvm"

HOMEBREW_PREFIX=""
NVM_SCRIPT_PATH=""

if command -v brew &> /dev/null; then HOMEBREW_PREFIX=$(brew --prefix);
elif [ -d "/opt/homebrew/opt/nvm" ]; then HOMEBREW_PREFIX="/opt/homebrew";
elif [ -d "/usr/local/opt/nvm" ]; then HOMEBREW_PREFIX="/usr/local"; fi

if [ -n "$HOMEBREW_PREFIX" ]; then NVM_SCRIPT_PATH="$HOMEBREW_PREFIX/opt/nvm/nvm.sh"; fi

if [ -s "$NVM_SCRIPT_PATH" ]; then
    \. "$NVM_SCRIPT_PATH"
else
    echo "Error: Could not find or source nvm.sh at '$NVM_SCRIPT_PATH'." >&2
    exit 1
fi

if ! command -v nvm &> /dev/null; then
    echo "Error: 'nvm' command not available after sourcing." >&2
    exit 1
fi

INSTALLED_LTS="N/A"
INSTALLED_LATEST="N/A"
DEFAULT_SET="N/A"

if nvm install --lts --quiet; then
    INSTALLED_LTS=$(nvm version lts/*)
else
    echo "Warning: Failed to install Node.js LTS." >&2
fi

if nvm install node --quiet; then
    INSTALLED_LATEST=$(nvm version node)
else
    echo "Warning: Failed to install latest (current) Node.js." >&2
fi

if [ "$INSTALLED_LATEST" != "N/A" ]; then
    if nvm alias default "$INSTALLED_LATEST" --silent; then
         DEFAULT_SET="$INSTALLED_LATEST (Latest)"
    else
         echo "Warning: Failed to set default Node alias to Latest ($INSTALLED_LATEST)." >&2
    fi
elif [ "$INSTALLED_LTS" != "N/A" ]; then
     if nvm alias default "$INSTALLED_LTS" --silent; then
         DEFAULT_SET="$INSTALLED_LTS (LTS)"
    else
         echo "Warning: Failed to set default Node alias to LTS ($INSTALLED_LTS)." >&2
    fi
fi

echo "✅ Node installation:"
echo "   LTS Version:      $INSTALLED_LTS"
echo "   Latest Version:   $INSTALLED_LATEST"
echo "   Default set to:   $DEFAULT_SET"

exit 0