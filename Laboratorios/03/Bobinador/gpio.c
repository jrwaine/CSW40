// gpio.c
// Desenvolvido para a placa EK-TM4C1294XL
// Inicializa as portas J e N
// Prof. Guilherme Peron

#include <stdint.h>
#include "tm4c1294ncpdt.h"
#include <string.h>

#define ADDR_VELOCIDADE     (*((volatile uint32_t *)0x20000000))
#define ADDR_ANGULO         (*((volatile uint32_t *)0x20000004))
#define ADDR_NUM_VOLTAS     (*((volatile uint32_t *)0x20000008))
#define ADDR_RESET          (*((volatile uint32_t *)0x2000000C))


void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);

// -------------------------------------------------------------------------------
// Fun��o GPIO_Init
// Inicializa os ports J e N
// Par�metro de entrada: N�o tem
// Par�metro de sa�da: N�o tem
void GPIO_Init(void)
{
	//1a. Ativar o clock para a porta setando o bit correspondente no registrador RCGCGPIO
    uint16_t ports = (GPIO_PORTA);
		ports |= (GPIO_PORTE);
		ports |= GPIO_PORTF;
		ports |= GPIO_PORTH;
		ports |= GPIO_PORTJ;
		ports |= GPIO_PORTK;
		ports |= GPIO_PORTL;
		ports |= GPIO_PORTM;
		ports |= GPIO_PORTP;
		ports |= GPIO_PORTQ;
    SYSCTL_RCGCGPIO_R |= ports;
	//1b.   ap�s isso verificar no PRGPIO se a porta est� pronta para uso.
    while((SYSCTL_PRGPIO_R & (ports) ) != (ports) ){};
	
	// 2. Limpar o AMSEL para desabilitar a anal�gica
    GPIO_PORTA_AHB_AMSEL_R = 0x00;
    GPIO_PORTE_AHB_AMSEL_R = 0x00;
    GPIO_PORTF_AHB_AMSEL_R = 0x00;
    GPIO_PORTH_AHB_AMSEL_R = 0x00;
	GPIO_PORTJ_AHB_AMSEL_R = 0x00;
	GPIO_PORTK_AMSEL_R = 0x00;
	GPIO_PORTL_AMSEL_R = 0x00;
	GPIO_PORTM_AMSEL_R = 0x00;
	GPIO_PORTP_AMSEL_R = 0x00;
	GPIO_PORTQ_AMSEL_R = 0x00;

	// 3. Limpar PCTL para selecionar o GPIOGPIO_PORTA_AHB_AMSEL_R = 0x00;
    GPIO_PORTA_AHB_PCTL_R = 0x00;
    GPIO_PORTE_AHB_PCTL_R = 0x00;
    GPIO_PORTF_AHB_PCTL_R = 0x00;
    GPIO_PORTH_AHB_PCTL_R = 0x00;
	GPIO_PORTJ_AHB_PCTL_R = 0x00;
	GPIO_PORTK_PCTL_R = 0x00;
	GPIO_PORTL_PCTL_R = 0x00;
	GPIO_PORTM_PCTL_R = 0x00;
	GPIO_PORTP_PCTL_R = 0x00;
	GPIO_PORTQ_PCTL_R = 0x00;

	// 4. DIR para 0 se for entrada, 1 se for sa�da
	//GPIO_PORTA_AHB_DIR_R = 0b11110000;
	GPIO_PORTA_AHB_DIR_R = 0xF0;
	//GPIO_PORTE_AHB_DIR_R = 0b00001111;
	GPIO_PORTE_AHB_DIR_R = 0x0F;
	//GPIO_PORTF_AHB_DIR_R = 0b00001100;
	GPIO_PORTF_AHB_DIR_R = 0x0C;
	//GPIO_PORTH_AHB_DIR_R = 0b00001111;
	GPIO_PORTH_AHB_DIR_R = 0x0F;
	//GPIO_PORTJ_AHB_DIR_R = 0b00000000;
	GPIO_PORTJ_AHB_DIR_R = 0x00;
	//GPIO_PORTK_DIR_R = 0b11111111; 
	GPIO_PORTK_DIR_R = 0xFF; 
	//GPIO_PORTL_DIR_R = 0b00000000;
	GPIO_PORTL_DIR_R = 0x00;
	//GPIO_PORTM_DIR_R = 0b11110111;
	GPIO_PORTM_DIR_R = 0xF7;
	//GPIO_PORTP_DIR_R = 0b00100000;
	GPIO_PORTP_DIR_R = 0x20;
	//GPIO_PORTQ_DIR_R = 0b00001111;
	GPIO_PORTQ_DIR_R = 0x0F;
		
	// 5. Limpar os bits AFSEL para 0 para selecionar GPIO sem fun��o alternativa	
    GPIO_PORTA_AHB_AFSEL_R = 0x00;
    GPIO_PORTE_AHB_AFSEL_R = 0x00;
    GPIO_PORTF_AHB_AFSEL_R = 0x00;
    GPIO_PORTH_AHB_AFSEL_R = 0x00;
	GPIO_PORTJ_AHB_AFSEL_R = 0x00;
	GPIO_PORTK_AFSEL_R = 0x00;
	GPIO_PORTL_AFSEL_R = 0x00;
	GPIO_PORTM_AFSEL_R = 0x00;
	GPIO_PORTP_AFSEL_R = 0x00;
	GPIO_PORTQ_AFSEL_R = 0x00;
    
	// 6. Setar os bits de DEN para habilitar I/O digital	c
	//GPIO_PORTA_AHB_DEN_R = 0b11110000;
	GPIO_PORTA_AHB_DEN_R = 0xF0;
	//GPIO_PORTE_AHB_DEN_R = 0b00001111;
	GPIO_PORTE_AHB_DEN_R = 0x0F;
	//GPIO_PORTF_AHB_DEN_R = 0b00001100;
	GPIO_PORTF_AHB_DEN_R = 0x0C;
	//GPIO_PORTH_AHB_DEN_R = 0b00001111;
	GPIO_PORTH_AHB_DEN_R = 0x0F;
	//GPIO_PORTJ_AHB_DEN_R = 0b00000001;
	GPIO_PORTJ_AHB_DEN_R = 0x01;
	//GPIO_PORTK_DEN_R = 0b11111111; 
	GPIO_PORTK_DEN_R = 0xFF; 
	//GPIO_PORTL_DEN_R = 0b00001111;
	GPIO_PORTL_DEN_R = 0x0F;
	//GPIO_PORTM_DEN_R = 0b11110111;
	GPIO_PORTM_DEN_R = 0xF7;
	//GPIO_PORTP_DEN_R = 0b00100000;
	GPIO_PORTP_DEN_R = 0x20;
	//GPIO_PORTQ_DEN_R = 0b00001111;
	GPIO_PORTQ_DEN_R = 0x0F;
	
	// 7. Habilitar resistor de pull-up interno, setar PUR para 1
	  //GPIO_PORTJ_AHB_PUR_R = 0b00000001;   //Bit0
    GPIO_PORTJ_AHB_PUR_R = 0x01;   //Bit0
    //GPIO_PORTL_PUR_R = 0b00001111;
		GPIO_PORTL_PUR_R = 0x0F;

    // 8. Configurar as interrupcoes da porta J
    NVIC_EN1_R = 1 << 19;
    NVIC_PRI12_R = 1 << 29;
    // J0 - descida
    GPIO_PORTJ_AHB_IM_R = 0x0;
    GPIO_PORTJ_AHB_IS_R = 0x0;
    GPIO_PORTJ_AHB_IBE_R = 0x0;
    GPIO_PORTJ_AHB_IEV_R = 0x0;
    GPIO_PORTJ_AHB_ICR_R = 0x1;
    GPIO_PORTJ_AHB_IM_R = 0x1;
}


