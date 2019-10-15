; gpio.s
; Desenvolvido para a placa EK-TM4C1294XL
; Prof. Guilherme Peron
; 19/03/2018

; -------------------------------------------------------------------------------
        THUMB                        ; Instru��es do tipo Thumb-2
; -------------------------------------------------------------------------------
; Declara��es EQU - Defines
; ========================
; Defini��es de Valores
BIT0	EQU 2_00000001
BIT1	EQU 2_00000010
BIT2	EQU 2_00000100
BIT3	EQU 2_00001000
BIT4	EQU 2_00010000
BIT5	EQU 2_00100000
BIT6	EQU 2_01000000
BIT7	EQU 2_10000000	
; ========================
; Defini��es dos Registradores Gerais
SYSCTL_RCGCGPIO_R	 EQU	0x400FE608
SYSCTL_PRGPIO_R		 EQU    0x400FEA08
; ========================
; Defini��es dos Ports
; PORT A
GPIO_PORTA_AHB_DATA_BITS_R EQU    0x40058000
GPIO_PORTA_AHB_DATA_R   EQU    0x400583FC
GPIO_PORTA_AHB_DIR_R    EQU    0x40058400
GPIO_PORTA_AHB_IS_R     EQU    0x40058404
GPIO_PORTA_AHB_IBE_R    EQU    0x40058408
GPIO_PORTA_AHB_IEV_R    EQU    0x4005840C
GPIO_PORTA_AHB_IM_R     EQU    0x40058410
GPIO_PORTA_AHB_RIS_R    EQU    0x40058414
GPIO_PORTA_AHB_MIS_R    EQU    0x40058418
GPIO_PORTA_AHB_ICR_R    EQU    0x4005841C
GPIO_PORTA_AHB_AFSEL_R  EQU    0x40058420
GPIO_PORTA_AHB_DR2R_R   EQU    0x40058500
GPIO_PORTA_AHB_DR4R_R   EQU    0x40058504
GPIO_PORTA_AHB_DR8R_R   EQU    0x40058508
GPIO_PORTA_AHB_ODR_R    EQU    0x4005850C
GPIO_PORTA_AHB_PUR_R    EQU    0x40058510
GPIO_PORTA_AHB_PDR_R    EQU    0x40058514
GPIO_PORTA_AHB_SLR_R    EQU    0x40058518
GPIO_PORTA_AHB_DEN_R    EQU    0x4005851C
GPIO_PORTA_AHB_LOCK_R   EQU    0x40058520
GPIO_PORTA_AHB_CR_R     EQU    0x40058524
GPIO_PORTA_AHB_AMSEL_R  EQU    0x40058528
GPIO_PORTA_AHB_PCTL_R   EQU    0x4005852C
GPIO_PORTA_AHB_ADCCTL_R EQU    0x40058530
GPIO_PORTA_AHB_DMACTL_R EQU    0x40058534
GPIO_PORTA_AHB_SI_R     EQU    0x40058538
GPIO_PORTA_AHB_DR12R_R  EQU    0x4005853C
GPIO_PORTA_AHB_WAKEPEN_R EQU    0x40058540
GPIO_PORTA_AHB_WAKELVL_R EQU    0x40058544
GPIO_PORTA_AHB_WAKESTAT_R EQU    0x40058548
GPIO_PORTA_AHB_PP_R     EQU    0x40058FC0
GPIO_PORTA_AHB_PC_R     EQU    0x40058FC4
GPIO_PORTA              EQU    2_000000000000001
; PORT B
GPIO_PORTB_AHB_DATA_BITS_R EQU    0x40059000
GPIO_PORTB_AHB_DATA_R   EQU    0x400593FC
GPIO_PORTB_AHB_DIR_R    EQU    0x40059400
GPIO_PORTB_AHB_IS_R     EQU    0x40059404
GPIO_PORTB_AHB_IBE_R    EQU    0x40059408
GPIO_PORTB_AHB_IEV_R    EQU    0x4005940C
GPIO_PORTB_AHB_IM_R     EQU    0x40059410
GPIO_PORTB_AHB_RIS_R    EQU    0x40059414
GPIO_PORTB_AHB_MIS_R    EQU    0x40059418
GPIO_PORTB_AHB_ICR_R    EQU    0x4005941C
GPIO_PORTB_AHB_AFSEL_R  EQU    0x40059420
GPIO_PORTB_AHB_DR2R_R   EQU    0x40059500
GPIO_PORTB_AHB_DR4R_R   EQU    0x40059504
GPIO_PORTB_AHB_DR8R_R   EQU    0x40059508
GPIO_PORTB_AHB_ODR_R    EQU    0x4005950C
GPIO_PORTB_AHB_PUR_R    EQU    0x40059510
GPIO_PORTB_AHB_PDR_R    EQU    0x40059514
GPIO_PORTB_AHB_SLR_R    EQU    0x40059518
GPIO_PORTB_AHB_DEN_R    EQU    0x4005951C
GPIO_PORTB_AHB_LOCK_R   EQU    0x40059520
GPIO_PORTB_AHB_CR_R     EQU    0x40059524
GPIO_PORTB_AHB_AMSEL_R  EQU    0x40059528
GPIO_PORTB_AHB_PCTL_R   EQU    0x4005952C
GPIO_PORTB_AHB_ADCCTL_R EQU    0x40059530
GPIO_PORTB_AHB_DMACTL_R EQU    0x40059534
GPIO_PORTB_AHB_SI_R     EQU    0x40059538
GPIO_PORTB_AHB_DR12R_R  EQU    0x4005953C
GPIO_PORTB_AHB_WAKEPEN_R EQU    0x40059540
GPIO_PORTB_AHB_WAKELVL_R   EQU    0x40059544
GPIO_PORTB_AHB_WAKESTAT_R  EQU    0x40059548
GPIO_PORTB_AHB_PP_R     EQU    0x40059FC0
GPIO_PORTB_AHB_PC_R     EQU    0x40059FC4
GPIO_PORTB              EQU    2_000000000000010
; PORT F
GPIO_PORTF_AHB_LOCK_R    	EQU    0x4005D520
GPIO_PORTF_AHB_CR_R      	EQU    0x4005D524
GPIO_PORTF_AHB_AMSEL_R   	EQU    0x4005D528
GPIO_PORTF_AHB_PCTL_R    	EQU    0x4005D52C
GPIO_PORTF_AHB_DIR_R     	EQU    0x4005D400
GPIO_PORTF_AHB_AFSEL_R   	EQU    0x4005D420
GPIO_PORTF_AHB_DEN_R     	EQU    0x4005D51C
GPIO_PORTF_AHB_PUR_R     	EQU    0x4005D510	
GPIO_PORTF_AHB_DATA_R    	EQU    0x4005D3FC
GPIO_PORTF               	EQU    2_000000000100000
; PORT J
GPIO_PORTJ_AHB_LOCK_R    	EQU    0x40060520
GPIO_PORTJ_AHB_CR_R      	EQU    0x40060524
GPIO_PORTJ_AHB_AMSEL_R   	EQU    0x40060528
GPIO_PORTJ_AHB_PCTL_R    	EQU    0x4006052C
GPIO_PORTJ_AHB_DIR_R     	EQU    0x40060400
GPIO_PORTJ_AHB_AFSEL_R   	EQU    0x40060420
GPIO_PORTJ_AHB_DEN_R     	EQU    0x4006051C
GPIO_PORTJ_AHB_PUR_R     	EQU    0x40060510	
GPIO_PORTJ_AHB_DATA_R    	EQU    0x400603FC
GPIO_PORTJ               	EQU    2_000000100000000
; PORT K
GPIO_PORTK_DATA_BITS_R  EQU    0x40061000
GPIO_PORTK_DATA_R       EQU    0x400613FC
GPIO_PORTK_DIR_R        EQU    0x40061400
GPIO_PORTK_IS_R         EQU    0x40061404
GPIO_PORTK_IBE_R        EQU    0x40061408
GPIO_PORTK_IEV_R        EQU    0x4006140C
GPIO_PORTK_IM_R         EQU    0x40061410
GPIO_PORTK_RIS_R        EQU    0x40061414
GPIO_PORTK_MIS_R        EQU    0x40061418
GPIO_PORTK_ICR_R        EQU    0x4006141C
GPIO_PORTK_AFSEL_R      EQU    0x40061420
GPIO_PORTK_DR2R_R       EQU    0x40061500
GPIO_PORTK_DR4R_R       EQU    0x40061504
GPIO_PORTK_DR8R_R       EQU    0x40061508
GPIO_PORTK_ODR_R        EQU    0x4006150C
GPIO_PORTK_PUR_R        EQU    0x40061510
GPIO_PORTK_PDR_R        EQU    0x40061514
GPIO_PORTK_SLR_R        EQU    0x40061518
GPIO_PORTK_DEN_R        EQU    0x4006151C
GPIO_PORTK_LOCK_R       EQU    0x40061520
GPIO_PORTK_CR_R         EQU    0x40061524
GPIO_PORTK_AMSEL_R      EQU    0x40061528
GPIO_PORTK_PCTL_R       EQU    0x4006152C
GPIO_PORTK_ADCCTL_R     EQU    0x40061530
GPIO_PORTK_DMACTL_R     EQU    0x40061534
GPIO_PORTK_SI_R         EQU    0x40061538
GPIO_PORTK_DR12R_R      EQU    0x4006153C
GPIO_PORTK_WAKEPEN_R    EQU    0x40061540
GPIO_PORTK_WAKELVL_R    EQU    0x40061544
GPIO_PORTK_WAKESTAT_R   EQU    0x40061548
GPIO_PORTK_PP_R         EQU    0x40061FC0
GPIO_PORTK_PC_R         EQU    0x40061FC4
GPIO_PORTK              EQU    2_000001000000000
; PORT L
GPIO_PORTL_DATA_BITS_R  EQU    0x40062000
GPIO_PORTL_DATA_R       EQU    0x400623FC
GPIO_PORTL_DIR_R        EQU    0x40062400
GPIO_PORTL_IS_R         EQU    0x40062404
GPIO_PORTL_IBE_R        EQU    0x40062408
GPIO_PORTL_IEV_R        EQU    0x4006240C
GPIO_PORTL_IM_R         EQU    0x40062410
GPIO_PORTL_RIS_R        EQU    0x40062414
GPIO_PORTL_MIS_R        EQU    0x40062418
GPIO_PORTL_ICR_R        EQU    0x4006241C
GPIO_PORTL_AFSEL_R      EQU    0x40062420
GPIO_PORTL_DR2R_R       EQU    0x40062500
GPIO_PORTL_DR4R_R       EQU    0x40062504
GPIO_PORTL_DR8R_R       EQU    0x40062508
GPIO_PORTL_ODR_R        EQU    0x4006250C
GPIO_PORTL_PUR_R        EQU    0x40062510
GPIO_PORTL_PDR_R        EQU    0x40062514
GPIO_PORTL_SLR_R        EQU    0x40062518
GPIO_PORTL_DEN_R        EQU    0x4006251C
GPIO_PORTL_LOCK_R       EQU    0x40062520
GPIO_PORTL_CR_R         EQU    0x40062524
GPIO_PORTL_AMSEL_R      EQU    0x40062528
GPIO_PORTL_PCTL_R       EQU    0x4006252C
GPIO_PORTL_ADCCTL_R     EQU    0x40062530
GPIO_PORTL_DMACTL_R     EQU    0x40062534
GPIO_PORTL_SI_R         EQU    0x40062538
GPIO_PORTL_DR12R_R      EQU    0x4006253C
GPIO_PORTL_WAKEPEN_R    EQU    0x40062540
GPIO_PORTL_WAKELVL_R    EQU    0x40062544
GPIO_PORTL_WAKESTAT_R   EQU    0x40062548
GPIO_PORTL_PP_R         EQU    0x40062FC0
GPIO_PORTL_PC_R         EQU    0x40062FC4
GPIO_PORTL              EQU    2_000010000000000
; PORT M
GPIO_PORTM_DATA_BITS_R  EQU    0x40063000
GPIO_PORTM_DATA_R       EQU    0x400633FC
GPIO_PORTM_DIR_R        EQU    0x40063400
GPIO_PORTM_IS_R         EQU    0x40063404
GPIO_PORTM_IBE_R        EQU    0x40063408
GPIO_PORTM_IEV_R        EQU    0x4006340C
GPIO_PORTM_IM_R         EQU    0x40063410
GPIO_PORTM_RIS_R        EQU    0x40063414
GPIO_PORTM_MIS_R        EQU    0x40063418
GPIO_PORTM_ICR_R        EQU    0x4006341C
GPIO_PORTM_AFSEL_R      EQU    0x40063420
GPIO_PORTM_DR2R_R       EQU    0x40063500
GPIO_PORTM_DR4R_R       EQU    0x40063504
GPIO_PORTM_DR8R_R       EQU    0x40063508
GPIO_PORTM_ODR_R        EQU    0x4006350C
GPIO_PORTM_PUR_R        EQU    0x40063510
GPIO_PORTM_PDR_R        EQU    0x40063514
GPIO_PORTM_SLR_R        EQU    0x40063518
GPIO_PORTM_DEN_R        EQU    0x4006351C
GPIO_PORTM_LOCK_R       EQU    0x40063520
GPIO_PORTM_CR_R         EQU    0x40063524
GPIO_PORTM_AMSEL_R      EQU    0x40063528
GPIO_PORTM_PCTL_R       EQU    0x4006352C
GPIO_PORTM_ADCCTL_R     EQU    0x40063530
GPIO_PORTM_DMACTL_R     EQU    0x40063534
GPIO_PORTM_SI_R         EQU    0x40063538
GPIO_PORTM_DR12R_R      EQU    0x4006353C
GPIO_PORTM_WAKEPEN_R    EQU    0x40063540
GPIO_PORTM_WAKELVL_R    EQU    0x40063544
GPIO_PORTM_WAKESTAT_R   EQU    0x40063548
GPIO_PORTM_PP_R         EQU    0x40063FC0
GPIO_PORTM_PC_R         EQU    0x40063FC4
GPIO_PORTM              EQU    2_000100000000000
; PORT P
GPIO_PORTP_DATA_BITS_R  EQU    0x40065000
GPIO_PORTP_DATA_R       EQU    0x400653FC
GPIO_PORTP_DIR_R        EQU    0x40065400
GPIO_PORTP_IS_R         EQU    0x40065404
GPIO_PORTP_IBE_R        EQU    0x40065408
GPIO_PORTP_IEV_R        EQU    0x4006540C
GPIO_PORTP_IM_R         EQU    0x40065410
GPIO_PORTP_RIS_R        EQU    0x40065414
GPIO_PORTP_MIS_R        EQU    0x40065418
GPIO_PORTP_ICR_R        EQU    0x4006541C
GPIO_PORTP_AFSEL_R      EQU    0x40065420
GPIO_PORTP_DR2R_R       EQU    0x40065500
GPIO_PORTP_DR4R_R       EQU    0x40065504
GPIO_PORTP_DR8R_R       EQU    0x40065508
GPIO_PORTP_ODR_R        EQU    0x4006550C
GPIO_PORTP_PUR_R        EQU    0x40065510
GPIO_PORTP_PDR_R        EQU    0x40065514
GPIO_PORTP_SLR_R        EQU    0x40065518
GPIO_PORTP_DEN_R        EQU    0x4006551C
GPIO_PORTP_LOCK_R       EQU    0x40065520
GPIO_PORTP_CR_R         EQU    0x40065524
GPIO_PORTP_AMSEL_R      EQU    0x40065528
GPIO_PORTP_PCTL_R       EQU    0x4006552C
GPIO_PORTP_ADCCTL_R     EQU    0x40065530
GPIO_PORTP_DMACTL_R     EQU    0x40065534
GPIO_PORTP_SI_R         EQU    0x40065538
GPIO_PORTP_DR12R_R      EQU    0x4006553C
GPIO_PORTP_WAKEPEN_R    EQU    0x40065540
GPIO_PORTP_WAKELVL_R    EQU    0x40065544
GPIO_PORTP_WAKESTAT_R   EQU    0x40065548
GPIO_PORTP_PP_R         EQU    0x40065FC0
GPIO_PORTP_PC_R         EQU    0x40065FC4
GPIO_PORTP              EQU    2_010000000000000
; PORT Q
GPIO_PORTQ_DATA_BITS_R  EQU    0x40066000
GPIO_PORTQ_DATA_R       EQU    0x400663FC
GPIO_PORTQ_DIR_R        EQU    0x40066400
GPIO_PORTQ_IS_R         EQU    0x40066404
GPIO_PORTQ_IBE_R        EQU    0x40066408
GPIO_PORTQ_IEV_R        EQU    0x4006640C
GPIO_PORTQ_IM_R         EQU    0x40066410
GPIO_PORTQ_RIS_R        EQU    0x40066414
GPIO_PORTQ_MIS_R        EQU    0x40066418
GPIO_PORTQ_ICR_R        EQU    0x4006641C
GPIO_PORTQ_AFSEL_R      EQU    0x40066420
GPIO_PORTQ_DR2R_R       EQU    0x40066500
GPIO_PORTQ_DR4R_R       EQU    0x40066504
GPIO_PORTQ_DR8R_R       EQU    0x40066508
GPIO_PORTQ_ODR_R        EQU    0x4006650C
GPIO_PORTQ_PUR_R        EQU    0x40066510
GPIO_PORTQ_PDR_R        EQU    0x40066514
GPIO_PORTQ_SLR_R        EQU    0x40066518
GPIO_PORTQ_DEN_R        EQU    0x4006651C
GPIO_PORTQ_LOCK_R       EQU    0x40066520
GPIO_PORTQ_CR_R         EQU    0x40066524
GPIO_PORTQ_AMSEL_R      EQU    0x40066528
GPIO_PORTQ_PCTL_R       EQU    0x4006652C
GPIO_PORTQ_ADCCTL_R     EQU    0x40066530
GPIO_PORTQ_DMACTL_R     EQU    0x40066534
GPIO_PORTQ_SI_R         EQU    0x40066538
GPIO_PORTQ_DR12R_R      EQU    0x4006653C
GPIO_PORTQ_WAKEPEN_R    EQU    0x40066540
GPIO_PORTQ_WAKELVL_R    EQU    0x40066544
GPIO_PORTQ_WAKESTAT_R   EQU    0x40066548
GPIO_PORTQ_PP_R         EQU    0x40066FC0
GPIO_PORTQ_PC_R         EQU    0x40066FC4
GPIO_PORTQ              EQU    2_100000000000000

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
NUM_TAB_ADDR			EQU 0x20000050 ; numero da tabuada atual
RESULT_TAB_ADDR			EQU 0x20000058 ; resutlado da tabuada atual

