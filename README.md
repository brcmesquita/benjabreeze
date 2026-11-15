# BenjaBreeze

Controle de ventoinhas para notebooks **Acer Predator** no Linux, usando apenas o driver
`acer_wmi` que já vem no kernel — **sem módulo de kernel extra, sem compilar nada**.

*Fan control for Acer Predator laptops on Linux using only the in-kernel `acer_wmi`
hwmon interface (no out-of-tree modules). Simple daemon + CLI + KDE/Qt tray icon.*

> Projeto independente, sem afiliação com a Acer. *Acer* e *Predator* são marcas
> da Acer Inc., citadas apenas para indicar compatibilidade.

## Recursos

- Modos: `auto` (firmware Acer), `curve`, `silent`, `max` e velocidade fixa
- Curvas temperatura → velocidade configuráveis, com histerese (evita sobe-e-desce)
- Ícone na bandeja mostrando a temperatura, com menu para trocar de modo
- Segurança: acima de 92 °C (configurável) força 100 %; se o serviço parar ou falhar,
  o controle volta ao firmware
- Trocar de modo não exige sudo
- Python puro (o ícone usa PyQt6)

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
Outros modelos com a mesma interface devem funcionar — relatos são bem-vindos.

## Instalação

```sh
git clone https://github.com/brcmesquita/benjabreeze.git
cd benjabreeze
sudo sh install.sh
```

O padrão após instalar é `auto`: nada muda até você escolher outro modo.

## Uso

| Comando | Efeito |
|---|---|
| `benjabreeze status` | temperaturas, RPM e modo |
| `benjabreeze watch` | status atualizando a cada segundo |
| `benjabreeze auto` | controle do firmware Acer |
| `benjabreeze curve` | curva normal |
| `benjabreeze silent` | curva silenciosa |
| `benjabreeze max` | 100 % |
| `benjabreeze set 60` | fixo em 60 % (proteção de 92 °C continua ativa) |

Ícone na bandeja: `benjabreeze-tray` (ou "BenjaBreeze" no menu; inicia no login).

O modo volta ao `default_mode` a cada boot.

## Configuração

`/etc/benjabreeze.json` (recarregado automaticamente):

```json
{
  "interval": 2.0,
  "hysteresis": 4,
  "panic_temp": 92,
  "default_mode": "auto",
  "curves": {
    "curve":  [[45, 25], [60, 40], [70, 55], [80, 75], [88, 100]],
    "silent": [[50, 15], [65, 30], [75, 45], [85, 70], [90, 100]]
  }
}
```

Cada ponto é `[temperatura °C, velocidade %]`. Você pode criar curvas novas e usá-las
com `benjabreeze <nome>`. A temperatura usada é a maior entre os sensores do `acer_wmi`
e o pacote da CPU (`coretemp`).

## Desinstalar

```sh
sudo sh uninstall.sh
```

## Aviso

Use por sua conta e risco. A proteção térmica do próprio hardware (throttling e
desligamento) continua ativa, mas curvas muito baixas podem deixar o notebook quente.

## Licença

MIT
