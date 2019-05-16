PG_VERSION=11

sv_remove_old_pg_files(){
  # remove old psql
  local PSQL_BIN=/usr/bin/psql
  if [[ -f "$PSQL_BIN" ]]; then
    echo $"[ SV Setup ] ---- Removing /usr/bin/psql ----"
    rm -rf /usr/bin/psql
  fi
  # Remove the old pd data base if it exists
  local PSQL_DATA=/var/lib/pgsql/$PG_VERSION/data
  if [[ -d "$PSQL_DATA" ]]; then
    echo $"[ SV Setup ] ---- Removing /var/lib/pgsql/$PG_VERSION/data ----"
    rm -rf /var/lib/pgsql/$PG_VERSION/data
  fi
}

sv_remove_current_pg_version(){
  yum remove -y postgres\*
  sv_remove_old_pg_files
  echo $"[ SV Setup ] ---- Finished removing postgres ----"
}

sv_install_pg(){
  echo $"[ SV Setup ] ---- Installing postgres version $PG_VERSION ----"
  rpm -Uvh https://yum.postgresql.org/$PG_VERSION/redhat/rhel-7-x86_64/pgdg-redhat-repo-latest.noarch.rpm
  # Install packages
  yum install -y postgresql$PG_VERSION-server postgresql-$PG_VERSION
  yum install -y postgis2_$PG_VERSION postgis2_$PG_VERSION-client

  if [[ $(cat /etc/yum.conf | grep -c "exclude=postgresql*9*") == 0 ]]; then
    echo "Adding exclude postgres 9 to /etc/yum.conf"
    echo "exclude=postgresql*9*" >> /etc/yum.conf
  fi

  # Check the pg gem dep
  if yum list installed "postgresql11-devel-*" >/dev/null 2>&1; then
    echo $"[ SV Setup ] ---- pg gem dep installed ----"
  else
    # Install and setup postgres-devel dep for gem 'pg'
    yum --setopt=tsflags=nodocs install -y postgresql-devel
  fi
}


sv_setup_pg(){
  
  sv_remove_old_pg_files
  
  local USER_BIN_PSQL=/usr/bin/psql
  if [[ ! -L "$USER_BIN_PSQL" ]]; then
    # Add symlink to psql, so we have easy access to it later
    ln -s /usr/pgsql-$PG_VERSION/bin/psql $USER_BIN_PSQL
  fi
  
  # Add postgres to our path
  if [[ $(cat /root/.bashrc | grep -c "PATH:/usr/pgsql-$PG_VERSION/bin") == 0 ]]; then
    echo "[ ZR-CLI ] ---- Adding postgres $PG_VERSION to \$PATH ----"
    echo "PATH=\$PATH:/usr/pgsql-$PG_VERSION/bin" >> /root/.bashrc
  fi

  # Setup the folder for the postgres user
  mkdir /var/lib/pgsql/$PG_VERSION/data
  chown -R postgres:postgres /var/lib/pgsql/$PG_VERSION/data
  chown -R postgres:postgres /usr/pgsql-$PG_VERSION

  # Init the DB
  sudo -u postgres /usr/pgsql-$PG_VERSION/bin/initdb -D /var/lib/pgsql/$PG_VERSION/data  --auth=trust --auth-host=trust --auth-local=trust --username=postgres

  # Copy over the PG config
  cp ./pg_hba.conf /var/lib/pgsql/$PG_VERSION/data/pg_hba.conf
  cp ./postgresql.conf /var/lib/pgsql/$PG_VERSION/data/postgresql.conf
  
  sudo -u postgres /usr/pgsql-$PG_VERSION/bin/pg_ctl -D /var/lib/pgsql/$PG_VERSION/data -l logfile start
  
  # Create the railstest db
  sudo -u postgres /usr/pgsql-$PG_VERSION/bin/createdb railstest

  # Check if it's ready for connections
  sudo -u postgres /usr/pgsql-$PG_VERSION/bin/pg_isready
  netstat -antup | grep 5432
}

sv_remove_current_pg_version
sv_install_pg
sv_setup_pg