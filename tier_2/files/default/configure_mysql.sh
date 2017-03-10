#!/bin/bash
set -e

applicationCode=$1

dbUser=$2
dbpass=$3

dbMasterUser=$4
dbMasterpass=$5
dbHostname=$6

dbTracker="${applicationCode}_tracker"
dbCoder="${applicationCode}_coder"

# dbuser trim to 16 characters only
dbUser=${dbUser:0:15}

echo "[ INFO] Creating Database and User"
echo "[ INFO] Username is: $dbUser"
echo "[ INFO] Password is: $dbpass"
echo "[ INFO] MySQL Host is: $dbHostname"
echo "[ INFO] Tracker Database is: $dbTracker"
echo "[ INFO] Coder Database is: $dbCoder"

#create database for tracker and widget
mysql -u${dbMasterUser} -p${dbMasterpass} -h ${dbHostname} -e "CREATE DATABASE IF NOT EXISTS ${dbTracker};"
mysql -u${dbMasterUser} -p${dbMasterpass} -h ${dbHostname} -e "CREATE DATABASE IF NOT EXISTS ${dbCoder};"

echo "[ INFO] Granting permissions to the user"
mysql -u${dbMasterUser} -p${dbMasterpass} -h ${dbHostname} -e "GRANT CREATE,DELETE,INSERT,SELECT,UPDATE,ALTER ON ${dbTracker}.* TO ${dbUser}@'10.1.%' IDENTIFIED BY '${dbpass}';"
mysql -u${dbMasterUser} -p${dbMasterpass} -h ${dbHostname} -e "GRANT CREATE,DELETE,INSERT,SELECT,UPDATE,ALTER ON ${dbCoder}.* TO ${dbUser}@'10.1.%' IDENTIFIED BY '${dbpass}';"

echo "[ INFO] Flushing Privileges"
mysql -u${dbMasterUser} -p${dbMasterpass} -h ${dbHostname} -e "FLUSH PRIVILEGES;"
