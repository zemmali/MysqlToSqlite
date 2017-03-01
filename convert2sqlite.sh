#!/bin/sh

NOW="$(date +"%F_%H%M")"
DIR="/home/Backup"
dbsrc="mysql_db"
dbdest="sqlite_db"

# specification table you need to convert
Tables="table_name1 table_name2 table_name3"
pass="pASSw0Rd"


# create sqlite_db database
echo "$NOW : Generate sqlite_db database of mysql_db " > $DIR/convert.log

# Drop DATABASE sqlite_db 
echo "Drop DATABASE $dbdest" | mysql -u root -p$pass


# Create sqlite_db database
echo "CREATE DATABASE IF NOT EXISTS $dbdest" | mysql -u root -p$pass


# Create Backup mysql_db database
mysqldump -u root -p$pass $dbsrc $Tables > $DIR/dbdest.sql


# Restauration Backup MySQL_db database on sqlite_db database
mysql -u root -p$pass $dbdest < $DIR/dbdest.sql


# convert mysql into sqlite format using sequel converter
echo "$NOW : Convert sqlite_db database of MySQL into Sqlite format " >> $DIR/convert2sqlite.log


rm $DIR/convert2sqlite.sqlite


sequel -C mysql2://root:pASSw0Rd@localhost/sqlite_db sqlite://$DIR/convert2sqlite.sqlite


# Check the migration
if [ $? -ne 0 ]
then
       echo "$NOW : Migration Sqlite Database NOK" >> $DIR/convert2sqlite.log
           exit
else
       echo "$NOW : Migration Sqlite Database OK" >> $DIR/convert2sqlite.log
           rm dbdest.sql
           echo $(date +"%F") > $DIR/version.log
fi
