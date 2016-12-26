FROM debian:jessie

MAINTAINER opsxcq <opsxcq@thestorm.com.br>

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    package \
    && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY deps /deps
RUN dpkg -i /deps/*

COPY packages /packages
RUN dpkg -i /packages/*

COPY src /src
RUN cd /src &&     make

RUN useradd --system --uid 666 -M --shell /usr/sbin/nologin username
USER username

EXPOSE 80

VOLUME /data
WORKDIR /data

COPY main.sh /
ENTRYPOINT ["/main.sh"]
CMD ["default"]

