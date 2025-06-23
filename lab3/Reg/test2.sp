* Square Wave Generator with .tr0 output
.option post=2 probe     * 必须设置post=2才能生成.tr0文件
.option runlvl=6         * 确保输出所有波形数据
.include "module.sp"

* 定义方波电压源 (周期10ns, 50%占空比)
V1 out 0 PULSE(0 1 0 0.01n 0.01n 4.99n 10n)
V2 out1 0 PULSE(0 1 6n 0.01n 0.01n 1n 10n)

VCLK CLK 0 PULSE(0 1.1 5n 0.01n 0.01n 4.99n 10n)
VCLK_INV CLK_B 0 PULSE(0 1.1 0n 0.01n 0.01n 4.99n 10n)

Vdd vdd 0 DC 1.1      * 1.8V 电压源，连接到 vdd_0 节点（电源）
Vss vss 0 DC 0          * 0V 电压源，连接到 vss 节点（地）



V_RESET_N reset_n VSS PWL(
+ 24.99n 0.0 25.0n 1.1
+ 74.99n 1.1 75.0n 1.1
+ 105.0n 1.1
)

V_W_EN w_en VSS PWL(
+ 4.99n 0.0 5.0n 1.1
+ 24.99n 1.1 25.0n 0.0
+ 64.99n 0.0 65.0n 1.1
+ 74.99n 1.1 75.0n 1.1
+ 105.0n 1.1
)

V_w_addr<1> w_addr<1> VSS PWL(
+ 44.99n 0.0 45.0n 1.1
+ 64.99n 1.1 65.0n 0.0
+ 105.0n 0.0
)

V_w_addr<0> w_addr<0> VSS PWL(
+ 34.99n 0.0 35.0n 1.1
+ 44.99n 1.1 45.0n 0.0
+ 54.99n 0.0 55.0n 1.1
+ 64.99n 1.1 65.0n 0.0
+ 105.0n 0.0
)

V_w_data<7> w_data<7> VSS PWL(
+ 105.0n 0.0
)
V_w_data<6> w_data<6> VSS PWL(
+ 105.0n 0.0
)
V_w_data<5> w_data<5> VSS PWL(
+ 105.0n 0.0
)
V_w_data<4> w_data<4> VSS PWL(
+ 105.0n 0.0
)
V_w_data<3> w_data<3> VSS PWL(
+ 54.99n 0.0 55.0n 1.1
+ 64.99n 1.1 65.0n 0.0
+ 105.0n 0.0
)
V_w_data<2> w_data<2> VSS PWL(
+ 44.99n 0.0 45.0n 1.1
+ 54.99n 1.1 55.0n 0.0
+ 105.0n 0.0
)
V_w_data<1> w_data<1> VSS PWL(
+ 34.99n 0.0 35.0n 1.1
+ 44.99n 1.1 45.0n 0.0
+ 105.0n 0.0
)
V_w_data<0> w_data<0> VSS PWL(
+ 24.99n 0.0 25.0n 1.1
+ 34.99n 1.1 35.0n 0.0
+ 105.0n 0.0
)

V_r_addr0<1> r_addr0<1> VSS PWL(
+ 34.99n 0.0 35.0n 1.1
+ 44.99n 1.1 45.0n 0.0
+ 105.0n 0.0
)

V_r_addr0<0> r_addr0<0> VSS PWL(
+ 54.99n 0.0 55.0n 1.1
+ 64.99n 1.1 65.0n 0.0
+ 105.0n 0.0
)

V_r_addr1<1> r_addr1<1> VSS PWL(
+ 34.99n 0.0 35.0n 1.1
+ 64.99n 1.1 65.0n 0.0
+ 105.0n 0.0
)

V_r_addr1<0> r_addr1<0> VSS PWL(
+ 24.99n 0.0 25.0n 1.1
+ 44.99n 1.1 45.0n 0.0
+ 54.99n 0.0 55.0n 1.1
+ 64.99n 1.1 65.0n 0.0
+ 105.0n 0.0
)

X_reg_file vdd vss clk clk_b reset_n w_en w_addr<1> w_addr<0> w_data<7> w_data<6> w_data<5> w_data<4> w_data<3> w_data<2> w_data<1> w_data<0> r_addr0<1> r_addr0<0> r_data0<7> r_data0<6> r_data0<5> r_data0<4> r_data0<3> r_data0<2> r_data0<1> r_data0<0> r_addr1<1> r_addr1<0> r_data1<7> r_data1<6> r_data1<5> r_data1<4> r_data1<3> r_data1<2> r_data1<1> r_data1<0> reg_file


