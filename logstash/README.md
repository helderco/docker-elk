# Logstash

Part of my [Elasticsearch ELK stack][]:

* [Elasticsearch][]: [helder/elasticsearch][]
* **[Logstash][]**: [helder/logstash][]
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
packaging systems.


## Usage

To try it out, simply run in interactive mode and write "Testing":

```bash
$ docker run -it --rm --name logstash helder/logstash
Testing
```

You should get back something like:

    {
           "message" => "Testing",
          "@version" => "1",
        "@timestamp" => "2014-12-03T15:34:22.536Z",
              "host" => "6b66c46267f0"
    }

The default is to run this simple script:

    input {
      stdin { }
    }
    output {
      stdout {
        code => rubydebug
      }
    }

But you'll most likely want to send your events to Elasticsearch.

In any case, to use your own config, set up a volume an run the image with it:

```bash
$ docker run -d -v /etc/logstash.conf:/etc/logstash.conf helder/logstash \
    bin/logstash -f /etc/logstash.conf
```

Read the [logstash documentation](http://logstash.net/docs/1.4.2/) to see
what other arguments you can use.


## Sending events to Elasticsearch

You have to first decide on one of three Elasticsearch configurations:

 * Use the embedded Elasticsearch server
 * Use a linked container running Elasticsearch
 * Use an external Elasticsearch server

### Embedded Elasticsearch server

```bash
$ docker run -it --rm -p 9200:9200 helder/logstash \
    bin/logstash -e 'input { stdin { } } output { elasticsearch { embedded => true } }'
you know, for logs
```

You should get something like:

```bash
$ curl http://localhost:9200/_search?pretty
{
  "took" : 25,
  "timed_out" : false,
  "_shards" : {
    "total" : 5,
    "successful" : 5,
    "failed" : 0
  },
  "hits" : {
    "total" : 1,
    "max_score" : 1.0,
    "hits" : [ {
      "_index" : "logstash-2014.12.03",
      "_type" : "logs",
      "_id" : "q0N_1GjQS7ioXlZ765d8ww",
      "_score" : 1.0, "_source" : {"message":"you know, for logs","@version":"1","@timestamp":"2014-12-03T15:52:35.167Z","host":"f44cdc0b8e41"}
    } ]
  }
}
```

### Linked container running Elasticsearch

This is how I'm using it with the rest of my stack.

```bash
$ docker run -it --rm --link <your es container name>:es helder/logstash \
    bin/logstash -e 'input { stdin { } } output { elasticsearch { host => es } }'
```

### External Elasticsearch server

Maybe you have Elasticsearch in a different host:

```bash
$ docker run -it --rm helder/logstash \
    bin/logstash -e 'input { stdin { } } output { elasticsearch { host => es.example.net } }'
```

## Visualize with Kibana

You can use the embeded Kibana to visualize the Elasticsearch data, even if it's
not embeded, although the default Kibana configuration assumes Elasticsearch at
port 9200 in the same host that Logstash is running. If you have something other
then that then you should provide your own `/opt/logstash/vendor/kibana/config.js`
file, or use [helder/kibana][] which allows you to change this setting with an
environment variable.

```bash
$ docker run -it --rm -p 9200:9200 -p 9292:9292 helder/logstash \
    bin/logstash -e 'input { stdin { } } output { elasticsearch { embedded => true } }' web
```

Let's verify the logstash installation by visiting the prebuilt logstash dashboard:

    http://<your_host>:9292/index.html#/dashboard/file/logstash.json

## Security

If you're like me and you're sending logs from remote hosts to a central Logstash,
then you may not want to send them in the clear over the network. For a secure
connection over SSL I use the [Logstash Forwarder](helder/logstash-forwarder)
with the *lumberjack* protocol:

    input {
      lumberjack {
        port => 5000
        ssl_certificate => "/etc/logstash/ssl/logstash.crt"
        ssl_key => "/etc/logstash/ssl/logstash.key"
        type => "lumberjack"
      }
    }
    output {
      elasticsearch {
        host => elasticsearch
      }
    }

Remember to expose the *lumberjack* port with docker (5000 or any other you want).

[Elasticsearch ELK stack]: http://www.elasticsearch.org/overview/
[Elasticsearch]: http://www.elasticsearch.org/overview/elasticsearch/
[Logstash]: http://www.elasticsearch.org/overview/logstash/
[Kibana]: http://www.elasticsearch.org/overview/kibana/
[helder/elasticsearch]: https://registry.hub.docker.com/u/helder/elasticsearch/
[helder/logstash]: https://registry.hub.docker.com/u/helder/logstash/
[helder/kibana]: https://registry.hub.docker.com/u/helder/kibana/
[pblittle/docker-logstash]: https://registry.hub.docker.com/u/pblittle/docker-logstash/
[released tarballs]: http://www.elasticsearch.org/overview/elkdownloads/
