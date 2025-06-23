# 数据通路



## 部件

1. ALU

```
.include 'alu' 

XALU 
+ alu_A1_0 alu_A1_1 alu_A1_2 alu_A1_3 alu_A1_4 alu_A1_5 alu_A1_6 alu_A1_7 
+ alu_A2_0 alu_A2_1 alu_A2_2 alu_A2_3 alu_A2_4 alu_A2_5 alu_A2_6 alu_A2_7 
+ alu_F_0  alu_F_1  alu_F_2  
+ alu_S_0  alu_S_1  alu_S_2  alu_S_3  alu_S_4  alu_S_5  alu_S_6  alu_S_7 
+ Cout vdd vss alu
```


2. Reg file

```
.include 'ref_file' * 包含文件待定
XReg_file vdd vss clk clk_bar reset_n regfile_WE3
+ regfile_A3_1  regfile_A3_0
+ regfile_WD3_7 regfile_WD3_6 regfile_WD3_5 regfile_WD3_4 regfile_WD3_3 regfile_WD3_2 regfile_WD3_1 regfile_WD3_0 
+ regfile_A1_1  regfile_A1_0
+ regfile_RD1_7 regfile_RD1_6 regfile_RD1_5 regfile_RD1_4 regfile_RD1_3 regfile_RD1_2 regfile_RD1_1 regfile_RD1_0 
+ regfile_A2_1  regfile_A2_0
+ regfile_RD2_7 regfile_RD2_6 regfile_RD2_5 regfile_RD2_4 regfile_RD2_3 regfile_RD2_2 regfile_RD2_1 regfile_RD2_0 
+ reg_file
```


3. Sram array

```
.include 'sram_array' * 包含文件待定

XSram_array 
+ mem_Adr_0 mem_Adr_1 mem_Adr_2 mem_Adr_3 mem_Adr_4 mem_Adr_5 mem_Adr_6 mem_Adr_7
+ clk mem_WE
+ mem_WD_0 mem_WD_1 mem_WD_2 mem_WD_3 mem_WD_4 mem_WD_5 mem_WD_6 mem_WD_7
+ mem_RD_0 mem_RD_1 mem_RD_2 mem_RD_3 mem_RD_4 mem_RD_5 mem_RD_6 mem_RD_7
+ vdd vss sram

```