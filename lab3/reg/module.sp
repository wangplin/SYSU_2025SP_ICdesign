.title register


* .ic V(Xcell_0_2.bl_in) = 0V

.OPTIONS POST BRIEF
.OP
.LIB "/home/huanghq/tools/smic40_oa/smic40ll_1125_1tm_oa_cds_1P9M_2012_10_11_v1.4/models/hspice/l0040ll_v1p4_1r.lib" tt
.TEMP 25


.subckt inv vdd vss vi vo
XP vo vi vdd vdd p11ll_ckt w=330n l=40n $ PMOS
XN vo vi vss vss n11ll_ckt w=280n l=40n $ NMOS
.ends inv

.subckt inv2 vdd vss vi vo
XP vo vi vdd vdd p11ll_ckt w=660n l=40n $ PMOS
XN vo vi vss vss n11ll_ckt w=560n l=40n $ NMOS
.ends inv2


.subckt tg vdd vss in out en en_b   * Transmission Gate (TG), en==1 gate pass
XN out en in vss n11ll_ckt w=280n l=40n * NMOS
XP out en_b in vdd p11ll_ckt w=330n l=40n * PMOS
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

.subckt or2 vdd vss A B Y
* 中间节点用于连接 NOR 输出
X_NOR vdd vss A B net_nor nor2
X_INV vdd vss net_nor Y inv
.ends or2


.subckt and2 vdd vss A B Y
  XNAND vdd vss A B net_nand nand2
  XINV  vdd vss net_nand Y inv
.ends and2

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
X_inv_12 vdd vss n1 n2 inv2
X_inv_24 vdd vss n2 n4 inv2
X_T2 vdd vss n4 n1 clk clk_b tg
X_inv_56 vdd vss n5 Q inv
X_inv_68 vdd vss Q n8 inv
X_T3 vdd vss n2 n5 clk clk_b tg
X_T4 vdd vss n8 n5 clk_b clk tg
.ends init_reg

.subckt reg_without_en vdd vss D Q clk clk_b reset_b  * init reg, withoutenable
X_T1 vdd vss D n1 clk_b clk tg
X_inv_12 vdd vss n1 n2 inv2
X_nand2_24 vdd vss n2 reset_b n4 nand2
X_T2 vdd vss n4 n1 clk clk_b tg
X_nand2_56 vdd vss n5 reset_b Q nand2
X_inv_68 vdd vss Q n8 inv
X_T3 vdd vss n2 n5 clk clk_b tg
X_T4 vdd vss n8 n5 clk_b clk tg
.ends reg_without_en

.subckt reg vdd vss clk clk_b reset_b en D Q * full reg
X_reg_wo_en vdd vss sel_D Q clk clk_b reset_b reg_without_en
X_mux2 vdd vss D Q en sel_D mux2  
.ends reg


.subckt reg_array_8 VDD VSS CLK CLK_B RESET_N ENABLE D_7 D_6 D_5 D_4 D_3 D_2 D_1 D_0 Q_7 Q_6 Q_5 Q_4 Q_3 Q_2 Q_1 Q_0
X_reg0 VDD VSS CLK CLK_B RESET_N ENABLE D_0 Q_0 reg
X_reg1 VDD VSS CLK CLK_B RESET_N ENABLE D_1 Q_1 reg
X_reg2 VDD VSS CLK CLK_B RESET_N ENABLE D_2 Q_2 reg
X_reg3 VDD VSS CLK CLK_B RESET_N ENABLE D_3 Q_3 reg
X_reg4 VDD VSS CLK CLK_B RESET_N ENABLE D_4 Q_4 reg
X_reg5 VDD VSS CLK CLK_B RESET_N ENABLE D_5 Q_5 reg
X_reg6 VDD VSS CLK CLK_B RESET_N ENABLE D_6 Q_6 reg
X_reg7 VDD VSS CLK CLK_B RESET_N ENABLE D_7 Q_7 reg
.ends reg_array_8


.subckt decoder_2to4 vdd vss IN1 IN0 Y3 Y2 Y1 Y0

* 中间节点（反相输出）
XINV_IN1 vdd vss IN1 IN1n inv
XINV_IN0 vdd vss IN0 IN0n inv

* AND 实现（使用 nand2 + inv）

* Y0 = !IN1 & !IN0 => NAND(IN1n, IN0n) + INV
XNAND0 vdd vss IN1n IN0n net0 nand2
XINV0  vdd vss net0 Y0 inv

* Y1 = !IN1 & IN0 => NAND(IN1n, IN0) + INV
XNAND1 vdd vss IN1n IN0 net1 nand2
XINV1  vdd vss net1 Y1 inv

* Y2 = IN1 & !IN0 => NAND(IN1, IN0n) + INV
XNAND2 vdd vss IN1 IN0n net2 nand2
XINV2  vdd vss net2 Y2 inv

* Y3 = IN1 & IN0 => NAND(IN1, IN0) + INV
XNAND3 vdd vss IN1 IN0 net3 nand2
XINV3  vdd vss net3 Y3 inv

