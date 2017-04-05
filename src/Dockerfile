FROM alpine:3.5
RUN apk add --no-cache rsyslog rsyslog-tls
RUN mkdir /var/lib/rsyslog
ADD https://papertrailapp.com/tools/papertrail-bundle.pem /opt/papertrail/papertrail-bundle.pem
RUN chmod 644 /opt/papertrail/papertrail-bundle.pem
COPY . /
VOLUME /var/run/rsyslog/dev
CMD "/run.sh"