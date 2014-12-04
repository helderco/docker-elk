# Elasticsearch

Part of my [Elasticsearch ELK stack][]:

* **[Elasticsearch][]**: [helder/elasticsearch][]
* [Logstash][]: [helder/logstash][]
* [Kibana][]: [helder/kibana][]

See more at [https://github.com/helderco/docker-elk]().


## About this image

I started off using the [pblittle/docker-logstash][] image which runs ELK through
Logstash with embeded Elasticsearch and Kibana, but found performance issues in
production so I decided to split into separate containers, while being as close to
standard or default installation as possible.

Some of the other images I searched for were installing Java (requisite), using another
unofficial base image or putting ELK in the same container. I wanted a clean Dockerfile,
with official image based on Debian, so I made my own.

I chose to install from latest [released tarballs][] instead of using distribution
packaging systems. Elasticsearch is not the latest because each Logstash version has
a recomended Elasticsearch version and I'm using the one for the latest Logstash
(which is 1.4.2 as of now).


## Usage

    docker run -d -p 9200:9200 -p 9300:9300 helder/elasticsearch

After few seconds, open `http://<host>:9200` to see the result.

### Attach persistent/shared directories

The image is configured to store elasticsearch data in the volume `/data`.
You can mount it to your host if you want:

    docker run -d -p 9200:9200 -p 9300:9300 -v /var/elasticsearch:/data helder/elasticsearch

The advantage of doing this is not having to create intermediate data containers
when recreating the container.

### Use a different configuration file

You can use a different configuration file by adding a volume with the file
and using it with an overriden command:

    docker run -d -p 9200:9200 -p 9300:9300 -v /etc/elasticsearch.yml:/etc/elasticsearch.yml \
      helder/elasticsearch bin/elasticsearch -f /etc/elasticsearch.yml


## Security

By default, Elasticsearch runs without any security. So, in production, I'm only exposing
through [helder/kibana] to the outside, protected with Nginx and HTTP Basic Authentication,
but you can do something more custom with a separate container and [play http tricks with nginx][].


[Elasticsearch ELK stack]: http://www.elasticsearch.org/overview/
[Elasticsearch]: http://www.elasticsearch.org/overview/elasticsearch/
[Logstash]: http://www.elasticsearch.org/overview/logstash/
[Kibana]: http://www.elasticsearch.org/overview/kibana/
[helder/elasticsearch]: https://registry.hub.docker.com/u/helder/elasticsearch/
[helder/logstash]: https://registry.hub.docker.com/u/helder/logstash/
[helder/kibana]: https://registry.hub.docker.com/u/helder/kibana/
[pblittle/docker-logstash]: https://registry.hub.docker.com/u/pblittle/docker-logstash/
[released tarballs]: http://www.elasticsearch.org/overview/elkdownloads/
[play http tricks with nginx]: http://www.elasticsearch.org/blog/playing-http-tricks-nginx/
