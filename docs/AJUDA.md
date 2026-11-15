# Ajuda: como usar o BenjaBreeze

Este guia explica, passo a passo, como usar o BenjaBreeze no dia a dia. Para detalhes
técnicos, veja o [README](../README.md).

- [O que é](#o-que-é)
- [Antes de instalar](#antes-de-instalar)
- [Instalar](#instalar)
- [Primeiros passos](#primeiros-passos)
- [O ícone e suas cores](#o-ícone-e-suas-cores)
- [Escolhendo o modo certo](#escolhendo-o-modo-certo)
- [Ocultar o ícone x desligar o BenjaBreeze](#ocultar-o-ícone-x-desligar-o-benjabreeze)
- [Preferências: °C/°F e idioma](#preferências-cf-e-idioma)
- [Usando pelo terminal](#usando-pelo-terminal)
- [Perguntas frequentes](#perguntas-frequentes)
- [Algo deu errado](#algo-deu-errado)

---

## O que é

O BenjaBreeze controla as ventoinhas do seu notebook Acer Predator no Linux. Ele tem três
partes:

1. **O serviço** — roda em segundo plano desde o boot (antes até da tela de login) e é
   quem de fato muda a velocidade das ventoinhas.
2. **O ícone na bandeja** — mostra a temperatura e deixa você escolher o modo com cliques.
3. **O comando `benjabreeze`** — o mesmo controle, pelo terminal.

Por padrão, quem decide a velocidade é o **firmware da Acer** (modo Automático), igual a
quando o BenjaBreeze não está instalado. Nada muda até você escolher outro modo.

## Antes de instalar

O BenjaBreeze foi testado **somente** no Acer Predator Helios Neo 16 (PHN16-72) com
Kubuntu 26.04.1 LTS e kernel 7.0. Em outros modelos e sistemas ele **pode** funcionar,
mas é **por sua conta e risco**.

Para saber se o seu notebook tem a interface necessária, abra um terminal e rode:

```sh
ls $(dirname $(grep -l acer /sys/class/hwmon/hwmon*/name))
```

Se aparecerem `pwm1` e `pwm2` na lista, o seu kernel permite controlar as ventoinhas.
Se der erro ou não aparecerem, o BenjaBreeze não vai funcionar no seu notebook.

## Instalar

1. Baixe o arquivo `.deb` da
   [última versão](https://github.com/brcmesquita/benjabreeze/releases/latest).
2. Abra um terminal na pasta onde ele foi salvo (geralmente `Downloads`) e rode:
   ```sh
   sudo apt install ./benjabreeze_*_all.deb
   ```
3. Pronto. O ícone aparece na bandeja (perto do relógio). Se não aparecer, procure
   **BenjaBreeze** no menu de aplicativos.

> No KDE, ícones novos às vezes ficam escondidos na setinha **^** da bandeja. Para
> deixá-lo sempre visível: clique com o botão direito na setinha → *Configurar bandeja
> do sistema* → *Entradas* → **BenjaBreeze** → *Sempre exibido*.

## Primeiros passos

Clique no ícone. O menu mostra:

| Parte do menu | O que é |
|---|---|
| BenjaBreeze 0.x | nome e versão |
| CPU / Máx. sensores | temperatura do processador e a mais alta entre os sensores |
| Ventoinhas | velocidade das duas ventoinhas (CPU / GPU), em RPM |
| Modo | o modo em uso agora |
| Automático, Máximo, Velocidade mínima, Velocidade fixa | os modos (o ativo fica marcado) |
| Unidade de temperatura, Idioma | preferências |
| Ocultar ícone, Desligar BenjaBreeze | veja [abaixo](#ocultar-o-ícone-x-desligar-o-benjabreeze) |

Teste rápido: escolha **Máximo (100%)** — as ventoinhas devem acelerar em poucos
segundos. Depois volte para **Automático**.

## O ícone e suas cores

O número no ícone é a temperatura mais alta do notebook. A cor muda conforme o calor,
como num mapa do tempo:

| Cor | Temperatura | Significado |
|---|---|---|
| azul-marinho | abaixo de 30 °C | nevasca |
| azul | 30–39 °C | frio |
| ciano | 40–49 °C | fresco |
| verde | 50–59 °C | confortável |
| verde-limão | 60–69 °C | morno |
| amarelo | 70–79 °C | quente |
| laranja | 80–84 °C | muito quente |
| vermelho | 85–91 °C | perigo |
| vermelho-escuro com borda amarela | 92 °C ou mais | vulcão — ventoinhas no máximo automaticamente |

Usar o notebook entre verde e amarelo é normal. Jogos e tarefas pesadas costumam levar
ao laranja.

## Escolhendo o modo certo

| Modo | Como funciona | Quando usar |
|---|---|---|
| **Automático (firmware Acer)** | A Acer decide, como sem o BenjaBreeze | Na dúvida, use este |
| **Velocidade mínima** (ex. 40%) | Nunca abaixo de 40%. Se esquentar, acelera sozinho e depois volta aos 40% | Se você gosta do notebook mais frio, sem risco |
| **Velocidade fixa** (ex. 50%) | Fica sempre em 50%, não importa a temperatura | Situações específicas, por pouco tempo |
| **Máximo (100%)** | Tudo no máximo | Antes de uma tarefa muito pesada, ou para esfriar rápido |

**Mínima ou fixa?** Prefira a **mínima**. Na fixa, se você esquecer e começar um jogo, a
ventoinha não acelera (só a partir de 92 °C). Por isso, na fixa, quando a temperatura
passa de 85 °C, o BenjaBreeze mostra um aviso — clique nele para trocar para a mínima
com o mesmo valor.

Valores fora do menu (ex. 45%) podem ser escolhidos pelo terminal:
`benjabreeze min 45` ou `benjabreeze set 45`.

**Proteção:** em qualquer modo do BenjaBreeze, a partir de 92 °C as ventoinhas vão a
100%. E o próprio processador tem proteção de hardware: se esquentar demais, ele reduz o
desempenho ou desliga antes de se danificar.

## Ocultar o ícone x desligar o BenjaBreeze

| Opção | O que acontece com as ventoinhas | Como voltar |
|---|---|---|
| **Ocultar ícone** | Nada muda: o BenjaBreeze continua controlando no modo escolhido | Abra **BenjaBreeze** no menu de aplicativos |
| **Desligar BenjaBreeze** | Voltam ao controle do firmware da Acer (pede sua senha; uma notificação confirma) | Reinicie o computador ou abra o BenjaBreeze no menu de aplicativos — ele volta de onde parou |

O modo escolhido é lembrado: depois de reiniciar, o BenjaBreeze continua no mesmo modo.

Abrir o BenjaBreeze pelo menu quando ele já está aberto não cria outro ícone — só aparece
o aviso "já está aberto".

## Preferências: °C/°F e idioma

- **Unidade de temperatura:** Celsius ou Fahrenheit. A cor do ícone segue a mesma escala.
- **Idioma:** português, inglês, espanhol, alemão, francês, russo, japonês, coreano,
  chinês tradicional e chinês simplificado. "Automático" segue o idioma do sistema.

As duas escolhas ficam salvas e valem também para o terminal.

## Usando pelo terminal

| Comando | O que faz |
|---|---|
| `benjabreeze status` | mostra temperaturas, ventoinhas e modo |
| `benjabreeze watch` | o mesmo, atualizando a cada segundo (Ctrl+C para sair) |
| `benjabreeze auto` | automático (firmware Acer) |
| `benjabreeze max` | 100% |
| `benjabreeze min 40` | velocidade mínima de 40% |
| `benjabreeze set 50` | velocidade fixa de 50% |
| `benjabreeze unit F` | temperaturas em Fahrenheit (`unit C` volta) |
| `benjabreeze lang en_US` | idioma (`benjabreeze lang` lista os códigos) |
| `benjabreeze --version` | versão instalada |

Nenhum desses comandos precisa de `sudo`.

## Perguntas frequentes

**O BenjaBreeze controla as ventoinhas antes do login (tela do SDDM)?**
Sim. O serviço inicia no boot, antes da tela de login, já no último modo escolhido. Só o
ícone é que aparece depois do login.

**Ele deixa o notebook mais lento ou gasta bateria?**
Não de forma perceptível. O serviço usa cerca de 13 MB de memória e quase nada de
processador; no modo Automático ele nem lê os sensores. Não grava logs nem histórico.

**Ele envia dados para algum lugar?**
Não. Não há rede, telemetria ou coleta de dados.

**Posso deixar em Velocidade mínima o tempo todo?**
Pode. É o modo pensado para isso: fica no valor escolhido e acelera sozinho se precisar.

**Por que não existe um modo "automático do BenjaBreeze"?**
Porque o automático mais seguro, por enquanto, é o da própria Acer. Um automático do
BenjaBreeze só virá quando houver dados reais medidos em cada modelo (veja o roadmap no
[README](../README.md#roadmap)).

## Algo deu errado

**O ícone mostra "?" ou "serviço parado".**
O serviço não está rodando. Use **Ligar BenjaBreeze** no menu, ou no terminal:
`sudo systemctl start benjabreeze`.

**As ventoinhas não mudam de velocidade.**
Rode `benjabreeze status`: se a ventoinha mostra `firmware`, o modo é Automático. Se mostra
`manual` e o RPM não muda, o seu modelo pode não aceitar o controle — veja
[Antes de instalar](#antes-de-instalar).

**Quero voltar tudo ao normal da Acer.**
Escolha **Automático**, ou **Desligar BenjaBreeze**. Para remover de vez:
`sudo apt remove benjabreeze`.

**Encontrei um problema ou testei em outro modelo.**
Abra uma [issue](https://github.com/brcmesquita/benjabreeze/issues) com o modelo
(`cat /sys/class/dmi/id/product_name`), o kernel (`uname -r`) e a saída de
`benjabreeze status`.
