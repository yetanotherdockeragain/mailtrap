FROM debian:stable-20191014-slim

LABEL maintainer.original="""David Bătrânu"" <david.batranu@eaudeweb.ro>"
LABEL maintainer.originalv2="""ipunkt Business Solutions"" <info@ipunkt.biz>"
LABEL maintainer.current="""YetAnotherDockerAgain"""

ENV ROUNDCUBE_VERSION="1.3.10"
ENV DEBIAN_FRONTEND noninteractive
WORKDIR /var/

RUN apt-get update && \
    apt-get upgrade -y -q && \
    apt-get install -q -y \
    postfix \
    dovecot-imapd \
    sqlite \
    php \
    php-mbstring \
    php-sqlite3 \
    php-pear \
    rsyslog \
    wget \
    && \
    a2ensite 000-default && \
    a2enmod expires && \
    a2enmod headers && \
    apt-get purge aptitude && \
    apt-get autoremove && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* && \
    pear channel-update pear.php.net && \
    pear install mail_mime mail_mimedecode net_smtp net_idna2-beta Auth_SASL Horde_ManageSieve crypt_gpg && \
    rm -rf /tmp/pear/

COPY 000-default.conf /etc/apache2/sites-available/000-default.conf
COPY postfix/* /etc/postfix/
COPY dovecot/conf.d/10-mail.conf /etc/dovecot/conf.d/10-mail.conf
COPY docker-entrypoint.sh /var/local/

RUN postmap /etc/postfix/transport && \
    wget https://github.com/roundcube/roundcubemail/releases/download/$ROUNDCUBE_VERSION/roundcubemail-$ROUNDCUBE_VERSION-complete.tar.gz -O roundcube.tar.gz && \
    rm -rf www && \
    tar -zxf roundcube.tar.gz && \
    rm -rf roundcube.tar.gz && \
    mv roundcubemail-$ROUNDCUBE_VERSION www && \
    rm -rf /var/www/installer && \
    mkdir /var/www/db && \
    . /etc/apache2/envvars && \
    chown -R ${APACHE_RUN_USER}:${APACHE_RUN_GROUP} /var/www/temp /var/www/logs /var/www/db && \
    useradd -u 1000 -m -s /bin/bash mailtrap && \
    echo "mailtrap:mailtrap" | chpasswd && \
    chmod 777 -R /var/mail && \
    chmod 777 /var/local/docker-entrypoint.sh

COPY config.inc.php /var/www/config/

EXPOSE 25 80

ENTRYPOINT ["/var/local/docker-entrypoint.sh"]
