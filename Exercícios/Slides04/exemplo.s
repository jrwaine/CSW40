; Exemplo.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 12/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
        AREA  DATA, ALIGN=2
        ; Se alguma variável for chamada em outro arquivo
        ;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
                                           ; partir de outro arquivo
;<var>    SPACE <tam>                        ; Declara uma variável de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posição da RAM        

; -------------------------------------------------------------------------------
; Área de Código - Tudo abaixo da diretiva a seguir será armazenado na memória de 
;                  código
        AREA    |.text|, CODE, READONLY, ALIGN=2

        ; Se alguma função do arquivo for chamada em outro arquivo    
        EXPORT Start                ; Permite chamar a função Start a partir de 
                                    ; outro arquivo. No caso startup.s
                                    
        ; Se chamar alguma função externa    
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
                                    ; função <func>

; -------------------------------------------------------------------------------
; Função main()
Start  
; Comece o código aqui <======================================================
    ; Exercícios memória/transferência ;
    MOV R0,#65              ; R0 := 65 
    MOV R1,#0x1B00
    MOVT R1,#0x1B00         ; R1 := 0x1B00 1B00
    MOV R2,#0x5678
    MOVT R2,#0x1234         ; R2 := 0x1234 5678
    MOV R12,#0
    MOVT R12,#0x2000        ; 0x2000 0000 (endereço)
    STR R0,[R12,#0x40]      ; [R12+0x40] := R0
    STR R1,[R12,#0x44]      ; [R12+0x44] := R1
    STR R2,[R12,#0x48]      ; [R12+0x48] := R2 
    MOV R3,#1
    MOVT R3,#0xF            ; R3 := 0xF0001
    STR R3,[R12,#0x4C]      ; [R12+0x4C] := R3
    MOV R4,#0xCD            ; R4 := 0xCD
    STRB R4,[R12,#0x46]     ; [R12+0x46] := R4
    LDR R7,[R12,#0x40]      ; R7 := [R12+0x40]
    LDR R8,[R12,#0x48]      ; R8 := [R12+0x48]
    MOV R9,R7               ; R9 := R7
    
    ; Exercícios operações lógicas ;
    MOV R12,#0xF0           ; R12 := 0xF0
    ANDS R0,R12,#2_01010101 ; R0 := R12 & 0b01010101
    MOV R12,#2_11001100     ; R12 := 0b11001100
    ANDS R1,R12,#2_00110011 ; R1 := R12 & 0b00110011
    MOV R12,#2_10000000     ; R12 := 0b10000000
    ORRS R2,R12,#2_00110111 ; R2 := R12 & 0b00110111
    MOV R12,#0xABCD
    MOVT R12,#0xABCD        ; R12 := 0xABCDABCD
    MOV R11,#0xFFFF         ; R11 := 0x0000FFFF
    BICS R3,R12,R11         ; R3 := R12 & (~R11)
    
    ; Exercícios operações de deslocamento ;
    MOV R12,#701            ; R12 := 701
    MOV R11,#32067
    NEG R11,R11             ; R11 := -32067
    MOV R10,#255            ; R10 := 255
    MOV R9,#0xE666            
    NEG R9,R9               ; R9 := -58982
    LSRS R0,R12,#5          ; R0 := R12 >> 5
    LSRS R1,R11,#4          ; R1 := R11 >> 4
    ASRS R2,R12,#3          ; R2 := R12 >> 3
    ASRS R3,R11,#5          ; R3 := R11 >> 5
    LSLS R4,R10,#8          ; R4 := R10 << 8
    LSLS R5,R9,#18          ; R5 := R9 << 18
    MOV R12,#0x1234
    MOVT R12,#0xFABC        ; R12 := 0xFABC1234
    ROR R6,R12,#10          ; R6 := ROR(R12,10)
    MOV R12,#0x4321         ; R12 := 0x00004321
    RRX R7,R12              ; R7 := RRX(R12)
    RRX R7,R7               ; R7 := RRX(R7)
    
    ; Exercícios operações aritméticas ;
    MOV R12,#101            ; R12 := 101
    ADDS R0,R12,#253        ; R0 := R12+253
    MOV R12,#40543          ; R12 := 40543
    ADD R1,R12,#1500        ; R1 := R12+1500
    MOV R12,#340            ; R12 := 340
    SUBS R2,R12,#123        ; R2 := R12-123
    MOV R12,#1000           ; R12 := 1000
    SUBS R3,R12,#2000       ; R3 := R12-2000
    MOV R12,#54378          ; R12 := 54378
    LSLS R4,R12,#3          ; R4 := R12<<3 = R12*4
    MOV R12,#0x3344
    MOVT R12,#0x1122        ; R12 := 0x11223344
    MOV R11,#0x2211
    MOVT R11,#0x4433        ; R11 := 0x44332211
    SMULL R5,R6,R12,R11     ; R5(rl),R6(rh) := R12*R11
    MOV R12,#0x7560
    MOVT R12,#0xFFFF        ; R12 := 0xFFFF7560
    MOV R11,#1000           ; R11 := 1000
    SDIV R7,R12,R11         ; R7 := ((signed)R12)/R11
    UDIV R8,R12,R11         ; R8 := ((unsigned)R12)/R11
    
    
    NOP
    ALIGN                   ; garante que o fim da seção está alinhada 
    END                     ; fim do arquivo