* 瞬态分析设置
.tran 0.01n 100n        * 步长0.01ns，总仿真时间100ns

.probe v(CLK) v(w_en)
.probe v(CLK_B)
.probe v(Q)
.probe v(Q2)
.probe v(Q3)

.probe v(w_en)
.probe v(reset_n)

.probe v(w_addr<1>)
.probe v(w_addr<0>)
.probe v(w_data<7>)
.probe v(w_data<6>)
.probe v(w_data<5>)
.probe v(w_data<4>)
.probe v(w_data<3>)
.probe v(w_data<2>)
.probe v(w_data<1>)
.probe v(w_data<0>)

.probe v(r_addr0<1>)
.probe v(r_addr0<0>)
.probe v(r_data0<7>)
.probe v(r_data0<6>)
.probe v(r_data0<5>)
.probe v(r_data0<4>)
.probe v(r_data0<3>)
.probe v(r_data0<2>)
.probe v(r_data0<1>)
.probe v(r_data0<0>)

.probe v(r_addr1<1>)
.probe v(r_addr1<0>)
.probe v(r_data1<7>)
.probe v(r_data1<6>)
.probe v(r_data1<5>)
.probe v(r_data1<4>)
.probe v(r_data1<3>)
.probe v(r_data1<2>)
.probe v(r_data1<1>)
.probe v(r_data1<0>)

.probe v(X_reg_file.X_reg_8_0.Q_7)
.probe v(X_reg_file.X_reg_8_0.Q_6)
.probe v(X_reg_file.X_reg_8_0.Q_5)
.probe v(X_reg_file.X_reg_8_0.Q_4)
.probe v(X_reg_file.X_reg_8_0.Q_3)
.probe v(X_reg_file.X_reg_8_0.Q_2)
.probe v(X_reg_file.X_reg_8_0.Q_1)
.probe v(X_reg_file.X_reg_8_0.Q_0)

.probe v(X_reg_file.X_reg_8_1.Q_7)
.probe v(X_reg_file.X_reg_8_1.Q_6)
.probe v(X_reg_file.X_reg_8_1.Q_5)
.probe v(X_reg_file.X_reg_8_1.Q_4)
.probe v(X_reg_file.X_reg_8_1.Q_3)
.probe v(X_reg_file.X_reg_8_1.Q_2)
.probe v(X_reg_file.X_reg_8_1.Q_1)
.probe v(X_reg_file.X_reg_8_1.Q_0)

.probe v(X_reg_file.X_reg_8_2.Q_7)
.probe v(X_reg_file.X_reg_8_2.Q_6)
.probe v(X_reg_file.X_reg_8_2.Q_5)
.probe v(X_reg_file.X_reg_8_2.Q_4)
.probe v(X_reg_file.X_reg_8_2.Q_3)
.probe v(X_reg_file.X_reg_8_2.Q_2)
.probe v(X_reg_file.X_reg_8_2.Q_1)
.probe v(X_reg_file.X_reg_8_2.Q_0)

.probe v(X_reg_file.X_reg_8_3.Q_7)
.probe v(X_reg_file.X_reg_8_3.Q_6)
.probe v(X_reg_file.X_reg_8_3.Q_5)
.probe v(X_reg_file.X_reg_8_3.Q_4)
.probe v(X_reg_file.X_reg_8_3.Q_3)
.probe v(X_reg_file.X_reg_8_3.Q_2)
.probe v(X_reg_file.X_reg_8_3.Q_1)
.probe v(X_reg_file.X_reg_8_3.Q_0)

.probe v(X_reg_file.WEN<0>)
.probe v(X_reg_file.WEN<1>)
.probe v(X_reg_file.WEN<2>)
.probe v(X_reg_file.WEN<3>)

.probe v(X_reg_file.PRE_WEN<0>)
.probe v(X_reg_file.PRE_WEN<1>)
.probe v(X_reg_file.PRE_WEN<2>)
.probe v(X_reg_file.PRE_WEN<3>)

.probe v(X_reg_file.w_data<7>)
.probe v(X_reg_file.w_data<6>)
.probe v(X_reg_file.w_data<5>)
.probe v(X_reg_file.w_data<4>)
.probe v(X_reg_file.w_data<3>)
.probe v(X_reg_file.w_data<2>)
.probe v(X_reg_file.w_data<1>)
.probe v(X_reg_file.w_data<0>)

