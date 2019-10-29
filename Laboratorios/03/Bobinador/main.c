// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado da chave USR_SW2 e acende os LEDs 1 e 2 caso esteja pressionada
// Prof. Guilherme Peron

#include <stdint.h>
#include "tm4c1294ncpdt.h"

void led_Output(uint8_t leds);
int leTeclado(void);
void iniDisplay(void);
void escreveDisplay(void);
void escreveFim(void);
void escrevePedeSentido(void);
void escrevePedeVel(void);
void escrevePedeVoltas(void);

void GPIO_Init(void);

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);


#define ADDR_VELOCIDADE     (*((volatile uint32_t *)0x20000000))
#define ADDR_ANGULO         (*((volatile uint32_t *)0x20000004))
#define ADDR_NUM_VOLTAS     (*((volatile uint32_t *)0x20000008))
#define ADDR_RESET          (*((volatile uint32_t *)0x2000000C))
#define ADDR_SENTIDO        (*((volatile uint32_t *)0x20000010))
#define RATIO (6)

enum{ZERA_TUDO,
	PEDE_INFO,
	ATUA,
	FIM
}Estados;


void rodaHorario(void)
{
    if(GPIO_PORTH_AHB_DATA_R == 0xF || GPIO_PORTH_AHB_DATA_R == 0xE)
			 GPIO_PORTH_AHB_DATA_R = 0x7;
		else if (GPIO_PORTH_AHB_DATA_R == 0x7)
			 GPIO_PORTH_AHB_DATA_R = 0xB;
		else if (GPIO_PORTH_AHB_DATA_R == 0xB)
			 GPIO_PORTH_AHB_DATA_R = 0xD;
		else if (GPIO_PORTH_AHB_DATA_R == 0xD)
			 GPIO_PORTH_AHB_DATA_R = 0xE;
}


void rodaAntiHorario(void)
{
    if(GPIO_PORTH_AHB_DATA_R == 0xF || GPIO_PORTH_AHB_DATA_R == 0x7)
			 GPIO_PORTH_AHB_DATA_R = 0xE;
		else if (GPIO_PORTH_AHB_DATA_R == 0xE)
			 GPIO_PORTH_AHB_DATA_R = 0xD;
		else if (GPIO_PORTH_AHB_DATA_R == 0xD)
			 GPIO_PORTH_AHB_DATA_R = 0xB;
		else if (GPIO_PORTH_AHB_DATA_R == 0xB)
			 GPIO_PORTH_AHB_DATA_R = 0x7;
}



void rodaHorarioMeioPasso(void)
{
    if(GPIO_PORTH_AHB_DATA_R == 0xF || GPIO_PORTH_AHB_DATA_R == (0xE & 0x7))
			 GPIO_PORTH_AHB_DATA_R = 0x7 & 0xB;
		else if (GPIO_PORTH_AHB_DATA_R == (0x7 & 0xB))
			 GPIO_PORTH_AHB_DATA_R = (0xB & 0xD);
		else if (GPIO_PORTH_AHB_DATA_R == (0xB & 0xD))
			 GPIO_PORTH_AHB_DATA_R = (0xD & 0xE);
		else if (GPIO_PORTH_AHB_DATA_R == (0xD & 0xE))
			 GPIO_PORTH_AHB_DATA_R = 0xE & 0x7;
}


void rodaAntiHorarioMeioPasso(void)
{
    if(GPIO_PORTH_AHB_DATA_R == 0xF || GPIO_PORTH_AHB_DATA_R == (0xE & 0x7))
			 GPIO_PORTH_AHB_DATA_R = 0xD & 0xE;
		else if (GPIO_PORTH_AHB_DATA_R == (0x7 & 0xB))
			 GPIO_PORTH_AHB_DATA_R = (0x7 & 0xE);
		else if (GPIO_PORTH_AHB_DATA_R == (0xB & 0xD))
			 GPIO_PORTH_AHB_DATA_R = (0xB & 0x7);
		else if (GPIO_PORTH_AHB_DATA_R == (0xD & 0xE))
			 GPIO_PORTH_AHB_DATA_R = 0xB & 0xD;
}

int estado = ZERA_TUDO;

