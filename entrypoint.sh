#!/bin/bash

if [ ! -d "/var/lib/mysql/mysql" ]; then
    echo "Məlumat bazası yaradılır..."
    mysql_install_db --user=mysql --datadir=/var/lib/mysql > /dev/null

    tfile=`mktemp`
    if [ ! -f "$tfile" ]; then
        return 1
    fi

    cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES;
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY "${MYSQL_ROOT_PASSWORD}" WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON *.* TO "${MYSQL_USER}"@'%' IDENTIFIED BY "${MYSQL_PASSWORD}";
CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;
FLUSH PRIVILEGES;
EOF

    /usr/bin/mariadbd --user=mysql --bootstrap < $tfile
    rm -f $tfile
fi

echo "MySQL (MariaDB) başladılır..."
# Səhv olan '--address' hissəsini '--bind-address' ilə dəyişdik
exec /usr/bin/mariadbd --user=mysql --console --skip-name-resolve --bind-address=0.0.0.0
