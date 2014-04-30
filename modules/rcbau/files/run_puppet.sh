#!/bin/bash

if [ ! -e /root/NO_PUPPET ]
then
    puppet agent --no-daemonize --onetime --verbose --show_diff --no-splay
fi
