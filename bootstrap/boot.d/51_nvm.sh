#!/usr/bin/env bash

# create nvm working directory
if [ ! -d "$HOME/.nvm" ]; then
  mkdir -p "$HOME/.nvm"
fi

# set NVM_DIR in ~/.zshrc
NVM_DIR_EXPORT=$(cat <<'EOF'

# nvm with bash completion
export NVM_DIR="$HOME/.nvm"
[ -s "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" ] && \. "$HOMEBREW_PREFIX/opt/nvm/nvm.sh" # This loads nvm
[ -s "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && \. "$HOMEBREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" # This loads nvm bash_completion
EOF
)

if ! grep -qF "export NVM_DIR" "$HOME/.zshrc"; then
  printf "%s\n" "$NVM_DIR_EXPORT" >> "$HOME/.zshrc"
fi
