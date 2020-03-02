
           .text                   // executable code follows
           .global _start
 _start:
           MOV     R5, #0          // Ones
           MOV     R6, #0          // Zeros
           MOV     R7, #0          // Alternating
           MOV     R3, #TEST_NUM   // load the data word ...
 MAIN:     LDR     R1, [R3]        // into R1
           CMP     R1, #0          // See if we're at the end of the list
           BEQ     DISPLAY         // Print when done!
           BL      ONES            // If not, count ones!
           CMP     R5, R0          // Compare between largest 1 streak & current
           MOVLT   R5, R0          // If current is larger, delet old
           LDR     R1, [R3]        // Restore value
           BL      ZEROS
           CMP     R6, R0
           MOVLT   R6, R0
           LDR     R1, [R3]        // Restore value
           BL      ALT
           CMP     R7, R0
           MOVLT   R7, R0
           ADD     R3, #4          // Onto the next number
           B       MAIN
 END:      B       END

 // Subroutine to count consecutive ones
 ONES:     MOV     R0, #0          // R0 will hold the result
 LOOPO:    CMP     R1, #0          // loop until the data contains no more 1's
           BXEQ    LR
           LSR     R2, R1, #1      // perform SHIFT, followed by AND
           AND     R1, R1, R2
           ADD     R0, #1          // count the string length so far
           B       LOOPO

 // Subroutine to count consecutive zeros
 ZEROS:    MOV     R0, #0          // R0 will hold the result
           MVN     R1, R1          // Complement register, so ONES = !ZEROS
 LOOPZ:    CMP     R1, #0          // loop until the data contains no more 1's
           BXEQ    LR
           LSR     R2, R1, #1      // perform SHIFT, followed by AND
           AND     R1, R1, R2
           ADD     R0, #1          // count the string length so far
           B       LOOPZ

 // Subroutine to count alternating 1s and 0s
 ALT:      MOV     R0, #0
           MOV     R4, #ALT_CMP   // Temp. storage of ALT_CMP and value of ONES
           LDR     R4, [R4]
           EOR     R1, R4, R1     // Get XOR of ALT_CMP and values.
           PUSH    {LR, R1}       // Store LR for BL and R1 to use later
           BL      ONES           // Get the total number of ones from above EOR
           MOV     R4, R0         // Store result of ONES in R4
           POP     {R1}           // Restore XOR result since ONES overwrites R1
           BL      ZEROS          // Get total number of zeros from above EOR
           POP     {LR}           // Restore LR
           CMP     R0, R4         // Compare results from ZEROS and ONES
           MOVLT   R0, R4         // if R0 < R4 then R0 <= R4
           BX      LR             // We're done, return back to MAIN.


/* Subroutine to convert the digits from 0 to 9 to be shown on a HEX display.
*    Parameters: R0 = the decimal value of the digit to be displayed
*    Returns: R0 = bit patterm to be written to the HEX display
*/
SEG7_CODE:  MOV     R1, #BIT_CODES
            ADD     R1, R0         // index into the BIT_CODES "array"
            LDRB    R0, [R1]       // load the bit pattern (to be returned)
            MOV     PC, LR


/* Display R5 on HEX1-0, R6 on HEX3-2 and R7 on HEX5-4 */
DISPLAY:    LDR     R8, =0xFF200020 // base address of HEX3-HEX0
            MOV     R0, R5          // display R5 on HEX1-0
            BL      DIVIDE          // ones digit will be in R0; tens
                                    // digit in R1
            MOV     R9, R1          // save the tens digit
            BL      SEG7_CODE
            MOV     R4, R0          // save bit code for 1s
            MOV     R0, R9          // retrieve the tens digit, get bit code
            BL      SEG7_CODE
            LSL     R0, #8          // Shift 1 bit
            ORR     R4, R0

            MOV     R0, R6          // Now for R6
            BL      DIVIDE          // Get decimal value of R6,
            MOV     R9, R1          // Save 10s digit!
            BL      SEG7_CODE
            MOV     R10, R0         // Save bit code
            MOV     R0, R9          // Get 10s digit for R6
            BL      SEG7_CODE       // Now retrieve bit code for 10s digit
            LSL     R0, #8          // Shift 10s digit by 1 byte for display
            ORR     R10, R0         // Merge 10s & 1s digits in 16-bit (2 byte) value
            LSL     R10, #16        // Shift this value by 2 bytes for display
            ORR     R4, R10         // Merge R5 and R6!!
            STR     R4, [R8]        // display R4 above to HEX3-0

            LDR     R8, =0xFF200030 // base address of HEX5-HEX4
            MOV     R0, R7
            BL      DIVIDE          // R7 / 10 => R1 ... R0
            MOV     R9, R1          // Save 10s digit
            BL      SEG7_CODE       // Retrieve bit code for 10s digit
            MOV     R4, R0          // Save 1s digit bit code into R4
            MOV     R0, R9          // Get 10s digit!
            BL      SEG7_CODE       // Retrieve bit code for 1s digit!
            LSL     R0, #8          // Shift 1 byte for 10s digit
            ORR     R4, R0          // combine 10s and 1s digit into R4
            STR     R4, [R8]        // display the number from R7!!
            BX      LR              // Return back!

DIVIDE:    MOV    R1, #0
LUP:       CMP    R0, #10        // Check if not divisible by 10!
           BXLT   LR
           SUBS   R0, #10        // Division by 10
           ADD    R1, #1         // Add quotient
           B      LUP            // Repeat

BIT_CODES:.byte   0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110
          .byte   0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01100111
          .skip   2      // pad with 2 bytes to maintain word alignment

ALT_CMP:  .word   0x55555555     //Alternating 0s and 1s for ALT

                                       //Ones|Zeros|Alternating      O |Z |A
TEST_NUM: .word   0x103fe00f     //0b00010000001111111110000000001111 09|09|03
          .word   0xffffffff     //0b11111111111111111111111111111111 20|00|00
          .word   0x00000001     //0b00000000000000000000000000000001 01|1f|02
          .word   0x23345298     //0b00100011001101000101001010011000 03|02|05
          .word   0x12345678     //0b00010010001101000101011001111000 03|04|06
          .word   0x42042042     //0b01000010000001000010000001000010 01|06|03
          .word   0x99999999     //0b10011001100110011001100110011001 02|02|02
          .word   0x11111111     //0b00010001000100010001000100010001 01|03|03
          .word   0x15673456     //0b00010101011001110011010001010110 02|03|08
          .word   0x13540974     //0b00010011010101000000100101110100 02|06|08
          .word   0x00000000
          .end
