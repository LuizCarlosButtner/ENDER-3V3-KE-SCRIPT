#!/bin/sh

# --- DEFINIÇÃO DE CORES PARA O TERMINAL ---
VERDE='\033[0;32m'
AMARELO='\033[1;33m'
AZUL='\033[0;34m'
VERMELHO='\033[0;31m'
CIANO='\033[0;36m'
NC='\033[0m' # No Color (Reset)
NEGRITO='\033[1m'

# --- FUNÇÕES DE SUPORTE ---

executar_home() {
    echo -e "${AMARELO}>>> 2. RESETANDO E FAZENDO HOME (G28)...${NC}"
    echo "G28" > /tmp/printer
    # Aguarda 30s para garantir que o Home termine
    sleep 30
}

fazer_medicao() {
    X_VAL=$1
    Y_VAL=$2
    NOME_PONTO=$3

    echo -e "${CIANO}>>> POSICIONANDO NO $NOME_PONTO (X$X_VAL, Y$Y_VAL)...${NC}"
    # Levanta Z para 10mm (Segurança)
    echo "G1 Z10 F3000" > /tmp/printer
    # Move X e Y
    echo "G1 X$X_VAL Y$Y_VAL F6000" > /tmp/printer
    sleep 3

    echo -e "${AMARELO}>>> MEDINDO (PROBE)...${NC}"
    echo "PROBE" > /tmp/printer
    # Aguarda 5s para o sensor tocar
    sleep 5

    echo -e "${VERDE}---------------------------------------------------"
    echo -e "RESULTADO DA MEDIÇÃO NO $NOME_PONTO:"
    # Busca as últimas 20 linhas e filtra a última medição "probe at"
    tail -n 20 /usr/data/printer_data/logs/klippy.log | grep "probe at" | tail -n 1
    echo -e "---------------------------------------------------${NC}"
}

# --- INÍCIO DO PROGRAMA ---

echo -e "${VERDE}${NEGRITO}>>> 1. INICIANDO PROTOCOLO INTERATIVO...${NC}"
executar_home

ULTIMA_OPCAO=""

while true; do
    # Apresentação do Menu
    echo -e "\n${AZUL}=========================================${NC}"
    echo -e "${NEGRITO}      CONTROLO DE PROBE - ENDER 3 KE     ${NC}"
    echo -e "${AZUL}=========================================${NC}"
    echo -e "${AMARELO} 1)${NC} Ponto 1  (X5, Y-17)   ${AMARELO} 5)${NC} Ponto 5  (X215, Y-17)"
    echo -e "${AMARELO}21)${NC} Ponto 21 (X5, Y188)   ${AMARELO}25)${NC} Ponto 25 (X215, Y188)"
    echo -e "${AZUL}-----------------------------------------${NC}"
    echo -e "${CIANO} 0)   ${NC} Repetir G28 (Home)"
    echo -e "${VERMELHO} sair )${NC} Finalizar Script"
    echo -e "${AZUL}-----------------------------------------${NC}"
    
    # Pergunta ao utilizador
    if [ -z "$ULTIMA_OPCAO" ]; then
        echo -n -e "${NEGRITO}Qual o próximo passo? ${NC}"
    else
        echo -n -e "${NEGRITO}Qual o próximo passo? (Enter para repetir a medição ${AMARELO}$ULTIMA_OPCAO${NC}) ${NC}"
    fi
    read OPCAO

    # Se a opção for vazia, usa a última.
    if [ -z "$OPCAO" ]; then
        if [ -z "$ULTIMA_OPCAO" ]; then
            echo -e "${VERMELHO}Nenhuma medição anterior para repetir.${NC}"
            continue
        fi
        OPCAO=$ULTIMA_OPCAO
        echo -e "${AMARELO}>>> Repetindo a medição do ponto $OPCAO...${NC}"
    fi

    case $OPCAO in
        1)
            ULTIMA_OPCAO=$OPCAO
            fazer_medicao 5 -17 "PONTO 1"
            echo -e "${CIANO}>>> MESA EM POSIÇÃO DE DESCANSO (Y max, X min)...${NC}"
            # Levanta Z para 10mm (Segurança)
            echo "G1 Z10 F3000" > /tmp/printer
            # Move X para 0 e Y para 220
            echo "G1 X0 Y220 F6000" > /tmp/printer
            sleep 3
            ;;
        5)
            ULTIMA_OPCAO=$OPCAO
            fazer_medicao 215 -17 "PONTO 5"
            echo -e "${CIANO}>>> Movendo para posição de descanso (PONTO 25)...${NC}"
            echo "G1 Z10 F3000" > /tmp/printer
            echo "G1 X215 Y188 F6000" > /tmp/printer
            sleep 3
            ;;
        21)
            ULTIMA_OPCAO=$OPCAO
            fazer_medicao 5 188 "PONTO 21"
            echo -e "${CIANO}>>> Movendo para posição de descanso (PONTO 1)...${NC}"
            echo "G1 Z10 F3000" > /tmp/printer
            echo "G1 X5 Y-17 F6000" > /tmp/printer
            sleep 3
            ;;
        25)
            ULTIMA_OPCAO=$OPCAO
            fazer_medicao 215 188 "PONTO 25"
            echo -e "${CIANO}>>> Movendo para posição de descanso (PONTO 5)...${NC}"
            echo "G1 Z10 F3000" > /tmp/printer
            echo "G1 X215 Y-17 F6000" > /tmp/printer
            sleep 3
            ;;
        0)
            executar_home
            ;;
        sair)
            echo -e "${VERMELHO}A encerrar o script. Até logo!${NC}"
            break # Sai do loop while
            ;;
        *)
            echo -e "${VERMELHO}Opção inválida! Digite 1, 5, 21, 25, 0 ou sair.${NC}"
            ;;
    esac
done