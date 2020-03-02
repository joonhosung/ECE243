/* Program that counts consecutive 1's */

          .text                   // executable code follows
          .global _start
_start:
          MOV     R5, #0
          MOV     R3, #TEST_NUM   // load the data word ...
MAIN:     LDR     R1, [R3]        // into R1
          CMP     R1, #0          // See if we're at the end of the list
          BEQ     END             // Finish if at end
          BL      ONES            // If not, count ones!
          CMP     R5, R0          // Compare between largest 1 streak & current
          MOVLT   R5, R0          // If current is larger, delet old
          MOVLT   R4, R1          // Put largest value into R4 for debugging
          ADD     R3, #4          // Onto the next number
          B       MAIN
END:      B       END

// Subroutine to count consecutive ones
ONES:     MOV     R0, #0          // R0 will hold the result
LOOP:     CMP     R1, #0          // loop until the data contains no more 1's
          BXEQ    LR
          LSR     R2, R1, #1      // perform SHIFT, followed by AND
          AND     R1, R1, R2
          ADD     R0, #1          // count the string length so far
          B       LOOP

TEST_NUM: .word   0x103fe00f
          .word   0xffffffff     //We should end up with this. 32.
          .word   0x00000001
          .word   0x55555555
          .word   0x12345678
          .word   0x42042042
          .word   0x99999999
          .word   0x11111111
          .word   0x45673456
          .word   0x13540974
          .word   0x00000000
          .end
