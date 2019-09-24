; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Rev1: 10/03/2018
; Rev2: 10/04/2019
; Este programa espera o usuário apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usuário pressione a chave USR_SW1, acenderá o LED3 (PF4). Caso o usuário pressione 
; a chave USR_SW2, acenderá o LED4 (PF0). Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.

; -------------------------------------------------------------------------------
        THUMB                        ; Instruções do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declarações EQU - Defines
;<NOME>         EQU <VALOR>
; ========================


; -------------------------------------------------------------------------------
; Área de Dados - Declarações de variáveis
		AREA  DATA, ALIGN=2
		; Se alguma variável for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a variável <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma variável de nome <var>
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
		IMPORT  GPIO_Init
        IMPORT  PortF_Output
        IMPORT  PortJ_Input
		IMPORT  WrtDig
		IMPORT  SetTrans
		IMPORT 	SysTick_Wait1ms
		IMPORT 	SysTick_Init
; -------------------------------------------------------------------------------
; Função main()
Start  			
	BL SysTick_Init
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	MOV R5,#1
	MOV R6,#0
MainLoop
	BL PortJ_Input				 ;Chama a subrotina que lê o estado das chaves e coloca o resultado em R0
	
Verifica_Nenhuma
	CMP	R0, #2_00000011			 ;Verifica se nenhuma chave está pressionada
	BNE Verifica_SW1			 ;Se o teste viu que tem pelo menos alguma chave pressionada pula
	B Passo					 	 ;Se o teste viu que nenhuma chave está pressionada, volta para o laço principal
Verifica_SW1	
	CMP R0, #2_00000010			 ;Verifica se somente a chave SW1 está pressionada
	BNE Verifica_SW2             ;Se o teste falhou, pula
	ADD R5,R5,#1
	B Passo                   ;Volta para o laço principal
Verifica_SW2	
	CMP R0, #2_00000001			 ;Verifica se somente a chave SW2 está pressionada
	BNE Verifica_Ambas           ;Se o teste falhou, pula
	SUB R5,R5,#1
	B Passo                   ;Volta para o laço principal	
Verifica_Ambas
	B Passo			 ;Chamar a função para não acender nenhum LED

Passo
	CMP R5,#10
	IT EQ
		MOVEQ R5,#9
	CMP R5,#0
	IT EQ
		MOVEQ R5,#1
	ADD R6,R6,R5
	CMP R6,#100
	IT GE
		SUBGE R6,R6,#100
	MOV R7,#0
	
Display
; escreve digito mais significativo
	MOV R4, R6
	MOV R10,#10
	UDIV R4,R4,R10
	BL WrtDig
	
	MOV R4,#2_00000000
	MOV R3,#2_00010000
	BL SetTrans
	MOV R0,#2
	BL SysTick_Wait1ms
	
; escreve digito menos significativo	
	MOV R4, R6
	MOV R10,#10
	UDIV R4,R4,R10
	MLS R4,R10,R4,R6
	BL WrtDig
	
	MOV R4,#2_00000000
	MOV R3,#2_00100000
	BL SetTrans
	
	MOV R0,#2
	BL SysTick_Wait1ms
	ADD R7,#1
	CMP R7,#100
	IT EQ
		BEQ MainLoop
	B Display                   ;Volta para o laço principal	
	BEQ MainLoop
	NOP
	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
