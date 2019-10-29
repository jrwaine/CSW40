// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado da chave USR_SW2 e acende os LEDs 1 e 2 caso esteja pressionada
// Prof. Guilherme Peron

#include <stdint.h>

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

enum{ZERA_TUDO,
	PEDE_INFO,
	ATUA,
	FIM
}Estados;

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

    if(sentido == 1)
        ADDR_VELOCIDADE = vel;
    else
        ADDR_VELOCIDADE = -vel;
    
    ADDR_NUM_VOLTAS = voltas;
    estado = ATUA;
}


void atua(void)
{
    while(ADDR_ANGULO/360 < ADDR_NUM_VOLTAS && !ADDR_RESET)
    {
        if((int)ADDR_VELOCIDADE < 0)
        {
            // da um passo para o sentido anti horario
            int giro = -ADDR_VELOCIDADE;
            // TODO
            
            // soma o angulo rotacionado
            // TODO
            
            // faz o passo do led
            led_Output(((ADDR_ANGULO)%360)/8);
        }
        else
        {
            // da um passo para o sentido horario
            int giro = ADDR_VELOCIDADE;
            // soma o angulo rotacionado
            led_Output((-(ADDR_ANGULO)%360)/8);
        }
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
        /*ADDR_ANGULO = 0;
        ADDR_VELOCIDADE = 0;
        int num = leTecladoSemBounce();
        led_Output(num & 0xFF);*/
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
