.data
# Cada digito eh representado por um array de 12 shorts (12x16)
    pausa:
        .half 0x00000000
        .half 0x00000000
        .half 0x00000000
        .half 0x00000000
        .half 0x00000000
        .half 0x00000000
        .half 0x00000000
        .half 0x00000000
        .half 0x00000000
        .half 0x00000000
        .half 0x00000000
        .half 0x00000000

    dois: 
        .half 0b0000011100000000
        .half 0b0000110110000000
        .half 0b0001100011000000
        .half 0b0001100001000000
        .half 0b0000000011000000
        .half 0b0000000110000000
        .half 0b0000001100000000
        .half 0b0000011000000000
        .half 0b0000110000000000
        .half 0b0001100000000000
        .half 0b0001111111000000
        .half 0b0000000000000000

    tres:
        .half 0b0000011100000000
        .half 0b0000110110000000
        .half 0b0001100011000000
        .half 0b0001100001000000
        .half 0b0000000011000000
        .half 0b0000000110000000
        .half 0b0000000110000000
        .half 0b0000000011000000
        .half 0b0001100001000000
        .half 0b0001100011000000
        .half 0b0000110110000000
        .half 0b0000011100000000

    quatro:
        .half 0b0000000011000000
        .half 0b0000000111000000
        .half 0b0000001011000000
        .half 0b0000010011000000
        .half 0b0000100011000000
        .half 0b0001000011000000
        .half 0b0001111111110000
        .half 0b0000000011000000
        .half 0b0000000011000000
        .half 0b0000000011000000
        .half 0b0000000011000000
        .half 0b0000000000000000

    seis:
        .half 0b0000000111110000
        .half 0b0000001111110000
        .half 0b0000011100011000
        .half 0b0000011000000000
        .half 0b0000111000000000
        .half 0b0000111111000000
        .half 0b0001100001100000
        .half 0b0001100001100000
        .half 0b0000100001000000
        .half 0b0000110111000000
        .half 0b0000011110000000
        .half 0b0000000000000000

    nove:
        .half 0b0000001100000000
        .half 0b0000011110000000
        .half 0b0000110011000000
        .half 0b0001100001100000
        .half 0b0001100001100000
        .half 0b0000110011100000
        .half 0b0000011111100000
        .half 0b0000001100100000
        .half 0b0000000001100000
        .half 0b0001100011100000
        .half 0b0001111111000000
        .half 0b0000000000000000

.text
# Use Risc-V assembly language
main:
    # Tamanho do display
    li s0, 12
    li s1, 16

    # 223694
    call Dois
    li a0, 2000
    call Pausa

    call Dois
    li a0, 2000
    call Pausa

    call Tres  
    li a0, 2000  
    call Pausa

    call Seis  
    li a0, 2000  
    call Pausa

    call Nove  
    li a0, 2000  
    call Pausa

    call Quatro
    li a0, 2000    
    call Pausa

    # Usa mascara para representar movimento
    # Vai de coluna em coluna trocando por zero ate limpar a tela

fimMain:
addi a0, zero, 10
ecall   # Encerra a execução do programa

Imprime_tela:
    # a0 recebe o endereço do primeiro elemento do array
    mv t0, a0
    li a0, 0x110
    li a1, 0

    imprime:
        # carrega conteudo da linha em a2
        lh a2, 0(t0)
        addi t0, t0, 2

        ecall
        # a1 é linha atual, s0 é numero de linhas declarado na main
        addi a1, a1, 1
        blt a1, s0, imprime
    ret
# Executa n vezes o loop; n armazenado em a0
Pausa:
    # Pilha armazena endereco de retorno
    addi sp, sp, -4
    sw ra, 0(sp)

    mv t1, a0
    la a0, pausa

    call Imprime_tela

    contador_pausa:
        addi t1, t1, -1
        addi zero, zero, 0        

        bne t1, zero, contador_pausa

    # Recupera endereco de retorno da pilha
    lw ra, 0(sp)
    addi sp, sp, 4
    ret

Dois:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0, dois
    call Imprime_tela

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

Tres:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0, tres
    call Imprime_tela

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

Quatro:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0, quatro
    call Imprime_tela

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

Seis:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0, seis
    call Imprime_tela

    lw ra, 0(sp)
    addi sp, sp, 4
    ret

Nove:
    addi sp, sp, -4
    sw ra, 0(sp)

    la a0, nove
    call Imprime_tela

    lw ra, 0(sp)
    addi sp, sp, 4
    ret