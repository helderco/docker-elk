FROM java:7-jre
MAINTAINER Helder Correia <heldercorreia@morfose.net>

# Install ElasticSearch
ENV ES_VERSION 1.1.1
RUN curl -s https://download.elasticsearch.org/elasticsearch/elasticsearch/elasticsearch-$ES_VERSION.tar.gz | tar --transform "s/^elasticsearch-$ES_VERSION/elasticsearch/" -xvz -C /opt

# Define working directory
WORKDIR /opt/elasticsearch

# Add custom elasticsearch.yml config
COPY elasticsearch.yml config/elasticsearch.yml

# Elasticsearch HTTP
EXPOSE 9200

# Elasticsearch transport (cluster)
EXPOSE 9300

# Persistance
VOLUME ["/data"]

# Run
CMD ["bin/elasticsearch"]
