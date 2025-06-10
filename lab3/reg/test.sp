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

* Write Enable Signal
VWR_EN WR_EN 0 PWL(
+ 0n 0 10n 0 10.01n 1.1 49.99n 1.1 50n 0
+ 100n 0)

* Word Line Signals
VWL_0 WL_0 0 PWL(
+ 9.99n 0.0 10n 1.1
+ 19.99n 1.1 20n 0.0
+ 100n 0)

VWL_1 WL_1 VSS PWL(
+ 4.99n 0.0 5.0n 1.1
+ 14.99n 1.1 15.0n 0.0
+ 34.99n 0.0 35.0n 1.1
+ 54.99n 1.1 55.0n 0.0
+ 64.99n 0.0 65.0n 1.1
+ 74.99n 1.1 75.0n 0.0
+ 105.0n 0.0
)

V_RESET RESET VSS PWL(
+ 4.99n 0.0 5.0n 1.1
+ 14.99n 1.1 15.0n 0.0
+ 29.99n 0.0 30.0n 1.1
+ 74.99n 1.1 
+ 105.0n 1.1
)

V_RESET2 RESET2 VSS PWL(
+ 24.99n 0.0 25.0n 1.1
+ 34.99n 1.1 35.0n 0.0
+ 105.0n 0.0
)

V_EN EN VSS PWL(
+ 24.99n 0.0 25.0n 1.1
+ 44.99n 1.1 45.0n 0.0
+ 54.99n 0.0 55.0n 1.1
+ 64.99n 1.1 65.0n 0.0
+ 105.0n 0.0
)

VD_0 D_0 VSS PWL(
+ 64.99n 0.0 65.0n 1.1
+ 74.99n 1.1 75.0n 0.0
+ 105.0n 0.0
)

VD_1 D_1 VSS PWL(
+ 54.99n 0.0 55.0n 1.1
+ 74.99n 1.1 75.0n 0.0
+ 105.0n 0.0
)

VD_2 D_2 VSS PWL(
+ 44.99n 0.0 45.0n 1.1
+ 54.99n 1.1 55.0n 0.0
+ 64.99n 0.0 65.0n 1.1
+ 74.99n 1.1 75.0n 0.0
+ 105.0n 0.0
)

VD_3 D_3 VSS PWL(
+ 44.99n 0.0 45.0n 1.1
+ 74.99n 1.1 75.0n 0.0
+ 105.0n 0.0
)

VD_4 D_4 VSS PWL(
+ 34.99n 0.0 35.0n 1.1
+ 44.99n 1.1 45.0n 0.0
+ 105.0n 0.0
)

VD_5 D_5 VSS PWL(
+ 34.99n 0.0 35.0n 1.1
+ 44.99n 1.1 45.0n 0.0
+ 54.99n 0.0 55.0n 1.1
+ 64.99n 1.1 65.0n 0.0
+ 105.0n 0.00
)

VD_6 D_6 VSS PWL(
+ 34.99n 0.0 35.0n 1.1
+ 54.99n 1.1 55.0n 0.0
+ 105.0n 0.0
)

VD_7 D_7 VSS PWL(
+ 34.99n 0.0 35.0n 1.1
+ 64.99n 1.1 65.0n 0.0
+ 105.0n 0.0
)


X1 vdd vss WL_0 WL_1 nand_output nand2
X_T1 vdd vss WL_1 T1_out CLK CLK_B tg
X_init_reg vdd vss WL_1 Q CLK CLK_B init_reg
X_reg_wo_en vdd vss WL_1 Q2 CLK CLK_B RESET reg_without_en
X_reg_wo_en2 vdd vss WL_1 Q3 CLK CLK_B RESET2 reg_without_en

X_reg vdd vss CLK CLK_B RESET EN WL_1 Q4 reg
X_mux vdd vss vdd vss en Y mux2

X_reg8_array vdd vss CLK CLK_B RESET EN D_7 D_6 D_5 D_4 D_3 D_2 D_1 D_0 Q_7 Q_6 Q_5 Q_4 Q_3 Q_2 Q_1 Q_0 reg_array_8

* 瞬态分析设置
.tran 0.01n 100n        * 步长0.01ns，总仿真时间100ns
.probe v(out)           * 指定要保存的波形
.probe v(out1)           * 指定要保存的波形

.probe v(CLK) v(WR_EN)
.probe v(WL_0)
.probe v(WL_1)
.probe v(nand_output)
.probe v(CLK_B)
.probe v(Q)
.probe v(Q2)
.probe v(Q3)
.probe v(X_init_reg.n1)
.probe v(X_init_reg.n4)
.probe v(X_init_reg.n2)
.probe v(X_init_reg.n5)
.probe v(X_init_reg.n8)
.probe v(X_init_reg.clk)
.probe v(X_init_reg.clk_b)
.probe v(T1_out)
.probe v(X_T1.in)
.probe v(X_T1.out)
.probe v(X_T1.en)
.probe v(X_T1.en_b)
.probe v(RESET)
.probe v(RESET2)

.probe v(EN)
.probe v(Q4)
.probe v(Y)

.probe v(D_0)
.probe v(D_1)
.probe v(D_2)
.probe v(D_3)
.probe v(D_4)
.probe v(D_5)
.probe v(D_6)
.probe v(D_7)
.probe v(Q_0)
.probe v(Q_1)
.probe v(Q_2)
.probe v(Q_3)
.probe v(Q_4)
.probe v(Q_5)
.probe v(Q_6)
.probe v(Q_7)

.probe v(X_reg8_array.X_reg0.vdd)
.probe v(X_reg8_array.X_reg0.vss)
.probe v(X_reg8_array.X_reg0.clk)
.probe v(X_reg8_array.X_reg0.clk_b)
.probe v(X_reg8_array.X_reg0.reset_b)
.probe v(X_reg8_array.X_reg0.en)
.probe v(X_reg8_array.X_reg0.D)
.probe v(X_reg8_array.X_reg0.Q)


V_ADDR_0 ADDR_0 VSS PWL(
+ 24.99n 0.0 25.0n 1.1
+ 34.99n 1.1 35.0n 0.0
+ 44.99n 0.0 45.0n 1.1
+ 54.99n 1.1 55.0n 0.0
+ 105.0n 0.0
)

V_ADDR_1 ADDR_1 VSS PWL(
+ 34.99n 0.0 35.0n 1.1
+ 54.99n 1.1 55.0n 0.0
+ 105.0n 0.0
)

V_24_en encoder_24_en VSS PWL(
+ 14.99n 0.0 15.0n 1.1
+ 54.99n 1.1 55.0n 0.0
+ 105.0n 0.0
)


X_decoder_2to4 vdd vss ADDR_1 ADDR_0 Y0 Y1 Y2 Y3 decoder_2to4

.probe v(encoder_24_en)
.probe v(ADDR_0)
.probe v(ADDR_1)
.probe v(Y0)
.probe v(Y1)
.probe v(Y2)
.probe v(Y3)

* 可选：设置.tr0文件名
.option post_version=9005
.option ingold=2
.option numdgt=6
.end
