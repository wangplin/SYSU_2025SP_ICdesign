.OPTIONS POST BRIEF

.OP
.LIB "/home/htj/smic40_oa/smic40ll_1125_1tm_oa_cds_1P9M_2012_10_11_v1.4/models/hspice/l0040ll_v1p4_1r.lib" tt
.TEMP 25

VDD vdd 0 DC 1.1

VIN lin 0 PULSE(0 1.1 0 10p 10p 5n 10n)

.TRAN 0.01n 50n UIC

.OPTIONS POST
.PRINT TRAN V(lin) V(lout)

.PARAM mos_w=330n
.PARAM mos_l=40n
.PARAM nmos_w=1200n
.PARAM nmos_l=120n
.PARAM pmos_w=1400n
.PARAM pmos_l=120n


.subckt INV A Y VDD GND
XP1 Y A VDD VDD p11ll_ckt W=mos_w*2 L=mos_l*2
XN1 Y A GND GND n11ll_ckt W=nmos_w*2 L=nmos_l*2
.ends

*00 01 10 11 1N
VSE1 A0 0 PULSE(0 1.1 0 10p 10p 1n 2.5n)

XINV1 A0 OUT VDD GND INV



.PRINT TRAN V(A0) V(OUT)

*C0 lout 0 1

.end