; -------------------------------------------------------------------------------
; �rea de C�digo - Tudo abaixo da diretiva a seguir ser� armazenado na mem�ria de 
;                  c�digo
        AREA    |.text|, CODE, READONLY, ALIGN=2

		; Se alguma fun��o do arquivo for chamada em outro arquivo	
        EXPORT GPIO_Init            ; Permite chamar GPIO_Init de outro arquivo
		EXPORT PortF_Output			; Permite chamar PortN_Output de outro arquivo
		EXPORT PortJ_Input          ; Permite chamar PortJ_Input de outro arquivo
		EXPORT WrtDig
		EXPORT SetTrans
		EXPORT VarreTeclado
		EXPORT IntTeclado
		EXPORT DisplayMsg	
		EXPORT ZeraTabs
		EXPORT IniTabs
		EXPORT setTeclado
		EXPORT IniDisplay
		IMPORT SysTick_Wait1us
	

;--------------------------------------------------------------------------------
; Fun��o GPIO_Init
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: N�o tem
GPIO_Init
;=====================
; 1. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO,
; ap�s isso verificar no PRGPIO se a porta est� pronta para uso.
; enable clock to GPIOF at clock gating register
            LDR     R0, =SYSCTL_RCGCGPIO_R  		;Carrega o endere�o do registrador RCGCGPIO
			MOV		R1, #GPIO_PORTA                 ;Seta o bit da porta A
			ORR     R1, #GPIO_PORTJ					
			ORR     R1, #GPIO_PORTP					
			ORR		R1, #GPIO_PORTQ
			ORR		R1, #GPIO_PORTK
			ORR		R1, #GPIO_PORTL
			ORR		R1, #GPIO_PORTM
            STR     R1, [R0]						;Move para a mem�ria os bits das portas no endere�o do RCGCGPIO
 
            LDR     R0, =SYSCTL_PRGPIO_R			;Carrega o endere�o do PRGPIO para esperar os GPIO ficarem prontos
