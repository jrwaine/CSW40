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
		IMPORT  VarreTeclado
		IMPORT  IntTeclado
		IMPORT  DisplayMsg	
		IMPORT  ZeraTabs
		IMPORT  IniTabs
		IMPORT  setTeclado
		IMPORT  IniDisplay

; -------------------------------------------------------------------------------
; Função main()
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
	
    ALIGN                        ;Garante que o fim da seção está alinhada 
    END                          ;Fim do arquivo
