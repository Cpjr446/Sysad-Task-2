#!/bin/bash

touch /home/cpvbox/Sysad2/shared/database.sql

echo "CREATE TABLE mentees (
  rollno INTEGER NOT NULL,
  domain1 VARCHAR(6),
  domain2 VARCHAR(6),
  domain3 VARCHAR(6),
);" >> /home/cpvbox/Sysad2/shared/database.sql

# rollno domain1 domain2 domain3
while read -r rollno domain1 domain2 domain3; do
    echo "INSERT INTO mentees (rollno, domain1, domain2, domain3) VALUES ("$rollno", "$domain1", "$domain2", "$domain3");" >>/home/cpvbox/Sysad2/shared/database.sql
done < "$CORE_HOME/mentees_domain.txt"
