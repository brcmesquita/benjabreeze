#!/bin/sh
# Gera dist/benjabreeze_<versão>_all.deb. Não precisa de root.
set -e
D=$(dirname "$(readlink -f "$0")")
V=$(sed -n 's/^VERSION = "\(.*\)"/\1/p' "$D/benjabreeze")
B=$(mktemp -d)
chmod 755 "$B"
trap 'rm -rf "$B"' EXIT

install -D -m 755 "$D/benjabreeze"      "$B/usr/bin/benjabreeze"
install -D -m 755 "$D/benjabreeze-tray" "$B/usr/bin/benjabreeze-tray"
install -D -m 644 "$D/i18n.json"        "$B/usr/share/benjabreeze/i18n.json"
sed 's#/usr/local/bin/#/usr/bin/#' "$D/benjabreeze.service" > "$B/svc"
install -D -m 644 "$B/svc" "$B/usr/lib/systemd/system/benjabreeze.service" && rm "$B/svc"
sed 's#/usr/local/bin/#/usr/bin/#' "$D/benjabreeze-tray.desktop" > "$B/dsk"
install -D -m 644 "$B/dsk" "$B/usr/share/applications/benjabreeze-tray.desktop"
install -D -m 644 "$B/dsk" "$B/etc/xdg/autostart/benjabreeze-tray.desktop" && rm "$B/dsk"
install -D -m 644 "$D/benjabreeze.json" "$B/usr/share/doc/benjabreeze/benjabreeze.json.example"
install -D -m 644 "$D/README.md"        "$B/usr/share/doc/benjabreeze/README.md"
install -D -m 644 "$D/CHANGELOG.md"     "$B/usr/share/doc/benjabreeze/CHANGELOG.md"
install -D -m 644 "$D/LICENSE"          "$B/usr/share/doc/benjabreeze/copyright"

mkdir -p "$B/DEBIAN"
sed "s/@VERSION@/$V/" "$D/packaging/debian/control" > "$B/DEBIAN/control"
for f in preinst postinst prerm postrm; do
    install -m 755 "$D/packaging/debian/$f" "$B/DEBIAN/$f"
done
echo "/etc/xdg/autostart/benjabreeze-tray.desktop" > "$B/DEBIAN/conffiles"

mkdir -p "$D/dist"
dpkg-deb --root-owner-group --build "$B" "$D/dist/benjabreeze_${V}_all.deb"
