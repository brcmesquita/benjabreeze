# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/);
versões seguem [SemVer](https://semver.org/lang/pt-BR/).

## [0.2.0] — 2026-11-15

### Adicionado
- Ícone na bandeja (`predator-fan-tray`, PyQt6): mostra a temperatura com cor
  (verde → vermelho), RPM e modo; menu para trocar de modo. Inicia no login.
- `install.sh` e `uninstall.sh` instalam/removem o ícone.

## [0.1.0] — 2026-11-15

Primeira versão pública — só terminal.

- Serviço (systemd) com modos `auto` (firmware), `curve`, `silent`, `max` e
  velocidade fixa (`set N`).
- CLI `predator-fan` para trocar de modo sem sudo e ver o status.
- Curvas configuráveis em `/etc/predator-fan.json`, com histerese.
- Proteção: 100 % acima de 92 °C; controle volta ao firmware se o serviço parar.
- `install.sh` / `uninstall.sh`.

[0.2.0]: https://github.com/brcmesquita/predator-fan/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/brcmesquita/predator-fan/releases/tag/v0.1.0
