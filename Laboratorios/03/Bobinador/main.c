// main.c
// Desenvolvido para a placa EK-TM4C1294XL
// Verifica o estado da chave USR_SW2 e acende os LEDs 1 e 2 caso esteja pressionada
// Prof. Guilherme Peron

#include <stdint.h>

void acenderLeds(void);
void led_Output(uint8_t leds);
int leTeclado(void);
void iniDisplay(void);
void escreveDisplay(void);
void escreveFim(void);
void escrevePedeSentido(void);
void escrevePedeVel(void);
void escrevePedeVoltas(void);

void GPIO_Init(void);
uint32_t PortJ_Input(void);
void PortN_Output(uint32_t leds);

void PLL_Init(void);
void SysTick_Init(void);
void SysTick_Wait1ms(uint32_t delay);
void SysTick_Wait1us(uint32_t delay);


#define ADDR_VELOCIDADE     (*((volatile uint32_t *)0x20000000))
#define ADDR_ANGULO         (*((volatile uint32_t *)0x20000000))



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


void loop()
{
    while(1)
    {
        ADDR_ANGULO = 0;
        ADDR_VELOCIDADE = 0;
        int num = leTecladoSemBounce();
        led_Output(num & 0xFF);
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
