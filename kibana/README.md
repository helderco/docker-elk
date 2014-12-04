# Kibana

Part of my [Elasticsearch ELK stack][]:

* [Elasticsearch][]: [helder/elasticsearch][]
* [Logstash][]: [helder/logstash][]
* **[Kibana][]**: [helder/kibana][]

See more at [https://github.com/helderco/docker-elk]().


## About this image

I started off using the [pblittle/docker-logstash][] image which runs ELK through
Logstash with embeded Elasticsearch and Kibana, but found performance issues in
production so I decided to split into separate containers, while being as close to
standard or default installation as possible.


### Security considerations

Kibana is pretty basic, running in browser, so I used nginx as the base image
with configs that add HTTP Basic Auth for Kibana as well as Elasticsearch.


## Usage

This is meant to run with Elasticsearch (can be used with any elasticsearch container):

    docker run -d --name elasticsearch helder/elasticsearch
    docker run -d --link elasticsearch:elasticsearch -p 80:80 --name kibana helder/kibana

Open `http://<host>`. The default username and password is *kibana / docker*.

Note: The link alias to elasticsearch is expected to be `elasticsearch`.


## Configuration

By default, this Kibana tries to connect to Elasticsearch at the same address (protocol,
hostname and port), which is probably what you want if you're using the included
nginx configuration, but you can override this setting in order to specify another
host for Elasticsearch:

    docker run -d ... \
        -e ELASTICSEARCH="http://<your-es-host>:<port>" \
        -e DEFAULT_ROUTE="/dashboard/file/logstash.json" \
        helder/kibana

As of now, the following environment variables are available:

* [ELASTICSEARCH](http://www.elasticsearch.org/guide/en/kibana/current/_configuration.html#_elasticsearch):
    *Address to Elasticsearch, as seen from your browser.*
* [DEFAULT_ROUTE](http://www.elasticsearch.org/guide/en/kibana/current/_configuration.html#_default_route):
    *The default landing page when you don’t specify a dashboard to load.*

Note: Since the `ELASTICSEARCH` variable accepts js code (i.e. an object), in the
      absence of a space it is assumed to be a string and thus single quotes will
      be added.


## Authentication

This image includes the `htpasswd` tool for setting credentials for HTTP Basic Auth.
You can use it to update the included `.htpasswd` file.

    # Add new credentials
    docker exec kibana htpasswd -b /etc/nginx/.htpasswd myuser mypass

    # Delete default user
    docker exec kibana htpasswd -D /etc/nginx/.htpasswd kibana

    # Or update default user's password
    docker exec kibana htpasswd -b /etc/nginx/.htpasswd kibana mypass


Note: It may be a good idea do mount this file as a volume so you don't have to repeat
this when recreating the container.


### More granular permissions

I just protect the whole thing, but If you need more [granular permissions][]
or something more custom on the nginx side, just create a new `Dockerfile`
that adds your own nginx config:

    # Dockerfile
    FROM helder/kibana
    COPY kibana.conf /etc/nginx/conf.d/default.conf

    # Or nginx.conf entirely
    COPY nginx.conf /etc/nginx/nginx.conf


## SSL

In production I don't publish this container to port 80. I have another nginx container
running in port 80, being a reverse proxy with SSL termination to other containers. So
I have something like this:

    docker run -d --name elasticsearch helder/elasticsearch
    docker run -d --link elasticsearch:es --name kibana helder/kibana
    docker run -d --link kibana:kibana [--link ...] -p 80:80 -p 443:443 nginx

Where nginx is terminating SSL (with redirection from port 80), and in turn
is reverse proxying to Kibana which is authenticating Kibana and Elasticsearch.


[Elasticsearch ELK stack]: http://www.elasticsearch.org/overview/
[Elasticsearch]: http://www.elasticsearch.org/overview/elasticsearch/
[Logstash]: http://www.elasticsearch.org/overview/logstash/
[Kibana]: http://www.elasticsearch.org/overview/kibana/
[helder/elasticsearch]: https://registry.hub.docker.com/u/helder/elasticsearch/
[helder/logstash]: https://registry.hub.docker.com/u/helder/logstash/
[helder/kibana]: https://registry.hub.docker.com/u/helder/kibana/
[pblittle/docker-logstash]: https://registry.hub.docker.com/u/pblittle/docker-logstash/
[granular permissions]: http://www.elasticsearch.org/blog/playing-http-tricks-nginx/