EsperaGPIO  LDR     R1, [R0]						;L� da mem�ria o conte�do do endere�o do registrador
			MOV		R2, #GPIO_PORTA                 ;Seta o bit da porta A
			ORR     R2, #GPIO_PORTJ
			ORR     R2, #GPIO_PORTP					
			ORR		R2, #GPIO_PORTQ
			ORR		R2, #GPIO_PORTK
			ORR		R2, #GPIO_PORTL
			ORR		R2, #GPIO_PORTM              
            TST     R1, R2							;ANDS de R1 com R2
            BEQ     EsperaGPIO					    ;Se o flag Z=1, volta para o la�o. Sen�o continua executando
 
; 2. Limpar o AMSEL para desabilitar a anal�gica
            MOV     R1, #0x00						;Colocar 0 no registrador para desabilitar a fun��o anal�gica
            LDR     R0, =GPIO_PORTA_AHB_AMSEL_R     ;Carrega o R0 com o endere�o do AMSEL para a porta A
            STR     R1, [R0]						;Guarda no registrador AMSEL da porta A da mem�ria
            LDR     R0, =GPIO_PORTJ_AHB_AMSEL_R     
            STR     R1, [R0]												
            LDR     R0, =GPIO_PORTK_AMSEL_R		
            STR     R1, [R0]		
            LDR     R0, =GPIO_PORTL_AMSEL_R		
            STR     R1, [R0]		
            LDR     R0, =GPIO_PORTM_AMSEL_R		
            STR     R1, [R0]
			LDR     R0, =GPIO_PORTP_AMSEL_R     
            STR     R1, [R0]				
            LDR     R0, =GPIO_PORTQ_AMSEL_R		
            STR     R1, [R0]					    
			
