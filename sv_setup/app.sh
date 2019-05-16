#!/bin/bash

# If no path, download it from github
if [[ ! -d "$SV_APP_REPO_PATH" ]]; then
  cd /sv
  
  # Pull down the zerista app repo
  git clone https://github.com/simpleviewinc/rails_developer_test.git
  # More to the app dir
fi

cd $SV_APP_REPO_PATH

# Copy over needed files for running the server
if [[ ! -f "$SV_APP_REPO_PATH/config/database.yml" ]]; then
  cp $SV_APP_REPO_PATH/config/database.yml.example $SV_APP_REPO_PATH/config/database.yml
else
  echo $"[ SV Setup ] ---- Config database.yml already set ----"
fi

if [[ ! -f "$SV_APP_REPO_PATH/config/host.yml" ]]; then
  cp $SV_APP_REPO_PATH/config/host.yml.example $SV_APP_REPO_PATH/config/host.yml
else
  echo $"[ SV Setup ] ---- Config host.yml already set ----"
fi

# Setup the rvm bash script
source /etc/profile.d/rvm.sh

# Source the RVM script so we have access to RVM
source /usr/local/rvm/scripts/rvm

# Switch to the correct ruby
rvm use 2.6.1

if [[ "$(gem list -i bundler -v 2.0.1)" != "true" ]]; then
  # Install bundler 2
  gem install bundler -v 2.0.1
fi

# Stops the bundler from throwing an error about running as root user
# This is needed when running in Docker
bundle config --global silence_root_warning 1