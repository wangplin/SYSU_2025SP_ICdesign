#!/bin/bash

bit=8

exec > and_template

# 生成端口列表
a_ports=()
b_ports=()
y_ports=()
for ((i=0; i<bit; i++)); do
    a_ports+=("A_$i")
    b_ports+=("B_$i")
    y_ports+=("Y_$i")
done

# 组合所有端口
ports=("${a_ports[@]}" "${b_ports[@]}" "${y_ports[@]}" "vdd" "vss")

# 输出子电路定义
echo ".subckt ALU_ADD ${ports[@]}"
for ((i=0; i<bit; i++)); do
    echo "XAND_OR_GATE_$i ${a_ports[i]} ${b_ports[i]} ${y_ports[i]} vss vss vss vdd vdd vss AND_OR_GATE"
done
echo ".ends ALU_ADD"