.ends decoder_2to4



.subckt decoder_2to4_o0 vdd vss IN1 IN0 Y3 Y2 Y1 Y0

* 输入反相器
XINV0 vdd vss IN0 IN0n inv
XINV1 vdd vss IN1 IN1n inv

* 输出：低电平有效，使用 NOR 门

* Y0 = !(IN0 + IN1)
XNOR0 vdd vss IN0 IN1 Y0 nor2

* Y1 = !(IN0n + IN1)
XNOR1 vdd vss IN0n IN1 Y1 nor2

* Y2 = !(IN0 + IN1n)
XNOR2 vdd vss IN0 IN1n Y2 nor2

* Y3 = !(IN0n + IN1n)
XNOR3 vdd vss IN0n IN1n Y3 nor2

.ends decoder_2to4_o0

.subckt decoder_2to4_o0_new vdd vss IN1 IN0 Y3 Y2 Y1 Y0

X_decoder_2to4 vdd vss IN1 IN0 YY3 YY2 YY1 YY0 decoder_2to4

XINV3 vdd vss YY3 Y3 inv
XINV2 vdd vss YY2 Y2 inv
XINV1 vdd vss YY1 Y1 inv
XINV0 vdd vss YY0 Y0 inv

.ends decoder_2to4_o0_new



.subckt mux4to1_old vdd vss D0 D1 D2 D3 S0 S1 Y
* 反相S0和S1
XINV_S0 vdd vss S0 S0n inv
XINV_S1 vdd vss S1 S1n inv
* 中间节点
* 使用传输门选择数据线
* M0: S1=0, S0=0
XSEL0 vdd vss D0 Y S1nS0n S1nS0n_b tg
XAND0_S vdd vss S1n S0n S1nS0n nand2
XINV_SEL0 vdd vss S1nS0n S1nS0n_b inv
* M1: S1=0, S0=1
XSEL1 vdd vss D1 Y S1nS0 S1nS0_b tg
XAND1_S vdd vss S1n S0 S1nS0 nand2
XINV_SEL1 vdd vss S1nS0 S1nS0_b inv
* M2: S1=1, S0=0
XSEL2 vdd vss D2 Y S1S0n S1S0n_b tg
XAND2_S vdd vss S1 S0n S1S0n nand2
XINV_SEL2 vdd vss S1S0n S1S0n_b inv
* M3: S1=1, S0=1
XSEL3 vdd vss D3 Y S1S0 S1S0_b tg
XAND3_S vdd vss S1 S0 S1S0 nand2
XINV_SEL3 vdd vss S1S0 S1S0_b inv
.ends mux4to1_old


* 3. 定义4选1 MUX
.subckt mux4to1 vdd vss S1 S0 D0 D1 D2 D3 OUT
* 生成选择信号
XDEC vdd vss S1 S0 SEL3 SEL2 SEL1 SEL0 decoder_2to4
* 实现数据选择
* AND功能使用NAND+INV实现
XNAND_D0 vdd vss D0 SEL0 NAND_D0 nand2
XINV_D0 vdd vss NAND_D0 AND_D0 inv

XNAND_D1 vdd vss D1 SEL1 NAND_D1 nand2
XINV_D1 vdd vss NAND_D1 AND_D1 inv

XNAND_D2 vdd vss D2 SEL2 NAND_D2 nand2
XINV_D2 vdd vss NAND_D2 AND_D2 inv

XNAND_D3 vdd vss D3 SEL3 NAND_D3 nand2
XINV_D3 vdd vss NAND_D3 AND_D3 inv

* OR功能使用NOR+INV实现
XNOR_OUT1 vdd vss AND_D0 AND_D1 NOR_OUT1 nor2
XINV_OUT1 vdd vss NOR_OUT1 OR_OUT1 inv

XNOR_OUT2 vdd vss AND_D2 AND_D3 NOR_OUT2 nor2
XINV_OUT2 vdd vss NOR_OUT2 OR_OUT2 inv

* 最终OR
XNOR_FINAL vdd vss OR_OUT1 OR_OUT2 NOR_FINAL nor2
XINV_FINAL vdd vss NOR_FINAL OUT inv
.ends mux4to1

.subckt mux4to1_8bit vdd vss \
  D0_7 D0_6 D0_5 D0_4 D0_3 D0_2 D0_1 D0_0 \
  D1_7 D1_6 D1_5 D1_4 D1_3 D1_2 D1_1 D1_0 \
  D2_7 D2_6 D2_5 D2_4 D2_3 D2_2 D2_1 D2_0 \
  D3_7 D3_6 D3_5 D3_4 D3_3 D3_2 D3_1 D3_0 \
  S0 S1 \
  Y7 Y6 Y5 Y4 Y3 Y2 Y1 Y0

