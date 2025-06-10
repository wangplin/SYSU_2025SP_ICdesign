* 传输门寄存器
* 需要有使能信号和复位信号
* 要有脚本扩展阵列
* 信号接口: VDD VSS CLK CLK_B RESET_N ENABLE D Q
* 多bit：VDD VSS CLK CLK_B RESET_N ENABLE D<3> D<2> D<1> D<0> Q<3> Q<2> Q<1> Q<0> 
* ENABLE=0表示使能有效
* RESET_N=0表示复位有效

* 完整的寄存器文件：w_en w_addr[1:0] w_data[7:0] r_addr_0[1:0] r_data_out0[7:0] r_addr_1[1:0] r_data_out1[7:0]


# 测试信号
D[7:0]依次赋值8'b11110000, 8'b11001100, 8'b10101010, 8'b00001111