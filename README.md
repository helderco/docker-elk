# Dockerized ELK stack

This is a setup for [Elasticsearch ELK stack][] using docker containers:

* [Elasticsearch][]: search, analyze in real-time
* [Logstash][]: scrub, parse, and enrich
* [Kibana][]: line graphs, pie charts…

Docker builds:

* [helder/elasticsearch][]
* [helder/logstash][]
* [helder/kibana][]

And also for sending remote logs in a lightweight and secure way:

* [helder/logstash-forwarder][]

## About

This repo stores the Dockerfiles for Docker automated trusted builds (see links above).

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

Even though I created these images as a part of one stack, they can be used independently.
To know more about how to use this, read the documentation for each component:

* [Elasticsearch](elasticsearch/)
* [Logstash](logstash/)
* [Kibana](kibana/)
* [Logstash Forwarder](forwarder/)

I created an [example](example/) setup with simple instructions using [crane][]
so you can try it out and develop from a working setup.

## Contributing

I gladly accept ideas and pull requests with improvements.


[Elasticsearch ELK stack]: http://www.elasticsearch.org/overview/
[Elasticsearch]: http://www.elasticsearch.org/overview/elasticsearch/
[Logstash]: http://www.elasticsearch.org/overview/logstash/
[Kibana]: http://www.elasticsearch.org/overview/kibana/
[helder/elasticsearch]: https://registry.hub.docker.com/u/helder/elasticsearch/
[helder/logstash]: https://registry.hub.docker.com/u/helder/logstash/
[helder/kibana]: https://registry.hub.docker.com/u/helder/kibana/
[helder/logstash-forwarder]: https://registry.hub.docker.com/u/helder/logstash-forwarder/
[pblittle/docker-logstash]: https://registry.hub.docker.com/u/pblittle/docker-logstash/
[released tarballs]: http://www.elasticsearch.org/overview/elkdownloads/
[crane]: https://github.com/michaelsauter/crane
