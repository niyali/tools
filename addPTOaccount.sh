#!/bin/bash/

Employee_Number=$1
Name=$2
Email=$3
Manager=$4
Status=$5
StartDate=$6
PTO=$7

source addPTOaccount_config.sh
`ssh -i ~/.ssh/id_rsa_pc $username@$hostaddr -L 3306:127.0.0.1:3306 -N &`
mysqlsh --host=127.0.0.1 --sql --port=3306 -u root -p -e "use $database; INSERT INTO $table ($T_field1, $T_field2, $T_field3, $T_field4, $T_field5, $T_field6, $T_field7, $T_field8) VALUES ('$1', '$2', '$3', '$4', '$5', '$6', '$7', '$7');"

