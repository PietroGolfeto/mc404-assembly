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
    # 223694
    call Dois
    li a0, 50
    call Pausa

    call Dois
    li a0, 50
    call Pausa

    call Tres  
    li a0, 50  
    call Pausa

    call Seis  
    li a0, 50  
    call Pausa

    call Nove  
    li a0, 50  
    call Pausa

    call Quatro
    li a0, 50    
    call Pausa

    # Usa mascara de 16 bits para representar movimento
    # Comeca tudo escondido na esquerda
    # Faz 2 for, um pra carregar na esquerda e outro pra direita
    # Usa um registrador pra fazer o offset do shift
    # Em cada linha a cada iteracao, faz and com offset e depois carrega de novo o valor da memoria pra voltar pro normal
    # Atualiza o offset a cada iteracao
    # Faz shift pra esquerda para mostrar digitos uma coluna por vez

fimMain:
addi a0, zero, 10
ecall   # Encerra a execução do programa

Imprime_tela:
    addi sp, sp, -12
    sw s0, 0(sp)
    sw s1, 4(sp)
    sw s2, 8(sp)
    # a0 recebe o endereço do primeiro elemento do array
    mv t0, a0

    li s0, 16
    for_movimento_direita:  
        li s1, 11 # imprime comecando na ultima linha e diminuindo (para nao ficar de cabeca para baixo)      
        imprime_direita:
            # carrega conteudo da linha em a2
            # a1 é linha atual
            lhu a2, 0(t0)
            srl a2, a2, s0

            li a0, 0x110
            mv a1, s1
            ecall

            addi t0, t0, 2
            addi s1, s1, -1
            bgt s1, zero, imprime_direita

        addi t0, t0, -22 # Volta pro inicio do vetor
        addi s0, s0, -1
        bgt s0, zero, for_movimento_direita

    li s0, 0
    li s2, 16
    for_movimento_esquerda:
        li s1, 11
        imprime_esquerda:
            # carrega conteudo da linha em a2
            # a1 é linha atual
            lhu a2, 0(t0)
            sll a2, a2, s0

            li a0, 0x110
            mv a1, s1
            ecall

            addi t0, t0, 2
            addi s1, s1, -1
            bgt s1, zero, imprime_esquerda

        addi t0, t0, -22 # Volta pro inicio do vetor
        addi s0, s0, 1
        blt s0, s2, for_movimento_esquerda

    addi sp, sp, 12
    lw s2, 8(sp)
    lw s1, 4(sp)
    lw s0, 0(sp)
    ret
# Executa n vezes o loop; n armazenado em a0
Pausa:
    # Pilha armazena endereco de retorno
    addi sp, sp, -8
    sw   s0, 4(sp)
    sw ra, 0(sp)
    mv s0, a0

    contador_pausa:
        addi s0, s0, -1
        bne s0, zero, contador_pausa

    #la a0, pausa

    #call Imprime_tela

    # Recupera endereco de retorno da pilha
    lw ra, 0(sp)
    lw s0, 4(sp)
    addi sp, sp, 8
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
