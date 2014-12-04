FROM java:7-jre
MAINTAINER Helder Correia <heldercorreia@morfose.net>

# Install Logstash
ENV LOGSTASH_VERSION 1.4.2
RUN curl -s https://download.elasticsearch.org/logstash/logstash/logstash-$LOGSTASH_VERSION.tar.gz | tar --transform "s/^logstash-$LOGSTASH_VERSION/logstash/" -xvz -C /opt

# Change working dir
WORKDIR /opt/logstash

# Install contrib plugins
RUN bin/plugin install contrib

# Run agent with basic config
CMD ["bin/logstash", "-e", "input { stdin { } } output { stdout { codec => rubydebug } }"]
