#ifndef __LAB3_H__
#define __LAB3_H__

#include "tm4c1294ncpdt.h"
#include "nossosDefines.h"
#include "utils.h"
#include <stdint.h>
#include <string.h>

void acenderLeds();
void led_Output(uint8_t leds);
int leTeclado();
void iniDisplay();
void escreveDisplay();
void escreveFim();
void escrevePedeSentido();
void escrevePedeVel();
void escrevePedeVoltas();

#endif
