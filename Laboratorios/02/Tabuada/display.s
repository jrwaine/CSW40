GPIO_PORTK_DATA_R       EQU    0x400613FC
GPIO_PORTM_DATA_R       EQU    0x400633FC

; ENDEREÇOS DE MEMÓRIA DA TABUADA (contem os multiplicadores)
CONT_TAB1_ADDR			EQU 0x20000001
CONT_TAB2_ADDR			EQU 0x20000002
CONT_TAB3_ADDR			EQU 0x20000003
CONT_TAB4_ADDR			EQU 0x20000004
CONT_TAB5_ADDR			EQU 0x20000005
CONT_TAB6_ADDR			EQU 0x20000006
CONT_TAB7_ADDR			EQU 0x20000007
CONT_TAB8_ADDR			EQU 0x20000008
CONT_TAB9_ADDR			EQU 0x20000009
NUM_TAB_ADDR			EQU 0x2000000A ; numero da tabuada atual
RESULT_TAB_ADDR			EQU 0x2000000B ; resutlado da tabuada atual

		AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
			


		EXPORT DisplayMsg	
		EXPORT IniDisplay
		IMPORT SysTick_Wait1us

AtivaRS
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1,[R0]
	AND R1, #2_11111110
	ORR R1, #2_00000001
	STRB R1,[R0]
	BX LR

DesativaRS
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1,[R0]
	AND R1, #2_11111110
	ORR R1, #2_00000000
	STRB R1,[R0]
	BX LR

AtivaEnable
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1,[R0]
	AND R1, #2_11111011
	ORR R1, #2_00000100
	STRB R1,[R0]
	BX LR

DesativaEnable
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1,[R0]
	AND R1, #2_11111011
	ORR R1, #2_00000000
	STRB R1,[R0]
	BX LR

AtivaRW
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1,[R0]
	AND R1, #2_11111101
	ORR R1, #2_00000010
	STRB R1,[R0]
	BX LR
	
DesativaRW
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1,[R0]
	AND R1, #2_11111101
	ORR R1, #2_00000000
	STRB R1,[R0]
	BX LR

DesativaTudo
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1,[R0]
	AND R1, #2_11111000
	ORR R1, #2_00000000
	STRB R1,[R0]
	BX LR


; R1 eh caracter em ASC2
EscreveChar
	PUSH{LR}
	
	LDR R0,=GPIO_PORTK_DATA_R
	STRB R1,[R0]
	BL AtivaRS
	BL DesativaRW
	BL AtivaEnable
	MOV R0,#1000
	BL SysTick_Wait1us
	BL DesativaTudo
	MOV R0,#1000
	BL SysTick_Wait1us
	
	POP{PC}
	
LimpaDisplay
 	PUSH{LR}
	
	LDR R2, =GPIO_PORTK_DATA_R
	BL DesativaRS
	BL DesativaRW
	BL AtivaEnable
	
	;Limpar o display e levar o cursor para o home
	MOV R1,#0x01
	STR R1,[R2]
	BL DesativaEnable
	MOV R0, #80
	BL SysTick_Wait1us
	
	POP {PC}


IniDisplay
	PUSH {LR}
	LDR R2, =GPIO_PORTK_DATA_R
	
	BL DesativaRS
	BL DesativaRW
	BL AtivaEnable
	; Inicializar no modo 2 linhas / caractere matriz 5x7
	MOV R1, #0x38
	STR R1, [R2]
	BL DesativaEnable
	MOV R0, #80
	BL SysTick_Wait1us
	
	BL AtivaEnable
	; Cursor com autoincremento para direita
	MOV R1,#0x06
	STR R1,[R2]
	BL DesativaEnable
	MOV R0, #80
	BL SysTick_Wait1us
	
	BL AtivaEnable
	; Configurar o cursor (habilitar o display + cursor + não-pisca)
	MOV R1,#0x0E
	STR R1,[R2]
	BL DesativaEnable
	MOV R0, #80
	BL SysTick_Wait1us
	
	BL AtivaEnable
	;Limpar o display e levar o cursor para o home
	MOV R1,#0x01
	STR R1,[R2]
	BL DesativaEnable
	MOV R0, #80
	BL SysTick_Wait1us
	
	POP {PC}


DisplayMsg
	PUSH{LR}
	BL LimpaDisplay
	
	; Carrega o numero atual da tabuada
    LDR R0, =NUM_TAB_ADDR
    LDRB R1,[R0]
	; Carrega o resultado da tabela atual
	LDR R0, =RESULT_TAB_ADDR
	LDRB R2,[R0]
	; Calcula o multiplicador da tabela atual
	UDIV R3,R2,R1 ; R3 := R2/R1
	; Descobrir como faz o display...
	
	ADD R1,#48 ; '0' = 48
	BL EscreveChar
	MOV R1,#42 ; *
	BL EscreveChar
	
	MOV R1,R3
	ADD R1,#48 ; '0' = 48
	BL EscreveChar
	MOV R1,#61 ; =
	BL EscreveChar
	
	MOV R3,#10
	UDIV R4,R2,R3
	MOV R1,R4
	ADD R1,#48 ; '0' = 48
	BL EscreveChar
	
	MLS R1,R2,R3,R4
	ADD R1,#48 ; '0' = 48
	BL EscreveChar
	POP{PC}
	
	
	ALIGN
	END