int leTecladoSemBounce()
{
    int useNum = 0;
    int num = leTeclado();
    if(num < 0)
        useNum = 0;
    else
    {
        SysTick_Wait1ms(30);
        if(leTeclado() == num)
        {
            SysTick_Wait1ms(30);
            if(leTeclado() == num)
            {
                SysTick_Wait1ms(30);
                if(leTeclado() == num)
                    useNum = 1;
            }
        }
    }
    if(useNum)
        return num;
    return -1;
}


void zeraTudo(void)
{
    ADDR_VELOCIDADE = 0;
    ADDR_ANGULO = 0;
    ADDR_NUM_VOLTAS = 0;
    ADDR_RESET = 0;
    led_Output(((ADDR_ANGULO)%360)/8);
    estado = PEDE_INFO;
}


void pedeInfo(void)
{
    escrevePedeSentido();
    SysTick_Wait1ms(500);
    int sentido = leTecladoSemBounce();
    while(sentido != 1 && sentido != 2 && sentido != 11 && !ADDR_RESET)
    {
        sentido = leTecladoSemBounce();
    }
    if(sentido == 11 || ADDR_RESET)
    {
        estado = ZERA_TUDO; 
        return;
    }

    escrevePedeVel();
    SysTick_Wait1ms(500);
    int vel = leTecladoSemBounce();
    while(vel != 1 && vel != 2 && vel != 11 && !ADDR_RESET)
    {
        vel = leTecladoSemBounce();
    }
    if(vel == 11 || ADDR_RESET)
    {
        estado = ZERA_TUDO; 
        return;
    }

    escrevePedeVoltas();
    SysTick_Wait1ms(500);
    int voltas = leTecladoSemBounce();
    while(voltas < 0 && !ADDR_RESET)
    {
        voltas = leTecladoSemBounce();
    }
    if(voltas == 11 || ADDR_RESET)
    {
        estado = ZERA_TUDO; 
        return;
    }
	  ADDR_SENTIDO = sentido;
    ADDR_VELOCIDADE = vel;
    ADDR_NUM_VOLTAS = voltas;
    estado = ATUA;
}


void atua(void)
{
	  GPIO_PORTH_AHB_DATA_R = 0xF;
	  int ratio = RATIO;
    while((ADDR_ANGULO/360/RATIO) < (ADDR_NUM_VOLTAS) && !ADDR_RESET)
    {
        if(ADDR_SENTIDO == 2)
        {
            // da um passo para o sentido anti horario
            int giro = ADDR_VELOCIDADE;
            if(ADDR_VELOCIDADE == 1)
						{
						    rodaAntiHorario();
						    ADDR_ANGULO += 1;
						}
						else if (ADDR_VELOCIDADE == 2)
						{
                rodaAntiHorarioMeioPasso();
							  ADDR_ANGULO += 1;
						}
						
            // soma o angulo rotacionado
            // TODO
            
            // faz o passo do led
            led_Output(1 << (((ADDR_ANGULO/RATIO)%360)/45));
        }
        else
        {
            // da um passo para o sentido horario
            if(ADDR_VELOCIDADE == 1)
						{
						    rodaHorario();
						    ADDR_ANGULO += 1;
						}
						else if (ADDR_VELOCIDADE == 2)
						{
                rodaHorarioMeioPasso();
							  ADDR_ANGULO += 1;
						}
            
						
            // soma o angulo rotacionado
            led_Output(1 << (((360-((ADDR_ANGULO/RATIO)%360))/45)));
        }
				escreveDisplay();
    }
		if(ADDR_RESET)
			estado = ZERA_TUDO;
		else
			estado = FIM;
}

void fim(void)
{
    escreveFim();
    int tecl = leTecladoSemBounce();
    while(tecl != 11 && !ADDR_RESET)
    {
        tecl = leTecladoSemBounce();
    }
    estado = ZERA_TUDO;
}

void loop()
{
    while(1)
    {
        switch(estado)
        {
            case ZERA_TUDO:
                zeraTudo();
                break;
            case PEDE_INFO:
                pedeInfo();
                break;
            case ATUA:
                atua();
                break;
            case FIM:
                fim();
                break;
						default:
							break;
        }
    }
}

int main(void)
{
  	PLL_Init();
    SysTick_Init();
    GPIO_Init();
    iniDisplay();

    loop();
}
