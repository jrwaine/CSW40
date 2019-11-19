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
int converteAD(void);
void escreveMotorParado(void);
void escreveTeclPot(void);


void GPIO_Init(void);
void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);


#define ADDR_VELOCIDADE     (*((volatile uint32_t *)0x20000000))
#define ADDR_TECL_POT       (*((volatile uint32_t *)0x20000004))
#define ADDR_RESET          (*((volatile uint32_t *)0x2000000C))
#define ADDR_SENTIDO        (*((volatile uint32_t *)0x20000010))

#define SENT_HOR (1)
#define SENT_ANT_HOR (2)

#define TECL (1)
#define POT (2)

// # é 12 e * é 11
enum{RESETA,
    MOTOR_PARADO,
    PEDE_INFO,
    PEDE_INFO_POT,
    PEDE_INFO_TECL,
    ATUA
}Estados;


void rodaHorario(void)
{
    GPIO_PORTE_AHB_DATA_R |= 0xF2;
    // faz o timer pro PWM
    GPIO_PORTF_AHB_DATA_R = GPIO_PORTF_AHB_DATA_R | (0x4);
    SysTick_Wait1us(ADDR_VELOCIDADE); // NO ALTO
    GPIO_PORTF_AHB_DATA_R = GPIO_PORTF_AHB_DATA_R & (~0x4);
    SysTick_Wait1us(4096-ADDR_VELOCIDADE); // NO BAIXO
}

void rodaAntiHorario(void)
{
    GPIO_PORTE_AHB_DATA_R |= 0xF1;
    // faz o timer pro PWM
    GPIO_PORTF_AHB_DATA_R |= (0x4);
    SysTick_Wait1us(ADDR_VELOCIDADE); // NO ALTO
    GPIO_PORTF_AHB_DATA_R |= (~0x4);
    SysTick_Wait1us(4096-ADDR_VELOCIDADE); // NO BAIXO
}


/*
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
*/


int estado = RESETA;

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


int leTecladoComBounce()
{
    int num = leTeclado();
    return num;
}


void zeraTudo(void)
{
    ADDR_VELOCIDADE = 0;
    ADDR_RESET = 0;
    ADDR_SENTIDO = 0;
    estado = MOTOR_PARADO;
}

void motorParado(void)
{
    escreveMotorParado();
    SysTick_Wait1ms(2000);
    estado = PEDE_INFO;
}


void pedeInfo(void)
{
    escreveTeclPot();
    int var = leTecladoSemBounce();
    while((var != POT || var != TECL) && !ADDR_RESET)
    {
        var = leTecladoSemBounce();
    }

    if(ADDR_RESET)
    {
        estado = RESETA;
        return;
    }
    
    if(var == TECL)
        estado = PEDE_INFO_TECL;
    else if(var == POT)
        estado = PEDE_INFO_POT;
    ADDR_TECL_POT = var;
}


void pedeInfoTecl(void)
{
    escrevePedeSentido();
    SysTick_Wait1ms(500);
    int sentido = leTecladoSemBounce();
    while(sentido != SENT_HOR && sentido != SENT_ANT_HOR && !ADDR_RESET)
    {
        sentido = leTecladoSemBounce();
    }
    if(ADDR_RESET)
    {
        estado = RESETA; 
        return;
    }
    

    escrevePedeVel();
    SysTick_Wait1ms(500);
    int vel = leTecladoSemBounce();
    while((vel < 0 || vel > 6) && !ADDR_RESET)
    {
        vel = leTecladoSemBounce();
    }
    if(ADDR_RESET)
    {
        estado = RESETA; 
        return;
    }
    ADDR_SENTIDO = sentido;
    if(vel == 0)
        ADDR_VELOCIDADE = 0;
    else
        ADDR_VELOCIDADE = (vel+4)*409;
    
    estado = ATUA;
}


void pedeInfoPot(void)
{
    escrevePedeSentido();
    SysTick_Wait1ms(500);
    int sentido = leTecladoSemBounce();
    while(sentido != SENT_HOR && sentido != SENT_ANT_HOR && !ADDR_RESET)
    {
        sentido = leTecladoSemBounce();
    }
    if(ADDR_RESET)
    {
        estado = RESETA; 
        return;
    }

    ADDR_SENTIDO = sentido;
    estado = ATUA;
}


void atua(void)
{
    escreveDisplay();
    while(!ADDR_RESET)
    {
        if(ADDR_TECL_POT == POT)
            ADDR_VELOCIDADE = converteAD();

        if(ADDR_SENTIDO == SENT_ANT_HOR)
            rodaAntiHorario();

        else if(ADDR_SENTIDO == SENT_HOR)
            rodaHorario();

        int tecl = leTecladoComBounce();
        if(tecl ==  11)
        {
            ADDR_SENTIDO = SENT_HOR;
        }
        else if(tecl ==  12)
        {
            ADDR_SENTIDO = SENT_ANT_HOR;
        }
    }
    estado = RESETA;
}


void loop()
{
    while(1)
    {
        switch(estado)
        {
        case RESETA:
            zeraTudo();
            break;
        case MOTOR_PARADO:
            motorParado();
            break;
        case PEDE_INFO:
            pedeInfo();
            break;
        case PEDE_INFO_TECL:
            pedeInfoTecl();
            break;
        case PEDE_INFO_POT:
            pedeInfoPot();
            break;
        case ATUA:
            atua();
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
