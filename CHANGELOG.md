# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/);
versões seguem [SemVer](https://semver.org/lang/pt-BR/).

## [0.4.0] — 2026-11-15

### Alterado
- Modo `auto`: o serviço não lê mais sensores, só confere se o modo mudou.
- Serviço: caminhos dos sensores resolvidos uma única vez; configuração relida só quando
  o arquivo muda; roda com prioridade baixa (`Nice=10`).
- `/run/benjabreeze` agora é gerenciado pelo systemd (`RuntimeDirectory`): criado ao
  subir, apagado ao parar.
- Ícone: não executa mais `systemctl` a cada atualização; atualiza a cada 5 s no modo
  `auto` (2 s nos demais) e só redesenha o ícone quando a temperatura muda.
- `watch` não executa mais o comando `clear` a cada segundo.

### Adicionado
- `benjabreeze --version`.
- README: explicação dos modos, consumo de recursos e privacidade, roadmap.

## [0.3.0] — 2026-11-15

### Alterado
- Projeto renomeado de `predator-fan` para **BenjaBreeze**, sem marcas de terceiros no
  nome: comando `benjabreeze`, ícone `benjabreeze-tray`, serviço `benjabreeze.service`,
  configuração `/etc/benjabreeze.json`.
- `install.sh` remove a instalação antiga do `predator-fan` e aproveita a configuração.

### Adicionado
- Aviso de marcas no README.

## [0.2.0] — 2026-11-15

### Adicionado
- Ícone na bandeja (`predator-fan-tray`, PyQt6): mostra a temperatura com cor
  (verde → vermelho), RPM e modo; menu para trocar de modo. Inicia no login.
- `install.sh` e `uninstall.sh` instalam/removem o ícone.

## [0.1.0] — 2026-11-15

Primeira versão pública — só terminal (nome original: `predator-fan`).

- Serviço (systemd) com modos `auto` (firmware), `curve`, `silent`, `max` e
  velocidade fixa (`set N`).
- CLI para trocar de modo sem sudo e ver o status.
- Curvas configuráveis, com histerese.
- Proteção: 100 % acima de 92 °C; controle volta ao firmware se o serviço parar.
- `install.sh` / `uninstall.sh`.

[0.4.0]: https://github.com/brcmesquita/benjabreeze/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/brcmesquita/benjabreeze/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/brcmesquita/benjabreeze/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/brcmesquita/benjabreeze/releases/tag/v0.1.0
