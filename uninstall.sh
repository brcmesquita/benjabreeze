#!/bin/sh
# Remove o predator-fan e devolve as ventoinhas ao firmware. Rode com: sudo sh uninstall.sh
[ "$(id -u)" -eq 0 ] || { echo "rode com sudo"; exit 1; }
systemctl disable --now predator-fan 2>/dev/null
pkill -f predator-fan-tray 2>/dev/null
rm -f /usr/local/bin/predator-fan /usr/local/bin/predator-fan-tray \
      /etc/systemd/system/predator-fan.service \
      /usr/share/applications/predator-fan-tray.desktop \
      /etc/xdg/autostart/predator-fan-tray.desktop
systemctl daemon-reload
echo "Removido. (config mantida em /etc/predator-fan.json — apague se quiser)"
