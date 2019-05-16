#!/bin/bash

RVM_SCRIPT_FILE=/usr/local/rvm/scripts/rvm
if [[ ! -f "$RVM_SCRIPT_FILE" ]]; then
  echo "[ SV Setup ] ---- Installing RVM ----"
  # Install rvm, default ruby version and bundler.
  \curl -sSL https://rvm.io/pkuczynski.asc | gpg2 --import -
  \curl -sSL https://get.rvm.io | bash -s stable

  echo 'source /etc/profile.d/rvm.sh' >> /etc/profile
  
  echo "[ SV Setup ] ---- Adding users to rvm group ----"
  # Add users to the RVM Group
  usermod -aG rvm root

  # Setup the rvm bash script
  echo "[ SV Setup ] ---- Sourcing rvm.sh ----"
  source /etc/profile.d/rvm.sh
  rvm reload
  rvm requirements run
  
  # Source the RVM script so we have access to RVM
  # source /usr/local/rvm/scripts/rvm
  echo "[ SV Setup ] ---- Sourcing .bashrc ----"
  source ~/.bashrc
  
  # Install ruby
  echo "[ SV Setup ] ---- Installing Ruby 2.6.1 ----"
  rvm install "ruby-2.6.1"

else
  echo "[ SV Setup ] ---- RVM already installed! ----"
  source /etc/profile.d/rvm.sh
  # Source the RVM script so we have access to RVM
  source /usr/local/rvm/scripts/rvm
fi

echo "[ SV Setup ] ---- Setting Ruby 2.6.1 as default ----"
# Set it as the default
rvm use 2.6.1 --default


# Check bundler gem
if [[ "$(gem list -i bundler)" != "true" ]]; then
  gem install bundler --no-ri --no-rdoc
fi

# Install pg gem
if [[ "$(gem list -i pg)" != "true" ]]; then
  gem install pg
fi

# Install bundle gem
if [[ "$(gem list -i bundle)" != "true" ]]; then
  gem install bundle
fi

# rm -rf "$(gem env home)"/cache/*
# rvm reset
