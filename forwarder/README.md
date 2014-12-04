# Logastash Forwarder in a can

This is a small Docker recipe to build `logstash-forwarder` easily and
install it in your system.


## What is this?

The [Logstash Forwarder](https://github.com/elasticsearch/logstash-forwarder)
is designed to be a lightweight client and server for sending messages to
[Logstash](http://logstash.net).

It has a lower footprint then a full Logstash agent (which runs in Java), and provides
a network protocol (lumberjack) for transmission that is secure, low latency,
low resource usage, and reliable.


## How do I install?

If you want to install `logstash-forwarder` into `/usr/local/bin`, just do this:

    docker run --rm -v /usr/local/bin:/target helder/logstash-forwarder

The [helder/logstash-forwarder](https://registry.hub.docker.com/u/helder/logstash-forwarder/)
container will detect that `/target` is a mountpoint, and it will copy the `logstash-forwarder`
binary into it.

## How to use?

After having it installed you can use something like the following, assuming
Logstash is listening on port 5000 for *lumberjack*:

```json
{
  "network": {
    "servers": ["logstash.example.net:5000"],
    "ssl ca": "/etc/ssl/certs/logstash.crt",
    "timeout": 15
  },
  "files": [
    {
      "paths": ["/var/log/syslog", "/var/log/*.log"],
      "fields": { "type": "syslog" }
    }
  ]
}
```

And run it with:

    logstash-forwarder -config /etc/logstash-forwarder.conf
