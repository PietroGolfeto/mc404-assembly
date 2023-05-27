# Pietro Grazzioli Golfeto
# RA 223694

# Dicionário que mapeia os registradores com os nomes
registradores = {
    "zero": 0,
    "ra": 1,
    "sp": 2,
    "gp": 3,
    "tp": 4,
    "t0": 5,
    "t1": 6,
    "t2": 7,
    "s0": 8,
    "s1": 9,
}
for i in range(8):
    registradores[f"a{i}"] = 10 + i
for i in range(10):
    registradores[f"s{i + 2}"] = 18 + i
for i in range(4):
    registradores[f"t{i + 3}"] = 28 + i


def instrucao_I(lista):
    match lista[0]:
        case "addi":
            func3 = "000"
            opcode = "0010011"
        case "slli":
            func3 = "001"
            opcode = "0010011"
        case "lw":
            func3 = "010"
            opcode = "0000011"
        case "ret":
            # Implementação de jalr ( jalr zero, 0(ra) )
            return instrucao_I(["jalr", "zero", "ra", "0"])
        case "jalr":
            func3 = "000"
            opcode = "1100111"

    # Imediato é o terceiro elemento da lista exceto se for lw    
    num_decimal = int(lista[3]) if lista[3].isdigit() else int(lista[2])
    # Converte em hexadecimal e adiciona prefixo 0x
    num_hex = "0x" + format(num_decimal, "03x").upper()

    rd_string = lista[1]
    rd = format(registradores[rd_string], "05b")

    rs1_string = lista[2] if lista[3].isdigit() else lista[3]
    rs1 = format(registradores[rs1_string], "05b")

    final_string = rs1 + func3 + rd + opcode
    final_hex = hex(int(final_string, 2))

    # Completa com zeros à esquerda para ter 8 caracteres (3 do num_hex + 5 do final_hex)
    # Coloca em maiusculo, exceto o prefixo 0x
    final = final_hex[2:].zfill(5).upper()
    return num_hex + final


def instrucao_R(lista):
    opcode = "0110011"
    match lista[0]:
        case "xor":
            func3 = "100"
            funct7 = "0000000"
        case "mul":
            func3 = "000"
            funct7 = "0000001"

    rd_string = lista[1]
    rd = format(registradores[rd_string], "05b")

    rs1_string = lista[2]
    rs1 = format(registradores[rs1_string], "05b")

    rs2_string = lista[3]
    rs2 = format(registradores[rs2_string], "05b")

    # Formatação da instrução do tipo R em binário em Assembly Risc-V
    final_string = funct7 + rs2 + rs1 + func3 + rd + opcode
    final_hex = hex(int(final_string, 2))
    # Completa com zeros à esquerda para ter 8 caracteres
    # Coloca em maiusculo, exceto o prefixo 0x
    final = final_hex[:2] + final_hex[2:].zfill(8).upper()

    return final


def instrucao_S(lista):
    match lista[0]:
        case "sw":
            func3 = "010"
            opcode = "0100011"

    num_decimal = int(lista[2])
    # Converte em binário utilizando complemento de dois com 12 bits
    tamanho = 12
    num_bin = format(num_decimal & ((1 << tamanho) - 1), f"0{tamanho}b").zfill(tamanho)

    # Divide o número binário em dois imediatos, um de 7 bits e outro de 5 bits
    imm7 = num_bin[:7]
    imm5 = num_bin[7:]

    rs2_string = lista[1]
    rs2 = format(registradores[rs2_string], "05b")

    rs1_string = lista[3]
    rs1 = format(registradores[rs1_string], "05b")

    # Formatação da instrução do tipo S em binário em Assembly Risc-V
    final_string = imm7 + rs2 + rs1 + func3 + imm5 + opcode
    final_hex = hex(int(final_string, 2))

    # Completa com zeros à esquerda para ter 8 caracteres
    # Coloca em maiusculo, exceto o prefixo 0x
    final = final_hex[:2] + final_hex[2:].zfill(8).upper()
    return final


def instrucao_SB(lista):
    match lista[0]:
        case "beq":
            func3 = "000"
            opcode = "1100011"
    
    rs1_string = lista[1]
    rs1 = format(registradores[rs1_string], "05b")

    rs2_string = lista[2]
    rs2 = format(registradores[rs2_string], "05b")

    pos_inicial = 1000
    num_decimal = int(lista[3])
    offset = num_decimal - pos_inicial

    # Converte em binário utilizando complemento de dois com 13 bits
    tamanho = 13
    num_bin = format(offset & ((1 << tamanho) - 1), f"0{tamanho}b").zfill(tamanho)

    # Divide o número binário em quatro imediatos, dois de 1 bit, um de 6 bits e um de 4 bits
    # Ignora o bit menos significativo (não utilizado em instruções do tipo SB)
    imm12 = num_bin[0]
    imm11 = num_bin[1]
    imm10_5 = num_bin[2:8]
    imm4_1 = num_bin[8:12]

    # Formatação da instrução do tipo B em binário em Assembly Risc-V
    final_string = imm12 + imm10_5 + rs2 + rs1 + func3 + imm4_1 + imm11 + opcode
    final_hex = hex(int(final_string, 2))

    # Completa com zeros à esquerda para ter 8 caracteres
    # Coloca em maiusculo, exceto o prefixo 0x
    final = final_hex[:2] + final_hex[2:].zfill(8).upper()
    return final