; 3. Limpar PCTL para selecionar o GPIO
            MOV     R1, #0x00					    ;Colocar 0 no registrador para selecionar o modo GPIO
            LDR     R0, =GPIO_PORTA_AHB_PCTL_R		
            STR     R1, [R0]                        
            LDR     R0, =GPIO_PORTJ_AHB_PCTL_R		;Carrega o R0 com o endere�o do PCTL para a porta J
            STR     R1, [R0]                        ;Guarda no registrador PCTL da porta J da mem�ria       
            LDR     R0, =GPIO_PORTK_PCTL_R      
            STR     R1, [R0]        
            LDR     R0, =GPIO_PORTL_PCTL_R      
            STR     R1, [R0]        
            LDR     R0, =GPIO_PORTM_PCTL_R      
            STR     R1, [R0] 
			LDR     R0, =GPIO_PORTP_PCTL_R		
            STR     R1, [R0]                        
            LDR     R0, =GPIO_PORTQ_PCTL_R      
            STR     R1, [R0] 
				
; 4. DIR para 0 se for entrada, 1 se for saida
            LDR     R0, =GPIO_PORTA_AHB_DIR_R
			MOV     R1, #2_11110000
            STR     R1, [R0]
			LDR     R0, =GPIO_PORTK_DIR_R
			MOV     R1, #2_111111111					
            STR     R1, [R0]
			LDR     R0, =GPIO_PORTL_DIR_R
			MOV     R1, #2_00000000
            STR     R1, [R0]
			LDR     R0, =GPIO_PORTM_DIR_R
			MOV     R1, #2_11110111		
            STR     R1, [R0]						
			LDR     R0, =GPIO_PORTP_DIR_R		
			MOV     R1, #2_00100000					
            STR     R1, [R0]						
			LDR     R0, =GPIO_PORTQ_DIR_R		
			MOV     R1, #2_00001111					
            STR     R1, [R0]
			; O certo era verificar os outros bits da PF para n�o transformar entradas em sa�das desnecess�rias
            LDR     R0, =GPIO_PORTJ_AHB_DIR_R		;Carrega o R0 com o endere�o do DIR para a porta J
            MOV     R1, #0x00               		;Colocar 0 no registrador DIR para funcionar com sa�da
            STR     R1, [R0]						;Guarda no registrador PCTL da porta J da mem�ria
