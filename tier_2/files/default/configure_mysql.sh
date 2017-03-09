#!/bin/bash

applicationCode = $1

dbUser = $2
dbpass = $3

dbMasterUser = $4
dbMasterpass = $5
dbHostname = $6

dbTracker = "${applicationCode}_tracker"
dbCoder = "${applicationCode}_coder"

echo "[ INFO] Creating Database and User"
echo "[ INFO] Username is: $dbUser"
echo "[ INFO] Password is: $dbpass"
echo "[ INFO] Tracker Database is: $dbTracker"
echo "[ INFO] Coder Database is: $dbCoder"

#create database for tracker and widget
mysql -u${dbMasterUser} -p${dbMasterpass} -h ${dbHostname} -e "CREATE DATABASE IF NOT EXISTS ${dbTracker};"
mysql -u${dbMasterUser} -p${dbMasterpass} -h ${dbHostname} -e "CREATE DATABASE IF NOT EXISTS ${dbCoder};"

echo "[ INFO] Creating user for the database"
mysql -u${dbMasterUser} -p${dbMasterpass} -h ${dbHostname} -e "CREATE USER IF NOT EXISTS ${dbUser}@'10.1.%' IDENTIFIED BY '${dbpass}';"

echo "[ INFO] Granting permissions to the user"
mysql -u${dbMasterUser} -p${dbMasterpass} -h ${dbHostname} -e "GRANT CREATE,DELETE,INSERT,SELECT,UPDATE,ALTER ON ${dbTracker}.* TO ${dbUser}@'10.1.%';"
mysql -u${dbMasterUser} -p${dbMasterpass} -h ${dbHostname} -e "GRANT CREATE,DELETE,INSERT,SELECT,UPDATE,ALTER ON ${dbCoder}.* TO ${dbUser}@'10.1.%';"

echo "[ INFO] Flushing Privileges"
mysql -u${dbMasterUser} -p${dbMasterpass} -h ${dbHostname} -e "FLUSH PRIVILEGES;"
