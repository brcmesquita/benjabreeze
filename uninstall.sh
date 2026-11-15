#!/bin/sh
# Remove o benjabreeze e devolve as ventoinhas ao firmware. Rode com: sudo sh uninstall.sh
[ "$(id -u)" -eq 0 ] || { echo "rode com sudo"; exit 1; }
systemctl disable --now benjabreeze 2>/dev/null
pkill -f benjabreeze-tray 2>/dev/null
rm -f /usr/local/bin/benjabreeze /usr/local/bin/benjabreeze-tray \
      /etc/systemd/system/benjabreeze.service \
      /usr/share/applications/benjabreeze-tray.desktop \
      /etc/xdg/autostart/benjabreeze-tray.desktop
rm -rf /usr/local/share/benjabreeze /var/lib/benjabreeze
systemctl daemon-reload
echo "Removido. (config mantida em /etc/benjabreeze.json — apague se quiser)"
