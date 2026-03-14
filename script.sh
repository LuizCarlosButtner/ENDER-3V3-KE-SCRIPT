#!/bin/sh

# --- CONFIGURAÇÕES DE COORDENADAS ---
# Ponto 1: X5 Y-17 | Ponto 5: X215 Y-17 | Ponto 25: X215 Y188 | Ponto 21: X5 Y188

executar_home() {
    echo ">>> RESETANDO E FAZENDO HOME (G28)..."
    echo "G28" > /tmp/printer
    sleep 30
}

fazer_medicao() {
    X_VAL=$1
    Y_VAL=$2
    NOME_PONTO=$3

    echo ">>> MOVENDO PARA $NOME_PONTO (X$X_VAL, Y$Y_VAL)..."
    echo "G1 Z10 F3000" > /tmp/printer
    echo "G1 X$X_VAL Y$Y_VAL F6000" > /tmp/printer
    sleep 3

    echo ">>> MEDINDO (PROBE)..."
    echo "PROBE" > /tmp/printer
    sleep 5

    echo "--- RESULTADO DA MEDIÇÃO ---"
    tail -n 20 /usr/data/printer_data/logs/klippy.log | grep "probe at" | tail -n 1
    echo "----------------------------"
}

# --- INÍCIO DO PROTOCOLO ---
echo ">>> 1. INICIANDO PROTOCOLO INTERATIVO..."
executar_home

while true; do
    echo ""
    echo "Escolha uma opção:"
    echo "1) Ponto 1 (X5, Y-17)"
    echo "5) Ponto 5 (X215, Y-17)"
    echo "21) Ponto 21 (X5, Y188)"
    echo "25) Ponto 25 (X215, Y188)"
    echo "zerar) Repetir Home (G28)"
    echo "sair) Finalizar script"
    read -p "Comando: " OPCAO

    case $OPCAO in
        1)
            fazer_medicao 5 -17 "Ponto 1"
            ;;
        5)
            fazer_medicao 215 -17 "Ponto 5"
            ;;
        21)
            fazer_medicao 5 188 "Ponto 21"
            ;;
        25)
            fazer_medicao 215 188 "Ponto 25"
            ;;
        0)
            executar_home
            ;;
        sair)
            echo "Encerrando protocolo. Até à próxima!"
            break
            ;;
        *)
            echo "Opção inválida! Digite 1, 5, 21, 25, 0 para zerar ou sair."
            ;;
    esac
done