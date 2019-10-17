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
	; R0: contador de memória ;
	; R1: valor de memória 1 ;
	; R2: valor de memória 2 ;
	; R3: flag trocou ;
	; R4: valor maximo de R0;
	; R5: tamanho do vetor;
	; R12: valor aux ;
	
	MOV R5, #10
	SUB R5, #1
	MOV R4, #0x0500
	MOVT R4, #0x2000
	MOV R12, #4
	STRB R12,[R4,#0]
	MOV R12, #5
	STRB R12,[R4,#1]
	MOV R12, #8
	STRB R12,[R4,#2]
	MOV R12, #2
	STRB R12,[R4,#3]
	MOV R12, #3
	STRB R12,[R4,#4]
	MOV R12, #1
	STRB R12,[R4,#5]
	MOV R12, #7
	STRB R12,[R4,#6]
	MOV R12, #15
	STRB R12,[R4,#7]
	MOV R12, #0
	STRB R12,[R4,#8]
	MOV R12, #9
	STRB R12,[R4,#9]
	ADD R4, R5
ini
	MOV R0, #0x0500
	MOVT R0, #0x2000
	MOV R3, #0
loop
	LDRB R1,[R0]
	LDRB R2,[R0,#1]
	MOV R12, R2
	CMP R1, R2
	ITT HI
		MOVHI R2, R1
		MOVHI R1, R12
		MOVHI R3, #1
	STRB R1,[R0]
	STRB R2,[R0,#1]!
	CMP R0,R4
	IT LO
		BLO loop
	CMP R3,#1
	IT EQ
		BEQ ini
	

fim
    NOP
    ALIGN                   ; garante que o fim da seção está alinhada 
    END                     ; fim do arquivo