; 5. Limpar os bits AFSEL para 0 para selecionar GPIO 
;    Sem fun��o alternativa
            MOV     R1, #0x00						;Colocar o valor 0 para n�o setar fun��o alternativa
            LDR     R0, =GPIO_PORTA_AHB_AFSEL_R     
            STR     R1, [R0]                        
			LDR     R0, =GPIO_PORTJ_AHB_AFSEL_R     ;Carrega o endere�o do AFSEL da porta J
            STR     R1, [R0]                        ;Escreve na porta
			LDR     R0, =GPIO_PORTK_AFSEL_R     
            STR     R1, [R0]
			LDR     R0, =GPIO_PORTL_AFSEL_R     
            STR     R1, [R0]
			LDR     R0, =GPIO_PORTM_AFSEL_R     
            STR     R1, [R0]
			LDR     R0, =GPIO_PORTP_AFSEL_R     
            STR     R1, [R0]      
			LDR     R0, =GPIO_PORTQ_AFSEL_R     
            STR     R1, [R0]                        
			
; 6. Setar os bits de DEN para habilitar I/O digital
            LDR     R0, =GPIO_PORTA_AHB_DEN_R
            MOV     R1, #2_11110000                     
            STR     R1, [R0]
			LDR     R0, =GPIO_PORTK_DEN_R
            MOV     R1, #2_11111111                     
            STR     R1, [R0]
			LDR     R0, =GPIO_PORTL_DEN_R
            MOV     R1, #2_00001111                     
            STR     R1, [R0]
			LDR     R0, =GPIO_PORTM_DEN_R
            MOV     R1, #2_11110111                     
            STR     R1, [R0]
			LDR     R0, =GPIO_PORTP_DEN_R
            MOV     R1, #2_00100000                     
            STR     R1, [R0]	
			LDR     R0, =GPIO_PORTQ_DEN_R
            MOV     R1, #2_00001111                     
            STR     R1, [R0]	
 
            LDR     R0, =GPIO_PORTJ_AHB_DEN_R			;Carrega o endere�o do DEN
			MOV     R1, #2_00000011                     ;Ativa os pinos PJ0 e PJ1 como I/O Digital      
            STR     R1, [R0]                            ;Escreve no registrador da mem�ria funcionalidade digital
			
