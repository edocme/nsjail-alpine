#!/bin/sh
set -e

die() {
    echo "$1" >&2
    exit 1
}

[ "$#" -eq 1 ] || die "usage: $0 <network>"

net="$1"

iptables -F
iptables -t nat -F
iptables -A FORWARD -s "$net" -d 10.0.0.0/8,172.16.0.0/12,192.168.0.0/16 -j DROP
iptables -t nat -A POSTROUTING -s "$net" -j SNAT --to-source "$(hostname -i)"
