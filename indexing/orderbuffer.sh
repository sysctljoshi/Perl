#!/bin/sh
find /data/canvera/orders/ -maxdepth 1 -type d -mtime +15 -exec mv {} /data/orders_buff \;
