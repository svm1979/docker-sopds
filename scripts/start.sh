#!/bin/bash

if [ ! -f /var/lib/pgsql/data/PG_VERSION ] 
then
mkdir /run/postgresql
chown -R postgres:postgres /var/lib/pgsql
chown -R postgres:postgres /run/postgresql
su postgres -c "/usr/bin/pg_ctl -D /var/lib/pgsql/data initdb"
su postgres -c "/usr/bin/pg_ctl -D /var/lib/pgsql/data -l /var/lib/pgsql/data/pg.log start"
sleep 10
psql -U postgres -c "create database sopds"
psql -U postgres -c "create user sopds with password 'sopds'"
psql -U postgres -c "grant all privileges on database sopds to sopds"
cd /sopds
python3 manage.py migrate
python3 manage.py sopds_util clear
sleep 10
fi
cd /sopds
if [ $MIGRATE == True ]
then
python3 manage.py migrate
fi

#if [ ! -f /var/lib/pgsql/setconf ]
#then
#python3 manage.py sopds_util setconf SOPDS_ROOT_LIB $SOPDS_ROOT_LIB
#python3 manage.py sopds_util setconf SOPDS_INPX_ENABLE $SOPDS_INPX_ENABLE
#python3 manage.py sopds_util setconf SOPDS_LANGUAGE $SOPDS_LANGUAGE
#touch /var/lib/pgsql/setconf
#fi
#python3 manage.py sopds_server start & python3 manage.py sopds_scanner start
/bin/bash

