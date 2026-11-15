# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/);
versões seguem [SemVer](https://semver.org/lang/pt-BR/).

## [0.1.0] — 2026-11-15

Primeira versão pública — só terminal.

- Serviço (systemd) com modos `auto` (firmware), `curve`, `silent`, `max` e
  velocidade fixa (`set N`).
- CLI `predator-fan` para trocar de modo sem sudo e ver o status.
- Curvas configuráveis em `/etc/predator-fan.json`, com histerese.
- Proteção: 100 % acima de 92 °C; controle volta ao firmware se o serviço parar.
- `install.sh` / `uninstall.sh`.

[0.1.0]: https://github.com/brcmesquita/predator-fan/releases/tag/v0.1.0
