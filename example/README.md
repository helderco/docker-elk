# Dockerized ELK Stack (Example)

This example uses a [crane.yml][1] file to run an ELK stack from this repo.
It includes sample configurations for Logstash and Logstash Forwarder, so
you can have a better idea in practice how things connect to each other.

Just follow the instructions and you should be good to go.


## Instructions

Make sure you have [crane][1] installed first.


### 1. Add `localhost.ssl` host

The included SSL certificate used in Logstash Forwarder is signed for `localhost.ssl`
to keep browsers happy (has to do with non internal domain names such as `localhost`).
So, include the appropriate entry in your hosts file:

    # /etc/hosts
    127.0.0.1  localhost.ssl


### 2. Lift containers

    crane lift

After this, they should all be up. If not, check the logs.


### 3. Run a Logstash Forwarder

I should probably run this forwarder example in a container, but for now, these
instructions are for running in your host.

First, copy the `ssl/server.crt` file to your host's `/etc/logstash/ssl/server.crt`.
This will be needed for the Forwarder to validate the connection to Logstash.

Then install Logstash Forwarder to `/usr/local/bin/logstash-forwarder` with:

    crane lift forwarder

Now run the forwarder with:

    logstash-forwarder -config forwarder.conf

If you're not in this example dir, then change path accordingly.

You should see the output from the forwarder. Check if everything looks ok.


### 4. Open Kibana

Use your browser and access Kibana:

    http://yourhost.example.net

Default username and password is *kibana / docker*.


### 4. Rinse, repeat

Make changes to `forwarder.conf` and rerun the command.

Or make changes to `logstash.conf` and restart with:

    docker restart logstash


[1]: https://github.com/michaelsauter/crane
