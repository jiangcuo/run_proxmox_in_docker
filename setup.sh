#!/bin/bash

dpkg --configure -a
systemctl start pvedaemon

while /bin/true; do
  sleep 60
done
