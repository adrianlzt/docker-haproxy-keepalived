#! /bin/sh
while true; do
  inotifywait -re modify,create,delete --exclude ".*\.swp$" /etc/haproxy
  echo "haproxy seamless reload"
  pkill -USR2 haproxy
done
