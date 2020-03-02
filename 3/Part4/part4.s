
/* Program that converts a binary number to decimal */
          .text // executable code follows
          .global _start
_start:
          MOV  R4, #N
          MOV  R5, #Digits     // R5 points to the decimal digits storage location
          LDR  R4, [R4]        // R4 holds N
          MOV  R0, R4          // parameter for DIVIDE goes in R0
          MOV  R1, #10         // Store divisor
          BL   CONVERT         // Go to the CONVERT subroutine
END:      B END


CONVERT:  BL DIVIDE
          STRB R0, [R5]       // Nth digit is in R0
          MOV  R0, R2
          ADD  R5, #1
          SUBS R6, #1         // 1 less digit to worry about!
          MOVNE pc, #CONVERT  // if more digits left, go back to converting loop!
          BEQ END             // if done, end!

DIVIDE:   MOV R2, #0
CONT:     CMP R0, R1          // See if divisible
          MOVLT PC, LR             // Go back to CONVERT if N not divisible by R1 aonymore!!
          SUB R0, R1         // Subtract that baby
          ADD R2, #1          // increment quotient
          B CONT


N:        .word 9876          // the decimal number to be converted
Digits:   .space 8            // storage space for the decimal digits

          .end
