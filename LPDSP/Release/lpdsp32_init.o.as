
// File generated by darts version O-2018.09#c3302020d9#181023, Fri Dec 14 15:42:42 2018
// Copyright 2014-2018 Synopsys, Inc. All rights reserved.
// C:\Synopsys\ASIP Programmer\O-2018.09-SP1\win64\bin\WINbin\darts.exe -B -IC:/Synopsys/lpdsp32-v3_vO-2018.09_windows/lpdsp32-v3_vO-2018.09/lib +p -d -IC:/Synopsys/lpdsp32-v3_vO-2018.09_windows/lpdsp32-v3_vO-2018.09/lib/runtime/include -D__tct_patch__=100 Release/lpdsp32_init.o lpdsp32

// Release: ipp O-2018.09-SP1
.text_segment_name
.text global 2 _main_init
	/*      0 "10111010000100010010" */    r = 1
	/*      1 "10111010000100010011" */    s = 1
	/*      2 "01101000000000000000" */    sp = _sp_start_value_DMA
	/*      3 "00000000000000111000" */    /* MW */
.label _main_init__end last
	/*      4 "01000110000010001000" */    ie = 1; nop
	/*      5 "00111000000000000000" */    /* MW */

.text_segment_name
.text global 2 _ivt
	/*      0 "01100100000000000000" */    jp _main_init
	/*      1 "00000000000000000111" */    /* MW */
	/*      2 "01000110000010110000" */    reti; nop
	/*      3 "00111000000000000000" */    /* MW */
	/*      4 "01000110000010110000" */    reti; nop
	/*      5 "00111000000000000000" */    /* MW */
	/*      6 "01000110000010110000" */    reti; nop
	/*      7 "00111000000000000000" */    /* MW */
	/*      8 "01000110000010110000" */    reti; nop
	/*      9 "00111000000000000000" */    /* MW */
	/*     10 "01000110000010110000" */    reti; nop
	/*     11 "00111000000000000000" */    /* MW */
	/*     12 "01000110000010110000" */    reti; nop
	/*     13 "00111000000000000000" */    /* MW */
	/*     14 "01000110000010110000" */    reti; nop
	/*     15 "00111000000000000000" */    /* MW */
	/*     16 "01000110000010110000" */    reti; nop
	/*     17 "00111000000000000000" */    /* MW */
	/*     18 "01000110000010110000" */    reti; nop
	/*     19 "00111000000000000000" */    /* MW */
	/*     20 "01100100000000000000" */    jp isr0
	/*     21 "00000000000000000111" */    /* MW */
	/*     22 "01000110000010110000" */    reti; nop
	/*     23 "00111000000000000000" */    /* MW */
	/*     24 "01000110000010110000" */    reti; nop
	/*     25 "00111000000000000000" */    /* MW */
	/*     26 "01000110000010110000" */    reti; nop
	/*     27 "00111000000000000000" */    /* MW */
	/*     28 "01000110000010110000" */    reti; nop
	/*     29 "00111000000000000000" */    /* MW */
.label _ivt__end last
	/*     30 "01000110000010110000" */    reti; nop
	/*     31 "00111000000000000000" */    /* MW */

.data_segment_name
.bss global 0 _main_argv_area DMA 256

.undef global text isr0

.undef global data _sp_start_value_DMA

.undef global data _sp_start_value_DMA

