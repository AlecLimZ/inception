FROM alpine:3.16

ARG DB_NAME \
    DB_USER \
    DB_PASS \
    DB_ROOT

RUN apk update && apk add --no-cache mariadb mariadb-client

RUN mkdir /var/run/mysqld; \
    chmod 777 /var/run/mysqld; \
    { echo '[mysqld]'; \
      echo 'skip-host-cache'; \
      echo 'skip-name-resolve'; \
      echo 'bind-address=0.0.0.0'; \
    } | tee  /etc/my.cnf.d/docker.cnf; \
    sed -i "s|skip-networking|skip-networking=0|g" \
      /etc/my.cnf.d/mariadb-server.cnf

#skip-host-cache - disable the hostname cache.

#skip-name-resolve - disabling DNS lookups for better performance

# because if skip-networking is not set to 0, it will not listen for remote TCP/IP connections. Obviously skip is skip, and since we want to use this database in the local network, need to set skip-networking to 0. (source: https://www.computerworld.com/article/2861513/how-to-configure-mysql-and-mariadb-to-accept-remote-connections.html)

#bind-address=0.0.0.0 allows this accept all connectons from any IP address

RUN mysql_install_db --user=mysql --datadir=/var/lib/mysql

EXPOSE 3306

COPY requirements/mariadb/conf/create_db.sh .
RUN sh create_db.sh && rm create_db.sh
USER mysql
CMD ["/usr/bin/mysqld", "--skip-log-error"]
