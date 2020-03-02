/* Program that counts consecutive 1's */

          .text                   // executable code follows
          .global _start
_start:
          MOV     R5, #0          // Ones
          MOV     R6, #0          // Zeros
          MOV     R7, #0          // Alternating
          MOV     R3, #TEST_NUM   // load the data word ...
MAIN:     LDR     R1, [R3]        // into R1
          CMP     R1, #0          // See if we're at the end of the list
          BEQ     END             // Finish if at end
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
