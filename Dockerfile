FROM debian:jessie

MAINTAINER opsxcq <opsxcq@thestorm.com.br>

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 \
    php5 \
    python \ 
    sendmail \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY www /www
COPY src /www/vulnerable/

RUN chmod 777 -R /www

COPY virtual-host /etc/apache2/sites-enabled/000-default.conf

EXPOSE 80

COPY main.sh /
ENTRYPOINT ["/main.sh"]
CMD ["default"]

