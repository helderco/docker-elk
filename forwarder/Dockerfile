FROM golang:1.4-wheezy
MAINTAINER Helder Correia <heldercorreia@morfose.net>

# Build latest version from master
RUN git clone https://github.com/elasticsearch/logstash-forwarder.git /opt/logstash-forwarder
WORKDIR /opt/logstash-forwarder
RUN go build

# Run installer
COPY installer /installer
CMD ["/installer"]
