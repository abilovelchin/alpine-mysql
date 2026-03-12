FROM alpine:latest

# MariaDB (MySQL-ə uyğun) və lazımi alətləri yükləyirik
RUN apk add --no-cache mariadb mariadb-client bash

# MySQL-in işləməsi üçün lazım olan qovluqları yaradırıq
RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql

# Şəbəkə portu
EXPOSE 3306

# Başlanğıc skriptini əlavə edirik
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Məlumatların itməməsi üçün Volume təyin edirik
VOLUME ["/var/lib/mysql"]

ENTRYPOINT ["/entrypoint.sh"]
