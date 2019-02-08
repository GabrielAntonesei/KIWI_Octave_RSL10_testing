/* ----------------------------------------------------------------------------
 * Copyright (c) 2017 Semiconductor Components Industries, LLC (d/b/a
 * ON Semiconductor), All Rights Reserved
 *
 * This code is the property of ON Semiconductor and may not be redistributed
 * in any form without prior written permission from ON Semiconductor.
 * The terms of use and warranty for this code are covered by contractual
 * agreements between ON Semiconductor and the licensee.
 *
 * This is Reusable Code.
 *
 * -----------------------------------------------------------------------------
 */

// initialisation before entering the main function.
.text global 0 _main_init
      r = 1          // enable rounding
      s = 1          // enable saturation
      sp = _sp_start_value_DMA // init SP (adjusted to stack in lpdsp.bcf)	
      ie = 1  ; nop  // enable interrupts

// area to load main() arguments 
.bss global 0 _main_argv_area DMA 256

.undef global text isr0

// the interrupt vector table with 15 interrupts
.text global 0 _ivt
	jp _main_init    // 0  - reset
	reti ; nop       // 2  - interrupt 1
	reti ; nop       // 4  - interrupt 2
	reti ; nop       // 6  - interrupt 3
	reti ; nop       // 8  - interrupt 4
	reti ; nop       // 10 - interrupt 5
	reti ; nop       // 12 - interrupt 6
	reti ; nop       // 14 - interrupt 7
	reti ; nop       // 16 - interrupt 8
	reti ; nop       // 18 - interrupt 9
	jp isr0          // 20 - interupt 10 mapped to ISR from ARM
	reti ; nop       // 22 - interrupt 11
	reti ; nop       // 24 - interrupt 12
	reti ; nop       // 26 - interrupt 13
	reti ; nop       // 28 - interrupt 14
	reti ; nop       // 30 - interrupt 15

