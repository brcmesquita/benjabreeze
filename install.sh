#!/bin/sh
# Instala o benjabreeze. Rode com: sudo sh install.sh
set -e
[ "$(id -u)" -eq 0 ] || { echo "rode com sudo"; exit 1; }
D=$(dirname "$(readlink -f "$0")")

# Migração: remove a instalação antiga com o nome "predator-fan" (até a v0.2.0)
if [ -f /etc/systemd/system/predator-fan.service ]; then
    echo "Removendo instalação antiga (predator-fan)..."
    systemctl disable --now predator-fan 2>/dev/null || true
    pkill -f predator-fan-tray 2>/dev/null || true
    if [ -f /etc/predator-fan.json ] && [ ! -f /etc/benjabreeze.json ]; then
        mv /etc/predator-fan.json /etc/benjabreeze.json
    fi
    rm -f /usr/local/bin/predator-fan /usr/local/bin/predator-fan-tray \
          /etc/systemd/system/predator-fan.service \
          /usr/share/applications/predator-fan-tray.desktop \
          /etc/xdg/autostart/predator-fan-tray.desktop
fi
install -m 755 "$D/benjabreeze" /usr/local/bin/benjabreeze
install -m 755 "$D/benjabreeze-tray" /usr/local/bin/benjabreeze-tray
install -D -m 644 "$D/i18n.json" /usr/local/share/benjabreeze/i18n.json
install -m 644 "$D/benjabreeze.service" /etc/systemd/system/benjabreeze.service
install -m 644 "$D/benjabreeze-tray.desktop" /usr/share/applications/benjabreeze-tray.desktop
install -m 644 "$D/benjabreeze-tray.desktop" /etc/xdg/autostart/benjabreeze-tray.desktop
[ -f /etc/benjabreeze.json ] || install -m 644 "$D/benjabreeze.json" /etc/benjabreeze.json
systemctl daemon-reload
systemctl enable benjabreeze
systemctl restart benjabreeze
sleep 3
/usr/local/bin/benjabreeze status
echo
echo "Ícone da bandeja: abra 'BenjaBreeze' no menu (inicia sozinho no próximo login)."
