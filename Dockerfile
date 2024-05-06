FROM antelle/keeweb:latest

#Get some tools
RUN apt update -y && apt upgrade -y && apt install -y curl unzip php php-fpm

#Install the plugin
RUN curl -Ss -L -O https://github.com/vavrecan/keeweb-local-server/archive/master.zip; \
    unzip master.zip; \
    sed -i 's/"Change This"/getenv("LOCAL_SERVER_PASSWORD")/g' keeweb-local-server-master/server.php; \
    sed -i 's/content="(no-config)"/content="config.json"/' /keeweb/index.html; \
    sed -i 's/plugins\/local-server/plugins\/plugins\/local-server/' keeweb-local-server-master/config.json; \
    sed -i 's/__DIR__ . "\/databases"/"\/databases"/g' keeweb-local-server-master/server.php; \
    cp -r keeweb-local-server-master/plugins keeweb/plugins/; \
    cp keeweb-local-server-master/server.php /keeweb/; \
    cp keeweb-local-server-master/config.json /keeweb/; \
    mkdir /databases; \; \
    rm -r keeweb-local-server-master; \
    rm master.zip;

#Add php to nginx config
COPY keeweb-php /etc/nginx/keeweb-php
RUN sed -i 's/server_name localhost;/server_name localhost;\n    include \/etc\/nginx\/keeweb-php;/g' /etc/nginx/conf.d/keeweb.conf;

#Sort out PHP-fpm
RUN sed -i 's/user = www-data/user = nginx/g' /etc/php/7.3/fpm/pool.d/www.conf; \
    sed -i 's/group = www-data/group = nginx/g' /etc/php/7.3/fpm/pool.d/www.conf; \
    sed -i 's/;cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/g' /etc/php/7.3/fpm/php.ini; \
    sed -i 's/listen.owner = www-data/listen.owner = nginx/g' /etc/php/7.3/fpm/pool.d/www.conf; \
    sed -i 's/listen.group = www-data/listen.group = nginx/g' /etc/php/7.3/fpm/pool.d/www.conf; \
    sed -i 's/# exec CMD/#start fpm\n\/etc\/init.d\/php7.3-fpm start\n\n# exec CMD/' /opt/entrypoint.sh; \
    sed -i 's/;env\[TEMP\] = \/tmp/;env\[TEMP\] = \/tmp\nenv\[LOCAL_SERVER_PASSWORD\] = $LOCAL_SERVER_PASSWORD/g' /etc/php/7.3/fpm/pool.d/www.conf; \
    update-rc.d php7.3-fpm enable;

#Clean up apt
RUN apt-get -y remove curl unzip\
    apt clean -y; \
    rm -rf /var/lib/apt/lists/*;

ENTRYPOINT ["/opt/entrypoint.sh"]
CMD ["nginx"]

ARG LOCAL_SERVER_PASSWORD="Change This"
EXPOSE 443
EXPOSE 80