.probe v(X_reg_file.X_reg_8_0.X_reg0.X_reg_wo_en.D)
.probe v(X_reg_file.X_reg_8_0.X_reg0.X_reg_wo_en.Q)
.probe v(X_reg_file.X_reg_8_0.X_reg0.X_reg_wo_en.n1)
.probe v(X_reg_file.X_reg_8_0.X_reg0.X_reg_wo_en.n4)
.probe v(X_reg_file.X_reg_8_0.X_reg0.X_reg_wo_en.n5)
.probe v(X_reg_file.X_reg_8_0.X_reg0.X_reg_wo_en.n8)
.probe v(X_reg_file.X_reg_8_0.X_reg0.X_reg_wo_en.clk)
.probe v(X_reg_file.X_reg_8_0.X_reg0.X_reg_wo_en.clk_b)

.probe v(X_reg_file.X_reg_8_0.X_reg1.X_reg_wo_en.D)
.probe v(X_reg_file.X_reg_8_0.X_reg1.X_reg_wo_en.Q)
.probe v(X_reg_file.X_reg_8_0.X_reg1.X_reg_wo_en.n1)
.probe v(X_reg_file.X_reg_8_0.X_reg1.X_reg_wo_en.n4)
.probe v(X_reg_file.X_reg_8_0.X_reg1.X_reg_wo_en.n5)
.probe v(X_reg_file.X_reg_8_0.X_reg1.X_reg_wo_en.n8)
.probe v(X_reg_file.X_reg_8_0.X_reg1.X_reg_wo_en.clk)
.probe v(X_reg_file.X_reg_8_0.X_reg1.X_reg_wo_en.clk_b)

.probe v(X_reg_file.X_reg_8_0.X_reg2.X_reg_wo_en.D)
.probe v(X_reg_file.X_reg_8_0.X_reg2.X_reg_wo_en.Q)
.probe v(X_reg_file.X_reg_8_0.X_reg2.X_reg_wo_en.n1)
.probe v(X_reg_file.X_reg_8_0.X_reg2.X_reg_wo_en.n2)
.probe v(X_reg_file.X_reg_8_0.X_reg2.X_reg_wo_en.n4)
.probe v(X_reg_file.X_reg_8_0.X_reg2.X_reg_wo_en.n5)
.probe v(X_reg_file.X_reg_8_0.X_reg2.X_reg_wo_en.n8)
.probe v(X_reg_file.X_reg_8_0.X_reg2.X_reg_wo_en.clk)
.probe v(X_reg_file.X_reg_8_0.X_reg2.X_reg_wo_en.clk_b)

.probe v(X_reg_file.X_reg_8_0.X_reg2.en)
.probe v(X_reg_file.X_reg_8_0.X_reg2.D)
.probe v(X_reg_file.X_reg_8_0.X_reg2.Q)
.probe v(X_reg_file.X_reg_8_0.X_reg2.sel_D)

.probe v(X_reg_file.X0_out_mux4to1_8bit.S0)
.probe v(X_reg_file.X0_out_mux4to1_8bit.S1)
.probe v(X_reg_file.X0_out_mux4to1_8bit.D0_0)
.probe v(X_reg_file.X0_out_mux4to1_8bit.D1_0)
.probe v(X_reg_file.X0_out_mux4to1_8bit.D2_0)
.probe v(X_reg_file.X0_out_mux4to1_8bit.D3_0)
.probe v(X_reg_file.X0_out_mux4to1_8bit.Y0)

.probe v(X_reg_file.X0_out_mux4to1_8bit.XMUX0.S1)
.probe v(X_reg_file.X0_out_mux4to1_8bit.XMUX0.S0)
.probe v(X_reg_file.X0_out_mux4to1_8bit.XMUX0.D0)
.probe v(X_reg_file.X0_out_mux4to1_8bit.XMUX0.D1)
.probe v(X_reg_file.X0_out_mux4to1_8bit.XMUX0.D2)
.probe v(X_reg_file.X0_out_mux4to1_8bit.XMUX0.D3)
.probe v(X_reg_file.X0_out_mux4to1_8bit.XMUX0.OUT)
.probe v(X_reg_file.X0_out_mux4to1_8bit.XMUX0.SEL0)
.probe v(X_reg_file.X0_out_mux4to1_8bit.XMUX0.SEL1)
.probe v(X_reg_file.X0_out_mux4to1_8bit.XMUX0.SEL2)
.probe v(X_reg_file.X0_out_mux4to1_8bit.XMUX0.SEL3)

* 可选：设置.tr0文件名
.option post_version=9005
.option ingold=2
.option numdgt=6
.end
