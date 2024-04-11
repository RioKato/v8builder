FROM ubuntu:22.04

RUN apt update && \
  DEBIAN_FRONTEND=noninteractive apt install -y python3-pip git && \
  apt clean
RUN pip install git+https://github.com/RioKato/gitmirr.git
COPY config.json /opt
COPY 01proxy /etc/apt/apt.conf.d
COPY build.sh /opt
RUN chmod +x /opt/build.sh
RUN gitmirr redirect /opt/config.json
