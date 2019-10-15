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
		IMPORT  VarreTeclado
		IMPORT  IntTeclado
		IMPORT  DisplayMsg	
		IMPORT  ZeraTabs
		IMPORT  IniTabs
		IMPORT  setTeclado
		IMPORT  IniDisplay

; -------------------------------------------------------------------------------
; Fun��o main()
Start  			
	BL SysTick_Init
	BL GPIO_Init                 ;Chama a subrotina que inicializa os GPIO
	BL IniTabs
	BL IniDisplay
	MOV R10,#10
MainLoop
	
	BL VarreTeclado
	MOV R10,R3
	MOV R0,#20
	BL SysTick_Wait1ms
	BL VarreTeclado
	MOV R9, R3
	MOV R0,#20
	BL SysTick_Wait1ms
	BL VarreTeclado
	MOV R8, R3
	CMP R10,#10
	IT EQ
		BEQ Display
	CMP R10,R9
	IT NE
		BNE Display
	CMP R10,R8
	IT NE
		BNE Display
	MOV R10, R3
	BL setTeclado
	
Display
	BL DisplayMsg
	
	B MainLoop
	NOP
	
    ALIGN                        ;Garante que o fim da se��o est� alinhada 
    END                          ;Fim do arquivo
