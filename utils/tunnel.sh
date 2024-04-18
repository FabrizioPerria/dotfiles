#!/bin/zsh

set -e

if [ "$#" -ne 3 ]; then
    echo "Usage: $0 <user> <pass> <ip>"
    exit 1
fi

USER=$1
PASS=$2
IP=$3

sudo killall sshpass || true
lsof -i :5001 -t | grep '[0-9]*' | xargs kill -9 || true

sshpass -p $PASS ssh -ND7070 $USER@$IP&
exit 0
