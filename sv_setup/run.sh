
export SV_APP_REPO_PATH=/sv/rails_developer_test


sv_setup_machine(){

  # Set up rvm sudo => https://rvm.io/integration/sudo
  if [[ $(cat /root/.bashrc | grep -c "export rvmsudo_secure_path=0") == 0 ]]; then
    echo "[ SV Setup ] ---- Adding rvmsudo_secure_path to .bashrc ----"
    echo "export rvmsudo_secure_path=0" >> /root/.bashrc
  fi

  # Reload the bashrc file
  source /root/.bashrc

  echo $"[ SV Setup ] ---- Checking yum deps install ----"
  # Check the application deps
  local SV_TEMP_FILE=/tmp/deps_installed.txt
  if [[ -f "$SV_TEMP_FILE" ]]; then
    echo $"[ SV Setup ] ---- Skipping yum deps install ----"
  else
    echo $"[ SV Setup ] ---- Installing yum deps ----"
    bash ./deps.sh
    touch /tmp/deps_installed.txt
  fi

  echo $"[ SV Setup ] ---- Installing Ruby ----"
  # Build and install ruby
  bash ./ruby.sh

  echo $"[ SV Setup ] ---- Checking NVM / Node install ----"
  # Build node for ruby gem deps
  bash ./node.sh

  if [[ $(cat /root/.bashrc | grep -c "source /root/.nvm/nvm.sh") == 0 ]]; then
    # Setup the rvm bash script
    echo "Adding source source /root/.nvm/nvm.sh to .bashrc"
    echo "source /root/.nvm/nvm.sh" >> /root/.bashrc
    source /root/.bashrc
  fi

  # Remove root rvm warning
  if [[ $(cat /root/.rvmrc | grep -c "rvm_silence_path_mismatch_check_flag=1") == 0 ]]; then
    echo "Adding rvm_silence_path_mismatch_check_flag to .rvmrc"
    echo "rvm_silence_path_mismatch_check_flag=1" >> /root/.rvmrc
  fi

  if [[ $(cat /root/.bashrc | grep -c "source /etc/profile.d/rvm.sh") == 0 ]]; then
    # Setup the rvm bash script
    echo "Adding source /etc/profile.d/rvm.sh to .bashrc"
    echo "source /etc/profile.d/rvm.sh" >> /root/.bashrc
    source /root/.bashrc
  fi

  if [[ $(cat /root/.bashrc | grep -c "source /usr/local/rvm/scripts/rvm") == 0 ]]; then
    # Source the RVM script so we have access to RVM
    echo "Adding source /usr/local/rvm/scripts/rvm to .bashrc"
    echo "source /usr/local/rvm/scripts/rvm" >> /root/.bashrc
    source /root/.bashrc
  fi

  echo $"[ SV Setup ] ---- Installing Postgres ----"
  # Build Postgres DB
  bash ./postgres.sh

  echo $"[ SV Setup ] ---- Installing Rails App ----"
  # Build rails application
  bash ./app.sh

  # Move to the app repo
  cd $SV_APP_REPO_PATH

  # Install App deps
  if [[ "$(gem list -i bootstrap)" != "true" || "$1" == "rebuild" || "$1" == "start" &&  "$2" == "rebuild" ]]; then
    echo $"[ SV Setup ] ---- Running bundle install ----"
    bundle install --no-deployment
  fi

  # Clean up once we are done
  unset SV_APP_REPO_PATH

  echo ""
  echo ""
  echo "[ SV Setup ] -------------------------------------- [ SV Setup ]"
  echo "|                                                          |"
  echo "|                      Setup complete                      |"
  echo "|      Please run 'source ~/.bashrc' to reload bashrc      |"
  echo "|                                                          |"
  echo "[ SV Setup ] -------------------------------------- [ SV Setup ]"
  echo ""
  echo ""
  
}

sv_setup_machine $@