* 每一位使用一个mux4to1
XMUX0 vdd vss S1 S0 D0_0 D1_0 D2_0 D3_0  Y0 mux4to1
XMUX1 vdd vss S1 S0 D0_1 D1_1 D2_1 D3_1  Y1 mux4to1
XMUX2 vdd vss S1 S0 D0_2 D1_2 D2_2 D3_2  Y2 mux4to1
XMUX3 vdd vss S1 S0 D0_3 D1_3 D2_3 D3_3  Y3 mux4to1
XMUX4 vdd vss S1 S0 D0_4 D1_4 D2_4 D3_4  Y4 mux4to1
XMUX5 vdd vss S1 S0 D0_5 D1_5 D2_5 D3_5  Y5 mux4to1
XMUX6 vdd vss S1 S0 D0_6 D1_6 D2_6 D3_6  Y6 mux4to1
XMUX7 vdd vss S1 S0 D0_7 D1_7 D2_7 D3_7  Y7 mux4to1
.ends mux4to1_8bit


.subckt or_array4 vdd vss A3 A2 A1 A0 B3 B2 B1 B0 Y3 Y2 Y1 Y0 
X_or20 vdd vss A0 B0 Y0 or2
X_or21 vdd vss A1 B1 Y1 or2
X_or22 vdd vss A2 B2 Y2 or2
X_or23 vdd vss A3 B3 Y3 or2
.ends or_array4

.subckt reg_file vdd vss clk clk_b reset_n
+ w_en w_addr<1> w_addr<0> w_data<7> w_data<6> w_data<5> w_data<4> w_data<3> w_data<2> w_data<1> w_data<0>
+ r_addr0<1> r_addr0<0> r_data0<7> r_data0<6> r_data0<5> r_data0<4> r_data0<3> r_data0<2> r_data0<1> r_data0<0>
+ r_addr1<1> r_addr1<0> r_data1<7> r_data1<6> r_data1<5> r_data1<4> r_data1<3> r_data1<2> r_data1<1> r_data1<0>

X_w_decoder_2to4_o0 vdd vss w_addr<1> w_addr<0> PRE_WEN<3> PRE_WEN<2> PRE_WEN<1> PRE_WEN<0> decoder_2to4_o0_new
X_w_or_array4 vdd vss w_en w_en w_en w_en PRE_WEN<3> PRE_WEN<2> PRE_WEN<1> PRE_WEN<0> WEN<3> WEN<2> WEN<1> WEN<0> or_array4


X_reg_8_0 vdd vss clk clk_b reset_n WEN<0> w_data<7> w_data<6> w_data<5> w_data<4> w_data<3> w_data<2> w_data<1> w_data<0> Q0_7 Q0_6 Q0_5 Q0_4 Q0_3 Q0_2 Q0_1 Q0_0 reg_array_8
X_reg_8_1 vdd vss clk clk_b reset_n WEN<1> w_data<7> w_data<6> w_data<5> w_data<4> w_data<3> w_data<2> w_data<1> w_data<0> Q1_7 Q1_6 Q1_5 Q1_4 Q1_3 Q1_2 Q1_1 Q1_0 reg_array_8
X_reg_8_2 vdd vss clk clk_b reset_n WEN<2> w_data<7> w_data<6> w_data<5> w_data<4> w_data<3> w_data<2> w_data<1> w_data<0> Q2_7 Q2_6 Q2_5 Q2_4 Q2_3 Q2_2 Q2_1 Q2_0 reg_array_8
X_reg_8_3 vdd vss clk clk_b reset_n WEN<3> w_data<7> w_data<6> w_data<5> w_data<4> w_data<3> w_data<2> w_data<1> w_data<0> Q3_7 Q3_6 Q3_5 Q3_4 Q3_3 Q3_2 Q3_1 Q3_0 reg_array_8

X0_out_mux4to1_8bit vdd vss Q0_7 Q0_6 Q0_5 Q0_4 Q0_3 Q0_2 Q0_1 Q0_0 Q1_7 Q1_6 Q1_5 Q1_4 Q1_3 Q1_2 Q1_1 Q1_0 Q2_7 Q2_6 Q2_5 Q2_4 Q2_3 Q2_2 Q2_1 Q2_0 Q3_7 Q3_6 Q3_5 Q3_4 Q3_3 Q3_2 Q3_1 Q3_0 r_addr0<0> r_addr0<1> r_data0<7> r_data0<6> r_data0<5> r_data0<4> r_data0<3> r_data0<2> r_data0<1> r_data0<0> mux4to1_8bit
X1_out_mux4to1_8bit vdd vss Q0_7 Q0_6 Q0_5 Q0_4 Q0_3 Q0_2 Q0_1 Q0_0 Q1_7 Q1_6 Q1_5 Q1_4 Q1_3 Q1_2 Q1_1 Q1_0 Q2_7 Q2_6 Q2_5 Q2_4 Q2_3 Q2_2 Q2_1 Q2_0 Q3_7 Q3_6 Q3_5 Q3_4 Q3_3 Q3_2 Q3_1 Q3_0 r_addr1<0> r_addr1<1> r_data1<7> r_data1<6> r_data1<5> r_data1<4> r_data1<3> r_data1<2> r_data1<1> r_data1<0> mux4to1_8bit

.ends reg_file



.END