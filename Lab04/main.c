/************************************************************************/
/* ECE 344L - Microprocessors – Spring 2020                             */
/*                                                                      */
/*                                                                      */
/* Lab03.c -- General Description of file                               */
/*                                                                      */
/*                                                                      */
/************************************************************************/
/* Author(s): Landon Schmucker                                          */
/*            Following functions from Edward Nava:                     */
/*             DeviceInit()                                             */
/*             DisplayInit()                                            */
/*             DelayMS()                                                */
/************************************************************************/
/*   Detailed File Description:                                         */
/* Vending machine simulator using buttons and LEDs on the MX7 board.   */
/* Every item is 30 cents, only nickels and dimes.                      */
/*                                                                      */
/************************************************************************/
/*  Revision History: 2/29/2020 Started File                            */
/*                    3/01/2020 Started state machine                   */
/*                    3/02/2020 Debug                                   */
/************************************************************************/

#include <plib.h>
#include <stdio.h>

/* ------------------------------------------------------------ */
/*				Configuration Bits				                */
/* ------------------------------------------------------------ */

// Configure MX7 board for debugging
#pragma config ICESEL = ICS_PGx1

// SYSCLK = 80 MHz (8 MHz Crystal/ FPLLIDIV * FPLLMUL / FPLLODIV)
// Primary Osc w/PLL (XT+,HS+,EC+PLL)
#pragma config FNOSC = PRIPLL
#pragma config POSCMOD = EC
#pragma config FPLLIDIV = DIV_2
#pragma config FPLLMUL = MUL_20
#pragma config FPLLODIV = DIV_1
#pragma config FPBDIV = DIV_8
#pragma config FSOSCEN = OFF            // Secondary oscillator enable
#define SYS_FREQ (80000000L)

/* ------------------------------------------------------------ */
/*				Definitions									    */
/* ------------------------------------------------------------ */

#define	cntMsDelay	10000			//timer 1 delay for 1ms

/* ------------------------------------------------------------ */
/*				Function Declarations							*/
/* ------------------------------------------------------------ */

void DeviceInit();
void DelayInit();
void DelayMs(int cms);
void vendingmachine(int coin);

/* ------------------------------------------------------------ */
/*				Main											*/
/* ------------------------------------------------------------ */

int main()
{
	int button_in12 = 0;
	int button_in3 = 0;
	int coins = 0;
	int msdelay = 200;

	DeviceInit();
	DelayInit();

	while (1) {

		button_in12 = PORTReadBits(IOPORT_G, BIT_6 | BIT_7); //buttons to simulate nickels and dimes
		button_in3 = PORTReadBits(IOPORT_A, BIT_0); //reset origram button


		if (button_in12 != 0) {
			// drive both LD1 and LD2 high if both buttons pressed
			if (((button_in12 & 0x0040) != 0) && ((button_in12 & 0x0080) != 0)){
				coints += 15;
				vendingmachine(coins);
			}
			
			else {
				if ((button_in12 & 0x0040) != 0) 	// BTN1 pressed?
					coints += 5
					vendingmachine(coins);				
				if ((button_in12 & 0x0080) != 0)	// BTN2 pressed
					coints += 10;
					vendingmachine(coins);
		}

		}

		if (button_in3 != 0) { 
			coins = 0; //if reset button is hit reset coints to 0 and
			PORTWrite(IOPORT_G,BIT_12|BIT_13|BIT_14|BIT_15);
			DelayMS(msdelay); //flash lights if reset is hit
			PORTClearBits(IOPORT_G,BIT_12|BIT_13| BIT_14|BIT_15); 
		}
		DelayMs(1);
		PORTClearBits(IOPORT_G, BIT_12|BIT_13| BIT_14|BIT_15);
	}

}

/* ------------------------------------------------------------ */
/*	State Machine Code behaves like Vending Machine             */
/* ------------------------------------------------------------ */

void vendingmachine(int coin)
{
	PORTClearBits(IOPORT_G, BIT_12 | BIT_13 | BIT_14 | BIT_15);

	switch (coins)
	{
	case 5: // 5 Cents inserted (001) LED 1
		PORTWrite(IOPORT_G, BIT_12); 
		break;
	case 10:// 10 cents inserted (010) LED 2
		PORTWrite(IOPORT_G, BIT_13); 
		break;
	case 15:// 15 cents inserted (011) LED 1 & 2
		PORTWrite(IOPORT_G, BIT_12|BIT_13); 
		break;
	case 20:// 20 cents inserted (100) LED 3
		PORTWrite(IOPORT_G, BIT_14); 
		break;
	case 25:// 25 cents inserted (101) LED 1 & 3
		PORTWrite(IOPORT_G, BIT_12|BIT_14); 
		break;
	case 30://30 cents inserted, LED 4 on to dispense item (111)
		PORTWrite(IOPORT_G, BIT15); 
		DelayMs(msdelay);
		PORTClearBits(IOPORT_G, BIT_12 | BIT_13 | BIT_14 | BIT_15);
		break;
	case 35: //35 cents inserted dispence item and change
		PORTWrite(IOPORT_G, BIT12);
		DelayMs(msdelay);
		PORTClearBits(IOPORT_G, BIT12);
		DelayMS(msdelay);
		PORTWrite(IOPORT_G, BIT_15);
		DelayMS(msdelay);
		PORTClearBits(IOPORT_G, BIT_12 | BIT_13 | BIT_14 | BIT_15);
		coins = 0;
		break;
	default:
		PORTClearBits(IOPORT_G, BIT_12 | BIT_13 | BIT_14 | BIT_15); //default jUSt clears all bits
	}
}

/* ------------------------------------------------------------ */
/*	Set LD1 through LD4 as digital output                       */
/* ------------------------------------------------------------ */


void DeviceInit()
{
	// On Mx7 Board - signal conflict with BTN3 and Jtag
	// Must disable JTAG controller to use BTN3
	DDPCONbits.JTAGEN = 0;									// Disable JTAG

	//On MX7 LED1 is on RG12
	//		   LED2 is on RG13
	//		   LED3 is on RG14
	//		   LED4 is on RG15

	//Set ports for onboard LEDs to outputs
	PORTSetPinsDigitalOut(IOPORT_G, BIT_12 | BIT_13 | BIT_14 | BIT_15);
	PORTClearBits(IOPORT_G, BIT12_ | BIT_13 | BIT_14 | BIT_15);
	//Set ports for onboard BTNs as inputs
	PORTSetPinsDigitalIn(IOPORT_G, BIT_6 | BIT_7);
	PORTSetPinsDigitalIn(IOPORT_A, BIT_0);

}

/* ------------------------------------------------------------ */
/* Set up time so delays can be put in place                    */
/* ------------------------------------------------------------ */

void DelayInit()
{
	unsigned int tcfg;

	// Configure Timer 1. This sets it up to count a 10Mhz with a period of 0xFFFF
	// which is the full count range of the timer

	tcfg = T1_ON | T1_IDLE_CON | T1_SOURCE_INT | T1_PS_1_1 | T1_GATE_OFF | T1_SYNC_EXT_OFF;
	OpenTimer1(tcfg, 0xFFFF);

}

/* ------------------------------------------------------------ */
/* Delay a certain amount of milliseconds                       */
/* ------------------------------------------------------------ */

void DelayMs(int cms)
{
	int		ims;

	// Timer counts up to a value which represents 1ms and then resets to 0

	for (ims = 0; ims < cms; ims++) {
		WriteTimer1(0);
		while (ReadTimer1() < cntMsDelay);
	}

}