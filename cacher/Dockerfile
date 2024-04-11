FROM ubuntu:22.04

RUN apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -y python3-pip git cron apt-cacher-ng supervisor && \
  apt clean
RUN pip install git+https://github.com/RioKato/gitmirr.git
COPY config.json /opt
COPY supervisord.conf /etc/supervisor
RUN gitmirr clone /opt/config.json && gitmirr cron /opt/config.json

EXPOSE 9418/tcp
EXPOSE 3142/tcp
CMD ["supervisord"]