void GPIOPortJ_Handler()
{
    GPIO_PORTJ_AHB_ICR_R = 1;
    ADDR_VELOCIDADE = 0;
    ADDR_ANGULO = 0;
    ADDR_NUM_VOLTAS = 0;
    ADDR_RESET = 1;
}


void led_Output(uint8_t leds)
{
    GPIO_PORTA_AHB_DATA_R = 0xF0 & leds; // upepr
    GPIO_PORTQ_DATA_R = 0x0F & leds; // lower
    GPIO_PORTP_DATA_R = 0x20; // transistor
}


void ativaRS(void)
{
    GPIO_PORTM_DATA_R &= 0xFE;
    GPIO_PORTM_DATA_R |= 0x01;
}


void desativaRS(void)
{
    GPIO_PORTM_DATA_R &= 0xFE;
}


void ativaEnable()
{
    GPIO_PORTM_DATA_R &= 0xFB;
    GPIO_PORTM_DATA_R |= 0x04;
}


void desativaEnable()
{
    GPIO_PORTM_DATA_R &= 0xFB;
}


void ativaRW()
{
    GPIO_PORTM_DATA_R &= 0xFD;
    GPIO_PORTM_DATA_R &= 0x02;
}


void desativaRW()
{
    GPIO_PORTM_DATA_R &= 0xFD;
}


