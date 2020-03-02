/************************************************************************/
/* ECE 344L - Microprocessors – Spring 2020                             */
/*                                                                      */
/*                                                                      */
/* Lab2.S -- General Description of file                                */
/*                                                                      */
/*                                                                      */
/************************************************************************/
/* Author(s): Landon Schmucker                                          */
/*                                                                      */
/************************************************************************/
/*   Detailed File Description:                                         */
/* This project does the following and uses the following resources and */
/* has the following dependencies or limitations.                       */
/*                                                                      */
/************************************************************************/
/*  Revision History: 2/11/2020 Wrote Code                               */
/************************************************************************/

#include <p32xxxx.h>

.globl main 	#this tells the assembler that there is a global routine called main

.text

.set noreorder

.ent main 	#this will tell the assembler where to enter the routine called main

main: 		#this is where main will begin
	addi t0, zero, 0
	addi v0, zero, 0		# //starting variable
	addi v1, zero, 0		# //overflow variable
	addi s1, zero, 0		# //incremented variable
	addi s2, zero, 0
	addi s3, zero, 400
				# //limit variable

even_sum:
    beq s1, s3, squared
    nop
    addi s1, s1, 2
    add v0,v0,s1
    b even_sum
    nop

squared:
    mult v0,v0
    mflo t0
    mfhi s2
    bgtz s2, overflow
    nop
    add v1,t0,zero
	b end_m
	nop
    
overflow:
    addi v1,zero,-1
	b end_m
	nop

end_m:

	nop					# this is an infinite loop
	b end_m
	nop	

.end main				# this is where main ends