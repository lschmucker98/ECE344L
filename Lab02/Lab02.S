#/************************************************************************/
#/* ECE 344L - Microprocessors – Spring 2020                           */
#/*                                                                      */
#/*                                                                      */
#/* Lab2.S -- General Description of file                                */
#/*                                                                      */
#/*                                                                      */
#/************************************************************************/
#/* Author(s): Landon Schmucker                                          */
#/*                                                                      */
#/************************************************************************/
#/*   Detailed File Description:                                         */
#/* This project does the following and uses the following resources and */
#/* has the following dependencies or limitations.                       */
#/*                                                                      */
#/************************************************************************/
#/*  Revision History: 2/18/2020 Started File                            */
#/*			          2/20/2020	Tried different methods					 */
#/*					  2/22/2020 Troubleshooting							 */
#/*					  2/24/2020 Verify working code						 */
#/************************************************************************/

#include <p32xxxx.h>

.globl main 	#this tells the assembler that there is a global routine called main

.data	#this tells the assembler that we're in the data section
	# All numbers must be given a type, 32 bit numbers are .long or .word
	numbers_to_use_1: .long -6,2,-4,9,5,18 #one vector of numbers to multiply
	numbers_to_use_2: .long -11,15,7,-8,13,20 #second vector of numbers to multiply
	/*These numbers will be stored in memory and
	accessed using saved word instructions.*/
.text

.set noreorder

.ent main 	#this will tell the assembler where to enter the routine called main

main:
	li t0, 0
	li t1, 0
	li t2, 0
	li t3, 0
	li t4, 0
	li t5, 0
	li t6, 0
	li t7, 0
	li s0, 0 #intiliaze all reigsters to zero to temporary store vector elements to they can be passed to the stack
	li s1, 0 #not all will be needed but just incase
	li s2, 0
	li s3, 0
	li s4, 0
	li s5, 0
	li s6, 0
	li s7, 0
	li v0, 0
	li v1, 0

	lw t0, numbers_to_use_1+0x00
	lw t1, numbers_to_use_1+0x04 
	lw t2, numbers_to_use_1+0x08 #load vetor elemnts in to a temporary register solely for the purpose of passing to stack
	lw t3, numbers_to_use_1+0x0C
	lw t4, numbers_to_use_1+0x10
	lw t5, numbers_to_use_1+0x14

	lw s1, numbers_to_use_2+0x00
	lw s2, numbers_to_use_2+0x04
	lw s3, numbers_to_use_2+0x08 #load vetor elements in to a temporary register solely for the purpose of passing to stack
	lw s4, numbers_to_use_2+0x0C
	lw s5, numbers_to_use_2+0x10
	lw s6, numbers_to_use_2+0x14

	addiu sp,sp,-100 #allocate space in the stack for all numbers, and extra to be safe
	sw t0, 0(sp)
	sw t1, 4(sp)
	sw t2, 8(sp)
	sw t3, 12(sp)
	sw t4, 16(sp)
	sw t5, 20(sp)
	sw s1, 24(sp)
	sw s2, 28(sp) #save all values from each vector to the stack
	sw s3, 32(sp)
	sw s4, 36(sp)
	sw s5, 40(sp)
	sw s6, 44(sp)
	sw ra, 48(sp) #save memory location
	nop
	jal dot_product
	nop
	lw ra, 48(sp)
	lw s0, 52(sp) #returns output from function
	lw s1, 56(sp)
	lw s2, 60(sp)
	addiu sp,sp, 100 #deallocate space in the stack
	
	b spin
	nop

