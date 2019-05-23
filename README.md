# HAProxy + Keepalived

This image is though to work with two containers in different servers, acting as master-slave.

Supervisord runs keepalived, haproxy and a script to reload haproxy.

## Config

### HAProxy
Get example haproxy conf from the image:
```
mkdir -p etc; docker run --rm -it -v "$PWD/etc:/mnt" --entrypoint cp adrianlzt/haproxy-keepalived -r /etc/haproxy /mnt
```

If some file of the HAproxy configuration mount is modified, haproxy will be reloaded seeamsly.

### Keepalived
Keepalived is configured using environment variables, or mounting the config file.

Variables:
 * VRID: virtual router_id, defaults to 40
 * PRIORITY: priority of this instance, defaults to 100. Should be incremented if we want some instace to become master
 * IFACE: interface where keepalived should be configured
 * VIP: virtual ip configured by keepalived

## Run
Example to run two containers, incrementing priority in the first one to become master:
```
docker run -d \
  --restart=unless-stopped \
  --net host \
  --privileged \
  -v "$PWD/etc/haproxy:/etc/haproxy" \
  -e PRIORITY=150 \
  -e IFACE=eno1 \
  -e VIP=10.10.10.10/24 \
  --name haproxy-master \
  adrianlzt/haproxy-keepalived
```

Slave server:
```
docker run -d \
  --restart=unless-stopped \
  --net host \
  --privileged \
  -v "$PWD/etc/haproxy:/etc/haproxy" \
  -e IFACE=eno1 \
  -e VIP=10.10.10.10/24 \
  --name haproxy-slave \
  adrianlzt/haproxy-keepalived
```
