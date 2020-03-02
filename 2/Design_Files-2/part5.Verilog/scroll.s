.define LED_ADDRESS 0x1000
.define HEX_ADDRESS 0x2000
.define SW_ADDRESS 0x3000
.define STACK 256							// bottom of memory

// This code scrolls back and forth the letters dE10 across the 7-segment displays
// and also displays a count on the red LEDs
			mv 	r6, #STACK				// used as a stack pointer
 			mvt 	r1, #0xFF00
 			add 	r1, #0xFF				// r1 = 0xFFFF
			mv		r0, #1					// constant K for -- and ++ of character pointer
 			mv 	r2, #FIRST				// point to the character '0' 

MAIN:		mv		r5, r2					// point to the first letter in this loop iteration
 			mvt	r4, #HEX_ADDRESS		// address of HEX0 

			sub	r6, #1					// save value of r0 on the stack
			st		r0, [r6]
			sub	r6, #1					// save value of r2 on the stack
			st		r2, [r6]

// Loop over the six HEX displays
			mv 	r0, #6					// used to count the HEX displays
LOOP:		ld		r3, [r5]					// get letter 
 			st		r3, [r4]					// send to HEX display
 			add	r5, #1					// ++increment character pointer 
 			add	r4, #1					// point to next HEX display
			sub	r0, #1
			bne	#LOOP				      // next loop iteration
			
			ld		r2, [r6]					// restore saved values of r0 and r2
			add	r6, #1
			ld		r0, [r6]
			add	r6, #1

 			sub	r2, r0					// use K to scroll the characters
 			mv 	r5, #LEFT	 			// reverse direction condition 
 			sub	r5, r2					// scrolled all the way to the left?
 			bne	#SKIP				      // no, so don't reverse direction yet
 			add	r2, #1 					// yes, so reverse to scroll to the right
 			add	r2, #1
 			mv 	r5, r1			 		// 0xFFFF is needed for making -K 
 			sub	r5, r0  					// r5 = complement of r0 
 			add	r5, #1  					// r5 = -r0 
 			mv		r0, r5					// K = -K 
SKIP:		mv 	r5, #RIGHT	 			// reverse direction condition 
 			sub	r5, r2					// scrolled all the way to the right?
 			bne	#CONT						// no, so don't reverse direction yet 
 			sub	r2, #1 					// yes, so reverse to scroll to the left
 			sub	r2, #1
 			mv 	r5, r1		 			// 0xFFFF is needed for making -K 
 			sub	r5, r0  					// r5 = complement of r0 
 			add	r5, #1  					// r5 = -r0 
 			mv		r0, r5					// K = -K 

CONT:		sub	r6, #1					// save r0 onto stack
			st		r0, [r6]
			mvt	r3, #LED_ADDRESS		// LED reg address 
 			st		r2, [r3]					// write address pointer to LEDs 

// Delay loop for controlling speed of scrolling
			mv		r3, #DELAY
 			ld		r3, [r3]					// delay counter 
OUTER:	mvt	r0, #SW_ADDRESS		// point to SW port 
			ld		r4, [r0]					// load inner loop delay from SW 
			add	r4, #1					// in case 0 was read
INNER:	sub	r4, #1					// decrement inner loop counter 
 			bne	#INNER					// continue inner loop 
 			sub	r3, #1					// decrement outer loop counter 
 			bne	#OUTER					// continue outer loop 

			ld		r0, [r6]					// restore r0
			add	r6, #1
			b	 	#MAIN 					// execute again 

DELAY:	.word	8888
LEFT: 	.word 0
			.word 0
			.word 0
			.word 0
			.word 0
			.word 0
			.word 0
			.word 0
			.word 0b0000000001001111	// '3'
			.word 0b0000000001100110	// '4'
      	.word 0b0000000001011011	// '2'
FIRST:	.word 0b0000000001000000	// '-'
			.word	0b0000000001111001	// 'E'
			.word	0b0000000000111001	// 'C'
			.word	0b0000000001111001	// 'E'
			.word	0
			.word	0
RIGHT:	.word	0
