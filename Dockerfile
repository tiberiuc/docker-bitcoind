FROM tiberiuc/backup-agent as backup
MAINTAINER Tiberiu Craciun <tibi@happysoft.ro>

FROM alpine

ARG VERSION=0.17.1
ARG GLIBC_VERSION=2.28-r0

ENV FILENAME bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz
ENV DOWNLOAD_URL https://bitcoin.org/bin/bitcoin-core-${VERSION}/${FILENAME}

RUN apk update \
  && apk --no-cache add wget tar bash ca-certificates supervisor bzip2 inotify-tools  curl \
  && wget -q -O /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
  && wget https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-bin-${GLIBC_VERSION}.apk \
  && apk --no-cache add glibc-${GLIBC_VERSION}.apk \
  && apk --no-cache add glibc-bin-${GLIBC_VERSION}.apk \
  && rm -rf /glibc-${GLIBC_VERSION}.apk \
  && rm -rf /glibc-bin-${GLIBC_VERSION}.apk \
  && wget $DOWNLOAD_URL \
  && tar xzvf /bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz \
  && mkdir /root/.bitcoin \
  && mv /bitcoin-${VERSION}/bin/* /usr/local/bin/ \
  && rm -rf /bitcoin-${VERSION}/ \
  && rm -rf /bitcoin-${VERSION}-x86_64-linux-gnu.tar.gz \
  && apk del wget ca-certificates \
  && rm -rf /var/cache/apk/* /tmp/*

COPY --from=backup /usr/local/bin/backup_agent /usr/local/bin/backup_agent

EXPOSE 8332 8333 18332 18333 28332 28333 9191

ADD ./scripts/supervisord.conf /etc/supervisord.conf
ADD ./scripts/backup.sh /usr/local/bin/backup.sh
ADD ./scripts/restore_backup.sh /usr/local/bin/restore_backup.sh
ADD ./scripts/bitcoind_entrypoint.sh /usr/local/bin/bitcoind_entrypoint.sh
RUN chmod a+x /usr/local/bin/bitcoind_entrypoint.sh \
    && chmod a+x /usr/local/bin/backup.sh \
    && chmod a+x /usr/local/bin/restore_backup.sh

ENTRYPOINT ["/usr/bin/supervisord"]
CMD ["-c", "/etc/supervisord.conf"]
