#!/bin/bash

set -e

apt-get update
apt-get -y install makedev
mount none /proc -t proc
cd /dev
MAKEDEV generic
