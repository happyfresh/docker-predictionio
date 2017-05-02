#!/bin/bash

# Start supervisord and services
/usr/bin/supervisord -n -c /root/files/supervisord.conf