; 7. Para habilitar resistor de pull-up interno, setar PUR para 1
			LDR     R0, =GPIO_PORTJ_AHB_PUR_R			;Carrega o endere�o do PUR para a porta J
			MOV     R1, #2_00000011						;Habilitar funcionalidade digital de resistor de pull-up 
                                                        ;nos bits 0 e 1
            STR     R1, [R0]							;Escreve no registrador da mem�ria do resistor de pull-up
			
			LDR     R0, =GPIO_PORTL_PUR_R			;Carrega o endere�o do PUR para a porta L
			MOV     R1, #2_00001111						;Habilitar funcionalidade digital de resistor de pull-up 
                                                        ;nos bits 0 a 3
            STR     R1, [R0]							;Escreve no registrador da mem�ria do resistor de pull-up
			
            
;retorno            
			BX      LR

; -------------------------------------------------------------------------------
; Fun��o PortF_Output
; Par�metro de entrada: R0 --> se os BIT4 e BIT0 est�o ligado ou desligado
; Par�metro de sa�da: N�o tem
PortF_Output
	LDR	R1, =GPIO_PORTF_AHB_DATA_R		    ;Carrega o valor do offset do data register
	;Read-Modify-Write para escrita
	LDR R2, [R1]
	BIC R2, #2_00010001                     ;Primeiro limpamos os dois bits do lido da porta R2 = R2 & 11101110
	ORR R0, R0, R2                          ;Fazer o OR do lido pela porta com o par�metro de entrada
	STR R0, [R1]                            ;Escreve na porta F o barramento de dados dos pinos F4 e F0
	BX LR									;Retorno