dot_product:
	li s0, 0
	li s1, 0
	li s2, 0

	li a0, 0
	li a1, 0  #intiliaze first two function variables each time to be safe 
	#First Term
	lw a0, 0(sp)
	lw a1, 24(sp) #load first two terms from stack to function variables and execute multiplication and overflow check
	mult a0,a1
	mflo s7
	mfhi t6
	sra t7,s7,31
	bne t7,t6, overflow
	nop
	add v0,v0,s7 #store values to total current sum
	
	# code will repeat 6 times for 6 terms in each vector

	li a0, 0
	li a1, 0 
	#Second Term
	lw a0, 4(sp)
	lw a1, 28(sp)
	mult a0,a1
	mflo s7
	mfhi t6
	sra t7,s7,31
	bne t7,t6, overflow
	nop
	add v0,v0,s7
	
	li a0, 0
	li a1, 0 
	#Third Term
	lw a0, 8(sp)
	lw a1, 32(sp)
	mult a0,a1
	mflo s7
	mfhi t6
	sra t7,s7,31
	bne t7,t6, overflow
	nop
	add v0,v0,s7
	
	li a0, 0
	li a1, 0 
	#Fourth Term
	lw a0, 12(sp)
	lw a1, 36(sp)
	mult a0,a1
	mflo s7
	mfhi t6
	sra t7,s7,31
	bne t7,t6, overflow
	nop
	add v0,v0,s7
	
	li a0, 0
	li a1, 0 
	#Fifth Term
	lw a0, 16(sp)
	lw a1, 40(sp)
	mult a0,a1
	mflo s7
	mfhi t6
	sra t7,s7,31
	bne t7,t6, overflow
	nop
	add v0,v0,s7
	
	
	#Sixth Term
	lw a0, 20(sp)
	lw a1, 44(sp)
	mult a0,a1
	mflo s7
	mfhi t6
	sra t7,s7,31
	bne t7,t6, overflow
	nop
	add v0,v0,s7
	add s0,v0,zero
	add t7,ra,zero

	sw ra, 72(sp) #save the memory address so we know where to go after the function
	nop
	jal average #jump and like to the average function
	nop
	lw ra, 72(sp) #return the memory address
	lw v0, 64(sp) #load values from the stack which were the output of the average
	lw v1, 68(sp)
	
	li s1, 0
	li s2, 0 #intialize final value registers s1/s2 so correct results can be added
	li ra, 0 
	add ra,t7,zero #set ra to zero to wipe the ra from average and put back the ra from dotproduct
	add s1,v0,zero
	add s2,v1,zero
	sw s0, 52(sp)
	sw s1, 56(sp) #store all values from function to the stack
	sw s2, 60(sp)
	nop
	jr ra

average:
	li v0, 0
	li v1, 0
	li t0, 0
	li t1, 0
	li t2, 0
	li t3, 0 #reintialize any registers needed for code execution, basically temporary storing values
	li t4, 0
	li t5, 0
	li t6, 0
	li s4, 0
	
	lw t1,0(sp)
	lw t2,4(sp)
	lw t3,8(sp) #load values froms stack to temp registers
	lw t4,12(sp)
	lw t5,16(sp)
	lw t6,20(sp)
	
	addi s4,s4,6

	add v1,t1,t2
	add v1,v1,t3
	add v1,v1,t4 #repeatdely adding values to v1 till we get total sum
	add v1,v1,t5
	add v1,v1,t6
	div v1,s4 #dividing by 6 for average
	mflo v0
	
	lw t1,24(sp)
	lw t2,28(sp)
	lw t3,32(sp)
	lw t4,36(sp) #load values froms stack to temp registers
	lw t5,40(sp)
	lw t6,44(sp)

	add v1,t1,t2
	add v1,v1,t3
	add v1,v1,t4 #repeatdely adding values to v1 till we get total sum
	add v1,v1,t5
	add v1,v1,t6
	div v1,s4 #dividing by 6 for average
	mflo v1

	sw v0, 64(sp)
	sw v1, 68(sp) #save resuts to the stack
	nop
	jr ra #jump back to dotproduct function
overflow:
	addi v1,zero,-1
	b spin #if we overflow make v1 -1 to denot this then go to the infinite loop
	nop

spin:

	nop					# this is an infinite loop
	b spin
	nop	

.end main				# this is where main ends