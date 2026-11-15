#!/bin/sh
# Instala o predator-fan. Rode com: sudo sh install.sh
set -e
[ "$(id -u)" -eq 0 ] || { echo "rode com sudo"; exit 1; }
D=$(dirname "$(readlink -f "$0")")
install -m 755 "$D/predator-fan" /usr/local/bin/predator-fan
install -m 755 "$D/predator-fan-tray" /usr/local/bin/predator-fan-tray
install -m 644 "$D/predator-fan.service" /etc/systemd/system/predator-fan.service
install -m 644 "$D/predator-fan-tray.desktop" /usr/share/applications/predator-fan-tray.desktop
install -m 644 "$D/predator-fan-tray.desktop" /etc/xdg/autostart/predator-fan-tray.desktop
[ -f /etc/predator-fan.json ] || install -m 644 "$D/predator-fan.json" /etc/predator-fan.json
systemctl daemon-reload
systemctl enable predator-fan
systemctl restart predator-fan
sleep 3
/usr/local/bin/predator-fan status
echo
echo "Ícone da bandeja: abra 'Predator Fan' no menu (inicia sozinho no próximo login)."
