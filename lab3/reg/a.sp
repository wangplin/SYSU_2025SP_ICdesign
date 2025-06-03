



.subckt inv vdd vss vi vo
XP vo vi vdd vdd p11ll_ckt w=330n l=40n $ PMOS
XN vo vi vss vss n11ll_ckt w=280n l=40n $ NMOS
.ends inv


.subckt tg vdd vss in out en en_b   * Transmission Gate (TG), en==1 gate pass
XN out in en vss n11ll_ckt w=280n l=40n * NMOS
XP out in en_b vdd p11ll_ckt w=330n l=40n * PMOS
.ends tg


.subckt nand2 vdd vss A B Y   * 2-input NAND gate
XP1 Y A vdd vdd p11ll_ckt w=330n l=40n * PMOS1
XP2 Y B vdd vdd p11ll_ckt w=330n l=40n * PMOS2
XN1 Y A net1 vss n11ll_ckt w=560n l=40n * NMOS1
XN2 net1 B vss vss n11ll_ckt w=560n l=40n * NMOS2
.ends nand2


.subckt nor2 vdd vss A B Y   * 2-input NOR gate
XP1 net1 A vdd vdd p11ll_ckt w=660n l=40n * PMOS1 (W加倍补偿串联电阻)
XP2 Y B net1 vdd p11ll_ckt w=660n l=40n * PMOS2
XN1 Y A vss vss n11ll_ckt w=280n l=40n * NMOS1
XN2 Y B vss vss n11ll_ckt w=280n l=40n * NMOS2
.ends nor2


.subckt mux2 vdd vss A B S Y   * 2:1 Multiplexer
* vdd = 电源, vss = 地
* A, B = 数据输入, S = 选择信号, Y = 输出
* 逻辑功能：Y = (A & ~S) | (B & S)
XINV_S vdd vss S S_bar inv
XTG1 vdd vss A Y S_bar S tg  * A通路（S=0时导通）
XTG2 vdd vss B Y S S_bar tg  * B通路（S=1时导通）
.ends mux2


.subckt init_reg vdd vss D Q clk clk_b   * init reg, without reset and enable
X_T1 vdd vss D n1 clk_b clk tg
X_inv_12 vdd vss n1 n2 inv
X_inv_24 vdd vss n2 n4 inv
X_T2 vdd vss n4 n1 clk clk_b tg
X_inv_56 vdd vss n5 Q inv
X_inv_68 vdd vss Q n8 inv
X_T3 vdd vss n2 n5 clk clk_b tg
X_T4 vdd vss n8 n5 clk_b clk tg
.ends init_reg

.subckt reg_without_en vdd vss D Q clk clk_b reset_b  * init reg, withoutenable
X_T1 vdd vss D n1 clk_b clk tg
X_inv_12 vdd vss n1 n2 inv
X_nand2_24 vdd vss n2 reset_b n4 nand2
X_T2 vdd vss n4 n1 clk clk_b tg
X_nand2_56 vdd vss n5 reset_b Q nand2
X_inv_68 vdd vss Q n8 inv
X_T3 vdd vss n2 n5 clk clk_b tg
X_T4 vdd vss n8 n5 clk_b clk tg
.ends reg_without_en

.subckt reg vdd vss D Q clk clk_b reset_b en * full reg
X_reg_wo_en vdd vss sel_D Q clk clk_b reset_b
X_mux2 vdd vss D Q S sel_D mux2  
.ends reg