# Changelog

Formato baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/);
versões seguem [SemVer](https://semver.org/lang/pt-BR/).

## [0.9.0] — 2026-11-15

### Adicionado
- 10 idiomas no ícone e no terminal: português (Brasil), inglês (EUA), espanhol, alemão,
  francês, russo, japonês, coreano, chinês tradicional e chinês simplificado. Segue o
  idioma do sistema por padrão; submenu "Idioma" no ícone e comando
  `benjabreeze lang <código>`, salvo em `~/.config/benjabreeze/settings.json`.
- Traduções em `i18n.json` (instalado em `/usr/local/share/benjabreeze/`).

### Alterado
- Botão "Fechar ícone" passa a se chamar "Fechar", com uma dica explicando que fecha só
  o ícone e o serviço continua controlando as ventoinhas.

## [0.8.0] — 2026-11-15

### Adicionado
- Celsius ou Fahrenheit: submenu "Unidade de temperatura" no ícone e comando
  `benjabreeze unit C|F`. A escolha fica salva em `~/.config/benjabreeze/settings.json`
  e vale para o ícone e o terminal. As cores do ícone seguem a mesma escala nas duas
  unidades; as curvas da configuração continuam em °C.

## [0.7.0] — 2026-11-15

### Adicionado
- Escala de cores de temperatura no ícone, no estilo dos mapas meteorológicos:
  azul-marinho (nevasca) → azul → ciano → verde → verde-limão → amarelo → laranja →
  vermelho → vermelho-escuro com borda amarela (vulcão, a partir de 92 °C).

## [0.6.1] — 2026-11-15

### Alterado
- Menu do ícone: nome e versão do app no topo; "Velocidade mínima" vem antes de
  "Velocidade fixa"; rótulos mais curtos ("Mínimo 40%").

## [0.6.0] — 2026-11-15

### Adicionado
- Aviso de temperatura no modo `set` fixo: a partir de `warn_temp` (padrão 85 °C) o
  ícone mostra uma notificação; clicar nela troca `set N` por `min N`. O aviso também
  vai para o journal (`journalctl -u benjabreeze`). Rearma 5 °C abaixo do limite.
- Opções `warn_temp` e `min_curve` no `benjabreeze.json` de exemplo.

## [0.5.0] — 2026-11-15

### Adicionado
- Modo `min N` (ex. `benjabreeze min 40`): velocidade mínima de trabalho. Nunca fica
  abaixo de N %; se a temperatura subir, acelera seguindo a curva (`min_curve`, padrão
  `curve`) e volta ao mínimo quando esfria.
- Ícone: submenu "Velocidade mínima" (30/40/50/60 %) e nomes legíveis dos modos
  ("Fixo 50%", "Mínimo 40%").

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

[0.9.0]: https://github.com/brcmesquita/benjabreeze/compare/v0.8.0...v0.9.0
[0.8.0]: https://github.com/brcmesquita/benjabreeze/compare/v0.7.0...v0.8.0
[0.7.0]: https://github.com/brcmesquita/benjabreeze/compare/v0.6.1...v0.7.0
[0.6.1]: https://github.com/brcmesquita/benjabreeze/compare/v0.6.0...v0.6.1
[0.6.0]: https://github.com/brcmesquita/benjabreeze/compare/v0.5.0...v0.6.0
[0.5.0]: https://github.com/brcmesquita/benjabreeze/compare/v0.4.0...v0.5.0
[0.4.0]: https://github.com/brcmesquita/benjabreeze/compare/v0.3.0...v0.4.0
[0.3.0]: https://github.com/brcmesquita/benjabreeze/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/brcmesquita/benjabreeze/compare/v0.1.0...v0.2.0
[0.1.0]: https://github.com/brcmesquita/benjabreeze/releases/tag/v0.1.0