; -------------------------------------------------------------------------------
; Fun��o PortJ_Input
; Par�metro de entrada: N�o tem
; Par�metro de sa�da: R0 --> o valor da leitura
PortJ_Input
	LDR	R1, =GPIO_PORTJ_AHB_DATA_R		    ;Carrega o valor do offset do data register
	LDR R0, [R1]                            ;L� no barramento de dados dos pinos [J1-J0]
	BX LR									;Retorno

; R3 = PORT B
; R4 = PORT P
SetTrans
	LDR R0,=GPIO_PORTB_AHB_DATA_R		    
	LDR R1,=GPIO_PORTP_DATA_R
	STR R3,[R0]
	STR R4,[R1]
	BX LR
	
WrtDig
	CMP R4, #0
	ITT EQ
		MOVEQ R0,#2_00001111
		MOVEQ R1,#2_00110000
	CMP R4, #1
	ITT EQ
		MOVEQ R0,#2_00000110
		MOVEQ R1,#2_00000000
	CMP R4, #2
	ITT EQ
		MOVEQ R0, #2_00001011
		MOVEQ R1, #2_01010000
	CMP R4, #3
	ITT EQ
		MOVEQ R0, #2_00001111
		MOVEQ R1, #2_01000000
	CMP R4, #4
	ITT EQ
		MOVEQ R0, #2_00000110
		MOVEQ R1, #2_01100000
	CMP R4, #5
	ITT EQ
		MOVEQ R0, #2_00001101
		MOVEQ R1, #2_01100000
	CMP R4, #6
	ITT EQ
		MOVEQ R0, #2_00001101
		MOVEQ R1, #2_01110000
	CMP R4, #7
	ITT EQ
		MOVEQ R0, #2_00000111
		MOVEQ R1, #2_00000000
	CMP R4, #8
	ITT EQ
		MOVEQ R0, #2_00001111
		MOVEQ R1, #2_01110000
	CMP R4, #9
	ITT EQ
		MOVEQ R0, #2_00001111
		MOVEQ R1, #2_01100000
	LDR R2,=GPIO_PORTQ_DATA_R
	LDR R3,=GPIO_PORTA_AHB_DATA_R
	STR R0,[R2]
	STR R1,[R3]
	BX LR

	LTORG 

AtivaEscrita
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1,[R0]
	AND R1, #2_11111000
	ORR R1, #2_00000100
	STRB R1,[R0]
	BX LR

AtivaReset
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

DesativaTudo
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1,[R0]
	AND R1, #2_11111000
	ORR R1, #2_00000000
	STRB R1,[R0]
	BX LR

; R1 eh caracter em ASC2
EscreveChar
	PUSH{R0, R1, LR}
	LDR R0,=GPIO_PORTK_DATA_R
	STR R1,[R0]
	BL AtivaEscrita
	BL AtivaEnable
	BL AtivaReset
	MOV R0,#10
	BL SysTick_Wait1us
	BL DesativaTudo
	MOV R0,#40
	BL SysTick_Wait1us
	POP{R0, R1, PC}
	
LimpaDisplay
	PUSH{LR}
	BL AtivaEscrita
	;Limpar o display e levar o cursor para o home
	MOV R1,#0x01
	STR R1,[R2]
	BL DesativaEnable
	MOV R0, #80
	BL SysTick_Wait1us
	POP {PC}
	
IniDisplay
	PUSH {LR}
	BL AtivaEscrita
	; Inicializar no modo 2 linhas / caractere matriz 5x7
	LDR R2, =GPIO_PORTK_DATA_R
	MOV R1, #0x38
	STR R1, [R2]
	BL DesativaEnable
	MOV R0, #80
	BL SysTick_Wait1us
	BL AtivaEscrita
	; Cursor com autoincremento para direita
	MOV R1,#0x06
	STR R1,[R2]
	BL DesativaEnable
	MOV R0, #80
	BL SysTick_Wait1us
	; Configurar o cursor (habilitar o display + cursor + não-pisca)
	MOV R1,#0x0E
	STR R1,[R2]
	BL DesativaEnable
	MOV R0, #80
	BL SysTick_Wait1us
	BL AtivaEscrita
	;Limpar o display e levar o cursor para o home
	MOV R1,#0x01
	STR R1,[R2]
	BL DesativaEnable
	MOV R0, #80
	BL SysTick_Wait1us
	POP {PC}
	
	
