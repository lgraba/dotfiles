#!/usr/bin/env bash

echo "- Installing git from xcode"
xcode-select --install

echo "- init gitsubmodules"
git submodule update --init --recursive

echo "- Installing brew"
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

