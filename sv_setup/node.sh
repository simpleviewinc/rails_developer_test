#!/bin/bash

ZR_ROOT_NVM=/root/.nvm
if [[ ! -d "$ZR_ROOT_NVM" ]]; then
  echo "[ SV Setup ] ---- Install NVM ----"
  # Install NVM
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash

  # Sets up NVM to be used right away
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

  # Install node due to some ruby gem deps needing it
  nvm install node

else
  echo "[ SV Setup ] ---- NVM already installed! ----"
fi
