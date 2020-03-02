
/* Program that finds the largest number in a list of integers */
          .text     // executable code follows
          .global   _start
_start:
          MOV R4, #RESULT     // R4 points to result location
          LDR R0, [R4, #4]    // R0 holds the number of elements in the list
          MOV R1, #NUMBERS    // R1 points to the start of the list
          BL LARGE
          STR R0, [R4]        // R0 holds the subroutine return value
END:      B END

// R2 holds value of largest integer
// R3 holds value of next integer
LARGE:    MOV R2, #0
LOOP:     SUBS R0, #1         // decrement the number of elements left
          BEQ DONE            // if result is equal to 0, branch
          ADD R1, #4
          LDR R3, [R1]        // get the next number
          CMP R2, R3          // check if larger number found
          BGE LOOP
          MOV R2, R3          // If R2 is not larger, update the largest number
          B LOOP
DONE:     MOV R0, R2          // Finally, return value to R0
          mov PC, LR          // Return back!

RESULT:   .word 0
N:        .word 7             // number of entries in the list
NUMBERS:  .word 4, 5, 3, 6    // the data
          .word 1, 8, 2
          .end
