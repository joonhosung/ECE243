.define LED_ADDRESS 0x1000
.define SW_ADDRESS 0x3000


// Counter to count until 2^9 using leds on the DE1-SoC
// Can use SW to get delay.

        mv    r6, #0                // Start counting from 0



MAIN:   mvt   r0, #LED_ADDRESS      // Point to LED reg address
        //ld    r6, [r0]              // Load value from LEDs
        add   r6, #1                // increment counter
        st    r6, [r0]              // Store count to LED



        mv    r3, #DELAY
        ld    r3, [r3]
OUTER:  mvt   r1, #SW_ADDRESS       // Read SW address
        ld    r4, [r1]              // load value from SW
        add   r4, #1                // add 1 to SW value in case 0

INNER:  sub   r4, #1                // decrement outer loop
        bne   #INNER                // If inner loop not 0, decrement again
        sub   r3, #1                // decrement outer loop
        bne   #OUTER                // If outer loop not 0, decrement again

        b     #MAIN

DELAY: .word  8888
