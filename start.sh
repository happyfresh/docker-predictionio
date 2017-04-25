#!/bin/bash

# Start supervisord and services
/usr/bin/supervisord -n -c /root/supervisord.conf
