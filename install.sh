#!/bin/sh
# Instala o predator-fan. Rode com: sudo sh install.sh
set -e
[ "$(id -u)" -eq 0 ] || { echo "rode com sudo"; exit 1; }
D=$(dirname "$(readlink -f "$0")")
install -m 755 "$D/predator-fan" /usr/local/bin/predator-fan
install -m 644 "$D/predator-fan.service" /etc/systemd/system/predator-fan.service
[ -f /etc/predator-fan.json ] || install -m 644 "$D/predator-fan.json" /etc/predator-fan.json
systemctl daemon-reload
systemctl enable predator-fan
systemctl restart predator-fan
sleep 3
/usr/local/bin/predator-fan status
