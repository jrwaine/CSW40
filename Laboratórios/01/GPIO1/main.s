; main.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; Rev1: 10/03/2018
; Rev2: 10/04/2019
; Este programa espera o usu�rio apertar a chave USR_SW1 e/ou a chave USR_SW2.
; Caso o usu�rio pressione a chave USR_SW1, acender� o LED3 (PF4). Caso o usu�rio pressione 
; a chave USR_SW2, acender� o LED4 (PF0). Caso as duas chaves sejam pressionadas, os dois 
; LEDs acendem.

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
;<NOME>         EQU <VALOR>
; ========================


; -------------------------------------------------------------------------------
; �rea de Dados - Declara��es de vari�veis
		AREA  DATA, ALIGN=2
		; Se alguma vari�vel for chamada em outro arquivo
		;EXPORT  <var> [DATA,SIZE=<tam>]   ; Permite chamar a vari�vel <var> a 
		                                   ; partir de outro arquivo
;<var>	SPACE <tam>                        ; Declara uma vari�vel de nome <var>
                                           ; de <tam> bytes a partir da primeira 
                                           ; posi��o da RAM		

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT Start                ; Permite chamar a fun��o Start a partir de 
			                        ; outro arquivo. No caso startup.s
									
		; Se chamar alguma fun��o externa	
        ;IMPORT <func>              ; Permite chamar dentro deste arquivo uma 
									; fun��o <func>
		IMPORT  GPIO_Init
        IMPORT  PortF_Output
        IMPORT  PortJ_Input
		IMPORT  WrtDig
		IMPORT  SetTrans
		IMPORT 	SysTick_Wait1ms
		IMPORT 	SysTick_Init
; -------------------------------------------------------------------------------
; Fun��o main()
Start  			
	BL SysTick_Init
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	MOV R5,#1
	MOV R6,#0
MainLoop
	BL PortJ_Input				 ;Chama a subrotina que l� o estado das chaves e coloca o resultado em R0
	
Verifica_Nenhuma
	CMP	R0, #2_00000011			 ;Verifica se nenhuma chave est� pressionada
	BNE Verifica_SW1			 ;Se o teste viu que tem pelo menos alguma chave pressionada pula
	B Passo					 	 ;Se o teste viu que nenhuma chave est� pressionada, volta para o la�o principal
Verifica_SW1	
	CMP R0, #2_00000010			 ;Verifica se somente a chave SW1 est� pressionada
	BNE Verifica_SW2             ;Se o teste falhou, pula
	ADD R5,R5,#1
	B Passo                   ;Volta para o la�o principal
Verifica_SW2	
	CMP R0, #2_00000001			 ;Verifica se somente a chave SW2 est� pressionada
	BNE Verifica_Ambas           ;Se o teste falhou, pula
	SUB R5,R5,#1
	B Passo                   ;Volta para o la�o principal	
Verifica_Ambas
	B Passo			 ;Chamar a fun��o para n�o acender nenhum LED

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
	B Display                   ;Volta para o la�o principal	
	BEQ MainLoop
	NOP
	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
