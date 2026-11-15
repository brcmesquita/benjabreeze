# predator-fan

Controle de ventoinhas para notebooks **Acer Predator** no Linux, usando apenas o driver
`acer_wmi` que já vem no kernel — **sem módulo de kernel extra, sem compilar nada**.

*Fan control for Acer Predator laptops on Linux using only the in-kernel `acer_wmi`
hwmon interface (no out-of-tree modules). Simple daemon + CLI.*

## Recursos

- Modos: `auto` (firmware Acer), `curve`, `silent`, `max` e velocidade fixa
- Curvas temperatura → velocidade configuráveis, com histerese (evita sobe-e-desce)
- Segurança: acima de 92 °C (configurável) força 100 %; se o serviço parar ou falhar,
  o controle volta ao firmware
- Trocar de modo não exige sudo
- Python puro, sem dependências

## Requisitos

- Kernel com suporte a ventoinhas no `acer_wmi` (hwmon com `pwm1`/`pwm1_enable`).
  Confira:
  ```sh
  grep -l acer /sys/class/hwmon/hwmon*/name   # deve existir
  ls $(dirname $(grep -l acer /sys/class/hwmon/hwmon*/name))   # deve listar pwm1, pwm2
  ```
- Python 3, systemd

Testado em: **Predator Helios Neo 16 (PHN16-72)**, Kubuntu, kernel 7.0.
Outros modelos com a mesma interface devem funcionar — relatos são bem-vindos.

## Instalação

```sh
git clone https://github.com/brcmesquita/predator-fan.git
cd predator-fan
sudo sh install.sh
```

O padrão após instalar é `auto`: nada muda até você escolher outro modo.

## Uso

| Comando | Efeito |
|---|---|
| `predator-fan status` | temperaturas, RPM e modo |
| `predator-fan watch` | status atualizando a cada segundo |
| `predator-fan auto` | controle do firmware Acer |
| `predator-fan curve` | curva normal |
| `predator-fan silent` | curva silenciosa |
| `predator-fan max` | 100 % |
| `predator-fan set 60` | fixo em 60 % (proteção de 92 °C continua ativa) |

O modo volta ao `default_mode` a cada boot.

## Configuração

`/etc/predator-fan.json` (recarregado automaticamente):

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
com `predator-fan <nome>`. A temperatura usada é a maior entre os sensores do `acer_wmi`
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