IniTabs
	PUSH {R0, R1}
    MOV     R1, #2_1010
	LDR     R0, =CONT_TAB1_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB2_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB3_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB4_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB5_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB6_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB7_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB8_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB9_ADDR
	STRB    R1, [R0]
	MOV     R1, #2_0000
	LDR     R0, =RESULT_TAB_ADDR
	STRB    R1, [R0]
	LDR     R0, =NUM_TAB_ADDR
	STRB    R1, [R0]
	POP {R0, R1}
	BX LR

	
ZeraTabs
	PUSH {R0, R1}
    MOV     R1, #2_0000
	LDR     R0, =CONT_TAB1_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB2_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB3_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB4_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB5_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB6_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB7_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB8_ADDR
	STRB    R1, [R0]
	LDR     R0, =CONT_TAB9_ADDR
	STRB    R1, [R0]
	LDR     R0, =RESULT_TAB_ADDR
	STRB    R1, [R0]
	POP {R0, R1}
	BX LR


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
	
	BL EscreveChar
	MOV R1,#42 ; *
	BL EscreveChar
	MOV R1,R3
	BL EscreveChar
	MOV R1,#61 ; =
	BL EscreveChar
	MOV R3,#10
	UDIV R4,R2,R3
	MOV R1,R4
	BL EscreveChar
	MLS R1,R2,R3,R4
	BL EscreveChar
	
	POP{PC}


IntTeclado
	PUSH {R0, R1, R2} ; os registradortes que sao usados
	; Carrega o numero do teclado para R1...
	
	; Salva a tabuada atual
	LDR R0, =NUM_TAB_ADDR
	STRB R1, [R0]
	MOV R0,#0
	MOVT R0,#0x2000  	; Carrega o endereço base
	; Calcula o endereço da tabuada a ser utilizada
	ADD R0, R1	; R0 := R0 + R1
	; Carrega o valor previo da tabuada
	LDRB R2,[R0] 		; R2 := [R0]
	; Soma um ao valor
	ADD R2,#1
	; Ve se estourou a tabuada
	CMP R2, #10
	IT GE
		MOVGE R2, #0
	; Salva o novo valor da tabuada do numero
	STRB R2,[R0] 		; [R0] := R2
	MUL R1, R2			; R1 := R1*R2
	; Salva o valor resultante a ser mostrado
	LDR R0, =RESULT_TAB_ADDR
	STRB R1, [R0]
	
	POP {R0, R1, R2} ; os registradortes que sao usados
	BX LR

VarreTeclado
	MOV R3, #10
	; Le e escreve na primeira coluna
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1,[R0]
	AND R1, #2_00001111
	ORR R1, #2_11100000
	STRB R1,[R0]
	LDR R0, =GPIO_PORTL_DATA_R
	LDR R1,[R0]
	CMP R1,#2_1110
	IT EQ
		MOVEQ R3,#1
	CMP R1,#2_1101
	IT EQ
		MOVEQ R3,#4
	CMP R1,#2_1011
	IT EQ
		MOVEQ R3,#7
	CMP R3,#10
	IT NE
		BNE finalVarreTeclado
	
	; Le e escreve na segunda coluna
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1,[R0]
	AND R1, #2_00001111
	ORR R1, #2_11010000
	STRB R1,[R0]
	LDR R0, =GPIO_PORTL_DATA_R
	LDR R1,[R0]
	AND R1,#2_1111
	CMP R1,#2_1110
	IT EQ
		MOVEQ R3,#2
	CMP R1,#2_1101
	IT EQ
		MOVEQ R3,#5
	CMP R1,#2_1011
	IT EQ
		MOVEQ R3,#8
	CMP R3,#10
	IT NE
		BNE finalVarreTeclado
	
	; Le e escreve na segunda coluna
	LDR R0, =GPIO_PORTM_DATA_R
	LDR R1,[R0]
	AND R1, #2_00001111
	ORR R1, #2_10110000
	STRB R1,[R0]
	LDR R0, =GPIO_PORTL_DATA_R
	LDR R1,[R0]
	AND R1,#2_1111
	CMP R1,#2_1110
	IT EQ
		MOVEQ R3,#3
	CMP R1,#2_1101
	IT EQ
		MOVEQ R3,#6
	CMP R1,#2_1011
	IT EQ
		MOVEQ R3,#9
	CMP R3,#10
	IT NE
		BNE finalVarreTeclado
finalVarreTeclado
	BX LR


setTeclado
	LDR R0, =NUM_TAB_ADDR
	STRB R3,[R0]
	MOV R1, R3
	PUSH {LR}
	BL IntTeclado
	POP {PC}



	ALIGN                           ; garante que o fim da se��o est� alinhada 
    END                             ; fim do arquivo