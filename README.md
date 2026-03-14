# Script de Nivelamento para Ender 3 V3 KE com Klipper

Este repositório contém scripts de shell para auxiliar no processo de nivelamento da mesa da impressora 3D Creality Ender 3 V3 KE, especialmente após modificações no hardware que exigem um ajuste manual mais frequente.

## Motivação

Após obter acesso root na impressora, a primeira grande modificação foi a substituição das sapatas rígidas da mesa por sapatas de silicone. Essa alteração, juntamente com a adição de knobs de ajuste manual, introduziu a necessidade de um método de nivelamento que fosse mais prático e rápido do que o ciclo padrão de 25 pontos oferecido pelo firmware original.

O objetivo foi criar uma ferramenta que permitisse medir a altura de pontos específicos (os quatro cantos da mesa) e, em seguida, mover a mesa para uma posição confortável, facilitando o acesso e o ajuste dos knobs sem a necessidade de navegar por múltiplos menus na tela da impressora.

## Funcionalidades

- **Nivelamento Interativo:** Um menu simples permite escolher qual dos quatro cantos da mesa você deseja medir.
- **Comandos Diretos:** Os scripts enviam comandos G-code diretamente para o Klipper através do arquivo `/tmp/printer`.
- **Posição de Ajuste:** Após cada medição, o bico e a mesa são movidos para uma posição que facilita o acesso ao knob correspondente, agilizando o processo de ajuste.
- **Feedback Imediato:** O resultado da medição do probe (sensor de nivelamento) é exibido diretamente no terminal. Caso você queira ajustar de novo o mesmo ponto é so apertar enter que ele mede o ponto novamente.

- **hotentacao NERD:** depois que eu implementei isso só trabalho com nivel "0.0 pra cima THEYYYY 😎 😎 😎"

## Pré-requisitos

- **Acesso Root:** É fundamental ter acesso root à sua Ender 3 V3 KE, pois os scripts precisam de permissão para escrever no arquivo `/tmp/printer`.
- **Conhecimento Básico de Shell:** Para executar os scripts via SSH.

## Como Usar

1.  Conecte-se à sua impressora via SSH.
2.  Navegue até o diretório onde os scripts estão localizados.
3.  Dê permissão de execução aos scripts: `chmod +x script.sh script_2.sh`.
4.  Execute o script desejado:
    -   Para a versão simples: `./script.sh`
    -   Para a versão melhorada: `./script_2.sh`
5.  Siga as instruções no menu para Homing, selecionar os pontos e ajustar a mesa.

## Descrição dos Scripts

### `script.sh`

Esta é a primeira versão, mais básica. Ela oferece as funcionalidades essenciais:

- Menu para selecionar um dos quatro cantos (pontos 1, 5, 21, 25).
- Função para fazer o "Homing" (G28).
- Medição com o `PROBE` e exibição do resultado.

### `script_2.sh`

Esta é a versão refinada e recomendada para uso. Além de todas as funcionalidades do primeiro script, ela adiciona:

- **Interface Colorida:** Utiliza cores para melhorar a legibilidade do menu e dos status.
- **Repetir Última Ação:** Permite repetir a última medição apenas pressionando `Enter`, tornando o ajuste fino muito mais rápido.
- **Posições de Descanso Inteligentes:** Após medir um ponto, a mesa se move para uma posição estratégica para facilitar o ajuste do knob correspondente. Por exemplo, após medir um canto frontal, ela se move para a parte de trás, dando espaço para sua mão.
- **Menu Mais Detalhado:** A interface do menu é mais organizada e visualmente agradável.