def instrucao_U(lista):
    match lista[0]:
        case "lui":
            opcode = "0110111"
        case "auipc":
            opcode = "0010111"

    num_decimal = int(lista[2])
    # Converte em binário utilizando complemento de dois com 20 bits
    tamanho = 20
    imm20 = format(num_decimal & ((1 << tamanho) - 1), f"0{tamanho}b").zfill(tamanho)

    rd_string = lista[1]
    rd = format(registradores[rd_string], "05b")

    # Formatação da instrução do tipo U em binário em Assembly Risc-V
    final_string = imm20 + rd + opcode
    final_hex = hex(int(final_string, 2))

    # Completa com zeros à esquerda para ter 8 caracteres
    # Coloca em maiusculo, exceto o prefixo 0x
    final = final_hex[:2] + final_hex[2:].zfill(8).upper()
    return final


def instrucao_J(lista):
    match lista[0]:
        case "call":
            pass

    # Instrução call é composta por duas instruções: auipc e jalr
    pos_inicial = 1000
    num_decimal = int(lista[1])

    offset = num_decimal - pos_inicial
    # Converte em binário utilizando complemento de dois com 32 bits
    tamanho = 32
    num_bin = format(offset & ((1 << tamanho) - 1), f"0{tamanho}b").zfill(tamanho)

    # Divide o número binário em dois imediatos, um de 20 bits e outro de 12 bits
    imm20 = num_bin[:20]
    # Transforma imm20 em string representando inteiro de base dez no argumento da instrução auipc
    # Primeira instrução de call é auipc 
    # Simulador Venus utliza o registrador t1 para armazenar o endereço de salto
    auipc = mapa["auipc"](["auipc", "t1", str(int(imm20, 2))])

    imm12 = num_bin[20:]
    # Segunda instrução de call é jalr
    # Transforma imm12 em string representando inteiro de base dez no argumento da instrução jalr
    # Endereço de salto é o armazenado no registrador t1 somado ao imediato de 12 bits
    # Registrador ra é utilizado para armazenar o endereço de retorno
    jalr = mapa["jalr"](["jalr", "ra", "t1", str(int(imm12, 2))])

    return auipc + "\n" + jalr


def instrucao_dupla(lista):
    match lista[0]:
        case "li":
            pass
    
    # Instrução li pode ser composta por duas instruções, dependendo do tamanho do imediato
    # Se o imediato for maior que 12 signed bits, é necessário também utilizar a instrução lui
    # Caso contrário, apenas a instrução addi é necessária
    num_decimal = int(lista[2])
    if (num_decimal > ((1 << 11) - 1) or num_decimal < -2048):
        # Converte em binário utilizando complemento de dois com 32 bits
        tamanho = 32
        num_bin = format(num_decimal & ((1 << tamanho) - 1), f"0{tamanho}b").zfill(tamanho)

        # Divide o número binário em dois imediatos, um de 20 bits e outro de 12 bits
        imm20 = num_bin[:20]
        # Transforma imm20 em string representando inteiro de base dez no argumento da instrução lui
        lui = mapa["lui"](["lui", "t1", str(int(imm20, 2))])

        imm12 = num_bin[20:]
        # Transforma imm12 em string representando inteiro de base dez no argumento da instrução addi
        addi = mapa["addi"](["addi", lista[1], "t1", str(int(imm12, 2))])

        return lui + "\n" + addi
    else:
        # Transforma num_decimal em string representando inteiro de base dez no argumento da instrução addi
        addi = mapa["addi"](["addi", lista[1], "zero", str(num_decimal)])

        return addi


# Dicionario que mapeia as instrucoes para as funcoes
mapa = {
    "addi": instrucao_I, #OK
    "slli": instrucao_I, #OK
    "xor": instrucao_R, #OK
    "call": instrucao_J, #OK
    "ret": instrucao_I, #jalr #OK
    "jalr": instrucao_I, #OK
    "beq": instrucao_SB, #OK
    "lw": instrucao_I, #OK
    "sw": instrucao_S, #OK
    "mul": instrucao_R, #OK
    "lui": instrucao_U, #OK
    "auipc": instrucao_U, #OK
    "li": instrucao_dupla # FALTA EXTENSÃO DE SINAL QUANDO QUEBRAR EM 2 INSTRUÇÕES
    # SE BIT 12 FOR 1, EXTENSÃO DE SINAL
}


instrucao = input("Digite a instrução desejada: ")
while (instrucao != ""):
    lista = instrucao.replace(",", "").replace("(", " ").replace(")", "").split()
    print(lista)

    if lista[0] in mapa:
        funcoes = mapa[lista[0]]
        codigo = funcoes(lista)
        print(codigo)

    else:
        "Instrução inválida"

    instrucao = input("Digite a instrução desejada: ")
