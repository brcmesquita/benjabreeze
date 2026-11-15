# BenjaBreeze

Controle de ventoinhas para notebooks **Acer Predator** no Linux, usando apenas o driver
`acer_wmi` que já vem no kernel — **sem módulo de kernel extra, sem compilar nada**.

*Fan control for Acer Predator laptops on Linux using only the in-kernel `acer_wmi`
hwmon interface (no out-of-tree modules). Lightweight daemon + CLI + KDE/Qt tray icon.*

> Projeto independente, sem afiliação com a Acer. *Acer* e *Predator* são marcas
> da Acer Inc., citadas apenas para indicar compatibilidade.

## Recursos

- Modos: `auto` (firmware Acer), `curve`, `silent`, `max`, velocidade fixa (`set N`) e
  velocidade mínima que sobe sozinha se esquentar (`min N`)
- Curvas temperatura → velocidade configuráveis, com histerese (evita sobe-e-desce)
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

Testado em: **Predator Helios Neo 16 (PHN16-72)**, Kubuntu, kernel 7.0.
Outros modelos com a mesma interface devem funcionar — [relatos são bem-vindos](#contribuindo).

## Instalação

```sh
git clone https://github.com/brcmesquita/benjabreeze.git
cd benjabreeze
sudo sh install.sh
```

O padrão após instalar é `auto`: nada muda até você escolher outro modo.

**Atualizar:** `git pull && sudo sh install.sh` (sua `/etc/benjabreeze.json` é mantida;
o modo volta ao padrão).

## Uso

| Comando | Efeito |
|---|---|
| `benjabreeze status` | temperaturas, RPM e modo |
| `benjabreeze watch` | status atualizando a cada segundo |
| `benjabreeze auto` | controle do firmware Acer |
| `benjabreeze curve` | curva normal |
| `benjabreeze silent` | curva silenciosa |
| `benjabreeze max` | 100 % |
| `benjabreeze set <0-100>` | velocidade fixa — qualquer valor: `set 30`, `set 45`, `set 80`… |
| `benjabreeze min <0-100>` | velocidade mínima — ex. `min 40`: nunca abaixo de 40 %, sobe se esquentar |
| `benjabreeze --version` | versão instalada |

Ícone na bandeja: `benjabreeze-tray` (ou "BenjaBreeze" no menu; inicia no login).

O modo volta ao `default_mode` a cada boot.

### Entendendo os modos

- **`auto`** — o firmware da Acer decide, exatamente como sem o BenjaBreeze. O serviço
  fica praticamente parado, só esperando você trocar de modo.
- **`curve` / `silent`** — automáticos: a cada 2 s o BenjaBreeze lê a temperatura e
  ajusta a velocidade pela curva. Esquentou → acelera; esfriou → desacelera (com
  histerese de 4 °C para não ficar oscilando). Se você procurava um modo "follow"
  (sobe quando aquece, volta quando esfria), é isto.
- **`max`** — 100 % o tempo todo.
- **`set N`** — **fixo** em N %, não importa a temperatura. A única exceção é a proteção:
  a partir de 92 °C vai para 100 %. A partir de 85 °C (`warn_temp`) o ícone mostra
  um aviso; clicar nele troca `set N` por `min N`. Sem o ícone, o aviso aparece em
  `journalctl -u benjabreeze`. Se você quer "pelo menos N %, mas subindo quando
  precisar", use `min`.
- **`min N`** — velocidade mínima de trabalho. Fica em N % enquanto a temperatura está
  sob controle; se ela subir (troca para modo desempenho, carga pesada), acelera seguindo
  a curva `curve` até a temperatura cair e então volta aos N %. Ideal para quem gosta do
  notebook sempre frio sem o risco de ficar preso numa velocidade insuficiente.
  Exemplo com `min 40`:

  | Temperatura | 50 °C | 65 °C | 75 °C | 82 °C | esfriando até 50 °C |
  |---|---|---|---|---|---|
  | Velocidade | 40 % | 48 % | 65 % | 81 % | volta gradualmente a 40 % |

## Consumo de recursos e privacidade

- **Nada é gravado em disco.** Sem logs, sem histórico, sem cache. O único arquivo de
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
    "curve":  [[45, 25], [60, 40], [70, 55], [80, 75], [88, 100]],
    "silent": [[50, 15], [65, 30], [75, 45], [85, 70], [90, 100]]
  }
}
```

Cada ponto é `[temperatura °C, velocidade %]`. Você pode criar curvas novas e usá-las
com `benjabreeze <nome>`. A temperatura usada é a maior entre os sensores do `acer_wmi`
e o pacote da CPU (`coretemp`). `min_curve` define qual curva o modo `min` segue acima
do mínimo.

## Roadmap

Próximas versões, uma funcionalidade por release:

- **v0.7.0 — Relatório de compatibilidade**: `benjabreeze report` gera um texto com
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
- Pacotes `.deb` / AUR

## Contribuindo

Testou em outro modelo? Abra uma [issue](https://github.com/brcmesquita/benjabreeze/issues)
com o modelo (`cat /sys/class/dmi/id/product_name`), kernel (`uname -r`) e a saída de
`benjabreeze status`, dizendo se `benjabreeze max` mudou o RPM.

Histórico de versões: [CHANGELOG.md](CHANGELOG.md).

## Desinstalar

```sh
sudo sh uninstall.sh
```

## Aviso

Use por sua conta e risco. A proteção térmica do próprio hardware (throttling e
desligamento) continua ativa, mas curvas muito baixas podem deixar o notebook quente.

## Licença

[MIT](LICENSE)
