# BenjaBreeze

Controle de ventoinhas para notebooks **Acer Predator** no Linux, usando apenas o driver
`acer_wmi` que já vem no kernel — **sem módulo de kernel extra, sem compilar nada**.

*Fan control for Acer Predator laptops on Linux using only the in-kernel `acer_wmi`
hwmon interface (no out-of-tree modules). Lightweight daemon + CLI + KDE/Qt tray icon.*

> Projeto independente, sem afiliação com a Acer. *Acer* e *Predator* são marcas
> da Acer Inc., citadas apenas para indicar compatibilidade.

**Novo por aqui? Veja a [Ajuda: como usar o BenjaBreeze](docs/AJUDA.md).**

## Recursos

- Modos: `auto` (firmware Acer), `max`, velocidade fixa (`set N`) e velocidade mínima
  que sobe sozinha se esquentar (`min N`)
- Ícone na bandeja mostrando a temperatura, com menu para trocar de modo
- Segurança: acima de 92 °C (configurável) força 100 %; se o serviço parar ou falhar,
  o controle volta ao firmware
- Aviso no modo fixo: se esquentar (85 °C, configurável), o ícone avisa — e um clique
  troca para `min` com a mesma velocidade
- Trocar de modo não exige sudo
- Leve: não grava nada em disco, não gera logs; no modo `auto` nem lê sensores
  (veja [Consumo de recursos](#consumo-de-recursos-e-privacidade))

## Requisitos

- Kernel com suporte a ventoinhas no `acer_wmi` (hwmon com `pwm1`/`pwm1_enable`).
  Confira:
  ```sh
  grep -l acer /sys/class/hwmon/hwmon*/name   # deve existir
  ls $(dirname $(grep -l acer /sys/class/hwmon/hwmon*/name))   # deve listar pwm1, pwm2
  ```
- Python 3, systemd
- Para o ícone: PyQt6 (`sudo apt install python3-pyqt6`)

### Compatibilidade

Até o momento, o BenjaBreeze foi testado **somente** neste ambiente:

| | |
|---|---|
| Notebook | Acer Predator Helios Neo 16 (PHN16-72) |
| Sistema | Kubuntu 26.04.1 LTS (Ubuntu 26.04) |
| Kernel | 7.0.0-30-generic |
| Área de trabalho | KDE Plasma 6.6.6 |
| Driver | `acer_wmi` ("Acer Laptop WMI Extras Driver"), do próprio kernel, com controle de ventoinhas (`pwm1`/`pwm2` em `/sys/class/hwmon`) |

Outras distribuições, kernels e modelos Acer com a mesma interface **podem** funcionar,
mas não foram testados: o uso fora desse ambiente é **por sua conta e risco**.
[Relatos de teste são bem-vindos](#contribuindo).

## Instalação

### Opção 1 — pacote .deb (Ubuntu / Kubuntu, recomendado)

Baixe o `.deb` da [última release](https://github.com/brcmesquita/benjabreeze/releases/latest)
e instale:

```sh
sudo apt install ./benjabreeze_*_all.deb
```

O `apt` instala as dependências (Python 3 e PyQt6 para o ícone). Se você já tinha
instalado pelo `install.sh` (ou o antigo `predator-fan`), o pacote remove a instalação
manual e aproveita a sua configuração. **Atualizar:** instale o `.deb` da versão nova do
mesmo jeito. **Remover:** `sudo apt remove benjabreeze`.

### Opção 2 — a partir do código

```sh
git clone https://github.com/brcmesquita/benjabreeze.git
cd benjabreeze
sudo sh install.sh
```

**Atualizar:** `git pull && sudo sh install.sh`. **Remover:** `sudo sh uninstall.sh`.
Não misture as duas opções; para trocar, remova uma antes de instalar a outra.

Na primeira instalação o modo é `auto`: nada muda até você escolher outro.
Para gerar o `.deb` você mesmo: `sh build-deb.sh` (sai em `dist/`).

## Uso

| Comando | Efeito |
|---|---|
| `benjabreeze status` | temperaturas, RPM e modo |
| `benjabreeze watch` | status atualizando a cada segundo |
| `benjabreeze auto` | controle do firmware Acer |
| `benjabreeze max` | 100 % |
| `benjabreeze set <0-100>` | velocidade fixa — qualquer valor: `set 30`, `set 45`, `set 80`… |
| `benjabreeze min <0-100>` | velocidade mínima — ex. `min 40`: nunca abaixo de 40 %, sobe se esquentar |
| `benjabreeze unit C` / `unit F` | temperaturas em Celsius ou Fahrenheit (fica salvo) |
| `benjabreeze lang <código>` | idioma: `auto`, `pt_BR`, `en_US`, `es`, `de`, `fr`, `ru`, `ja`, `ko`, `zh_TW`, `zh_CN` (fica salvo) |
| `benjabreeze --version` | versão instalada |

Ícone na bandeja: `benjabreeze-tray` (ou "BenjaBreeze" no menu; inicia no login).

**Unidade:** no menu do ícone, "Unidade de temperatura" alterna entre °C e °F. A escolha
fica salva em `~/.config/benjabreeze/settings.json` e vale também para o terminal. As
curvas do arquivo de configuração continuam em °C.

**Idioma:** português, inglês, espanhol, alemão, francês, russo, japonês, coreano, chinês
tradicional e chinês simplificado. Por padrão segue o idioma do sistema; troque em
"Idioma" no menu do ícone ou com `benjabreeze lang`. As traduções ficam em
[`i18n.json`](i18n.json) — correções de falantes nativos são muito bem-vindas.

**Ocultar ou desligar:**
- **Ocultar ícone** — esconde só o ícone. O BenjaBreeze continua controlando as
  ventoinhas. Para mostrar de novo, abra "BenjaBreeze" no menu de aplicativos.
- **Desligar BenjaBreeze** — para o serviço e devolve as ventoinhas ao firmware da Acer
  (o KDE pede a sua senha). Uma notificação confirma. O BenjaBreeze volta **de onde
  parou** quando você reiniciar o computador ou abrir o app de novo.
  Pelo terminal: `sudo systemctl stop benjabreeze` / `sudo systemctl start benjabreeze`.

O modo escolhido é lembrado: depois de desligar ou reiniciar, o BenjaBreeze volta no mesmo
modo. Ele fica salvo em `/var/lib/benjabreeze/mode` (gravado só quando você troca de modo).
Na primeira vez, o modo é o `default_mode` da configuração (`auto`).

### Entendendo os modos

- **`auto`** — o firmware da Acer decide, exatamente como sem o BenjaBreeze. O serviço
  fica praticamente parado, só esperando você trocar de modo.
- **`max`** — 100 % o tempo todo.
- **`set N`** — **fixo** em N %, não importa a temperatura. A única exceção é a proteção:
  a partir de 92 °C vai para 100 %. A partir de 85 °C (`warn_temp`) o ícone mostra
  um aviso; clicar nele troca `set N` por `min N`. Sem o ícone, o aviso aparece em
  `journalctl -u benjabreeze`. Se você quer "pelo menos N %, mas subindo quando
  precisar", use `min`.
- **`min N`** — velocidade mínima de trabalho. Fica em N % enquanto a temperatura está
  sob controle; se ela subir (troca para modo desempenho, carga pesada), acelera seguindo
  uma curva de segurança até a temperatura cair e então volta aos N % (com histerese de
  4 °C para não ficar oscilando). Ideal para quem gosta do
  notebook sempre frio sem o risco de ficar preso numa velocidade insuficiente.
  Exemplo com `min 40`:

  | Temperatura | 50 °C | 65 °C | 75 °C | 82 °C | esfriando até 50 °C |
  |---|---|---|---|---|---|
  | Velocidade | 40 % | 48 % | 65 % | 81 % | volta gradualmente a 40 % |

### Cores do ícone

O ícone mostra a temperatura mais alta com uma escala de cores no estilo dos mapas
meteorológicos e câmeras térmicas — do azul gelo ao vermelho vulcão:

| Faixa | Cor | |
|---|---|---|
| abaixo de 30 °C | azul-marinho | nevasca |
| 30–39 °C | azul | frio |
| 40–49 °C | ciano | fresco |
| 50–59 °C | verde | confortável |
| 60–69 °C | verde-limão | morno |
| 70–79 °C | amarelo | quente |
| 80–84 °C | laranja | muito quente |
| 85–91 °C | vermelho | perigo |
| 92 °C ou mais | vermelho-escuro com borda amarela | vulcão — ventoinhas no máximo |

## Consumo de recursos e privacidade

- **Nada é gravado em disco** além das suas preferências (`~/.config/benjabreeze/settings.json`)
  e do último modo escolhido (`/var/lib/benjabreeze/mode`) — poucos bytes, gravados só
  quando você muda algo. Sem logs, sem histórico, sem cache. O único arquivo de
  estado é `/run/benjabreeze/mode` (alguns bytes, em RAM), apagado quando o serviço para.
- **Nada sai do seu computador.** Não há rede, telemetria ou coleta de dados.
- **O que é lido:** a cada 2 s, poucos arquivos virtuais do kernel (`/sys`) com
  temperatura e RPM. Os valores ficam numa variável e são descartados na leitura seguinte.
- **No modo `auto`** o serviço não lê sensores — só confere se o modo mudou.
- **Medições** (PHN16-72):

  | Componente | RAM | CPU |
  |---|---|---|
  | Serviço (`benjabreeze daemon`) | ~13 MB | ~0,1 % de um núcleo |
  | Ícone (`benjabreeze-tray`) | ~25–35 MB próprios* | ~0,15 % de um núcleo |

  \* O `ps` mostra ~140 MB porque inclui as bibliotecas Qt, que o KDE já tem carregadas e
  são compartilhadas entre programas. O ícone é opcional: se não quiser, remova
  `/etc/xdg/autostart/benjabreeze-tray.desktop` e use só o CLI.

## Configuração

`/etc/benjabreeze.json` (relido automaticamente quando é alterado):

```json
{
  "interval": 2.0,
  "hysteresis": 4,
  "panic_temp": 92,
  "warn_temp": 85,
  "default_mode": "auto",
  "min_curve": "curve",
  "curves": {
    "curve":  [[45, 25], [60, 40], [70, 55], [80, 75], [88, 100]]
  }
}
```

`curves.curve` é a curva de segurança que o modo `min` segue acima do mínimo: cada ponto
é `[temperatura °C, velocidade %]`. A temperatura usada é a maior entre os sensores do
`acer_wmi` e o pacote da CPU (`coretemp`).

> Não existe (por enquanto) um modo automático do BenjaBreeze substituindo o do firmware:
> o automático é sempre o da Acer. Um automático próprio só virá com o modo aprendizado
> (veja o roadmap), baseado em dados reais medidos em cada modelo.

## Roadmap

Próximas versões, uma funcionalidade por release:

- **Relatório de compatibilidade**: `benjabreeze report` gera um texto com
  modelo, BIOS, kernel e interfaces detectadas, para colar numa issue do GitHub.

### Milestone: modo aprendizado e base de dados por modelo

Ideia: um modo opcional (`learn`) que observa o notebook e anota quantos RPM são
necessários para **manter** e para **baixar** cada faixa de temperatura (ex. de 5 em
5 °C, de 40 a 90 °C; acima de 90 °C sempre máximo). Com isso:

1. Gerar uma curva sob medida para o seu notebook.
2. Juntar dados de vários usuários e montar curvas recomendadas **por modelo**
   (`profiles/PHN16-72.json`, etc.), além de uma lista de compatibilidade.

Princípios:
- **Opt-in explícito.** Desligado por padrão; ao ativar, o programa explica o que é
  coletado. Sem coleta, nada muda.
- **Sem envio automático, sem servidor.** O programa só gera um resumo em texto
  (uma tabela pequena, sem dados pessoais — só modelo, BIOS, kernel e números de
  temperatura/RPM). O usuário revisa e decide se envia, abrindo uma issue no GitHub
  com um template próprio.
- **Mínimo de recursos:** guarda só a tabela agregada (poucos KB), nunca um histórico
  bruto crescendo no disco.

### Outras ideias

- Editor de curvas no ícone da bandeja
- Pacote AUR (Arch Linux)

## Contribuindo

Testou em outro modelo? Abra uma [issue](https://github.com/brcmesquita/benjabreeze/issues)
com o modelo (`cat /sys/class/dmi/id/product_name`), kernel (`uname -r`) e a saída de
`benjabreeze status`, dizendo se `benjabreeze max` mudou o RPM.

Histórico de versões: [CHANGELOG.md](CHANGELOG.md).

## Desinstalar

- Instalado pelo `.deb`: `sudo apt remove benjabreeze` (ou `purge` para apagar também a
  configuração e o modo salvo).
- Instalado pelo código: `sudo sh uninstall.sh`.

Nos dois casos as ventoinhas voltam ao controle do firmware da Acer.

## Aviso

Use por sua conta e risco, principalmente fora do [ambiente testado](#compatibilidade).
A proteção térmica do próprio hardware (throttling e desligamento) continua ativa, e o
BenjaBreeze força 100 % a partir de 92 °C, mas velocidades fixas baixas sob carga
pesada podem deixar o notebook quente.

## Licença

[MIT](LICENSE)