void desativaTudo()
{
    GPIO_PORTM_DATA_R &= 0xF8;
}


void limpaDisplay()
{
    desativaRS();
    desativaRW();
    ativaEnable();
    GPIO_PORTK_DATA_R = 0x01;
    desativaEnable();
    SysTick_Wait1us(40);
}


void escreveChar(char c)
{
    GPIO_PORTK_DATA_R = c;
    ativaRS();
    desativaRW();
    ativaEnable();
    SysTick_Wait1us(20);
    desativaTudo();
    SysTick_Wait1us(40);
}


int leTeclado()
{
    int val = -1;
    // primeira coluna
    GPIO_PORTM_DATA_R &= 0x0F;
    GPIO_PORTM_DATA_R |= 0xE0;
    int tecl = GPIO_PORTL_DATA_R;
    if(tecl == 0xE)
        val = 1;
    else if(tecl == 0xD)
        val = 4;
    else if(tecl == 0xB)
        val = 7;
    else if(tecl == 0x7)
        val = 11;

    // segunda coluna
    GPIO_PORTM_DATA_R &= 0x0F;
    GPIO_PORTM_DATA_R |= 0xD0;
    tecl = GPIO_PORTL_DATA_R;
    if(tecl == 0xE)
        val = 2;
    else if(tecl == 0xD)
        val = 5;
    else if(tecl == 0xB)
        val = 8;
    else if(tecl == 0x7)
        val = 10;

    // terceira coluna
    GPIO_PORTM_DATA_R &= 0x0F;
    GPIO_PORTM_DATA_R |= 0xB0;
    tecl = GPIO_PORTL_DATA_R;
    if(tecl == 0xE)
        val = 3;
    else if(tecl == 0xD)
        val = 6;
    else if(tecl == 0xB)
        val = 9;

    return val;
}


void escreveDisplay()
{
    char str[16];
    
	strcpy(str, "S:");
    char sent[1];
    if (ADDR_VELOCIDADE > 0)
        sent[0] = 49;
    else
        sent[0] = 48;
    strcat(str, sent);
    
		strcat(str, " V:");
    char vel[1] = {(char)(ADDR_VELOCIDADE)+48};
    strcat(str, vel);
    strcat(str, " T:");
    
		int num_voltas = ADDR_ANGULO/360;
    if(num_voltas < 0)
        num_voltas = -num_voltas;
		char voltas[2];
		voltas[0] = num_voltas/10+48;
		voltas[1] = num_voltas%10+48;
    strcat(str, voltas);
		
    strcat(str, "    ");

    limpaDisplay();
    int i;
    for(i = 0; i < 16; i++)
        escreveChar(str[i]);
}


void escreveFim()
{
    char str[3];
    str[0] = 'F';
    str[1] = 'I';
    str[2] = 'M';
    limpaDisplay();
    
    int i;
    for(i = 0; i < 3; i++)
        escreveChar(str[i]);
}


void escrevePedeSentido()
{
    char str[16] = "Sent. (1=H 2=A)";
    limpaDisplay();

    int i;
    for(i = 0; i < 15; i++)
        escreveChar(str[i]);
}


void escrevePedeVel()
{
    char str[16] = "Vel. (1-2)";
    limpaDisplay();

    int i;
    for(i = 0; i < 10; i++)
        escreveChar(str[i]);
}


void escrevePedeVoltas()
{
    char str[16] = "Voltas (1-10)";
    limpaDisplay();

    int i;
    for(i = 0; i < 13; i++)
        escreveChar(str[i]);
}


void iniDisplay()
{
    desativaRS();
    desativaRW();

    // Inicializar no modo 2 linhas / caractere matriz 5x7
    ativaEnable();
    GPIO_PORTK_DATA_R = 0x38;
    desativaEnable();
    SysTick_Wait1us(80);
    // Cursor com autoincremento para direita
    ativaEnable();
    GPIO_PORTK_DATA_R = 0x06;
    desativaEnable();
    SysTick_Wait1us(80);
    // Configurar o cursor (habilitar o display + cursor + n�o-pisca)
    ativaEnable();
    GPIO_PORTK_DATA_R = 0x0E;
    desativaEnable();
    SysTick_Wait1us(80);
    // Limpar o display e levar o cursor para o home
    ativaEnable();
    GPIO_PORTK_DATA_R = 0x01;
    desativaEnable();
    SysTick_Wait1us(80);
}

