#!/bin/bash

bit=8
total_errors=0
test_times=100

for ((test_num=0; test_num<test_times; test_num++)); do
    # 生成随机输入和进位
    echo "Test $test_num:"
    declare -a A B expected_S
    Cin=$((RANDOM % 2))
    # echo "Cin: $Cin "
    # 计算预期结果（全加器逻辑）
    echo -n "expect: "
    carry=$Cin
    for ((i=0; i<bit; i++)); do
        A[$i]=$((RANDOM % 2))
        B[$i]=$((RANDOM % 2))
        sum=$((A[i] + B[i] + carry))
        expected_S[$i]=$((sum % 2))       # 当前位和
        carry=$((sum / 2))                # 进位到下一级
        # echo -n "A_${i}: ${A[$i]} "
        # echo -n "B_${i}: ${B[$i]} "
        echo -n "S_${i}: ${expected_S[$i]} "
        # echo -n "Cout_${i}: $carry "
        # echo
    done
    expected_Cout=$carry
    echo -n "Cout: $expected_Cout"
    echo

    # 生成测试激励文件
    cat > alu_full_adder <<EOF
.IC v(S_0)=0 v(S_1)=0 v(S_2)=0 v(S_3)=0 v(S_4)=0 v(S_5)=0 v(S_6)=0 v(S_7)=0 v(Cout)=0
$(for ((i=0; i<bit; i++)); do
  echo "VA_${i} A_$i 0 pwl (0n 0 0.01n ${A[i]})"
  echo "VB_${i} B_$i 0 pwl (0n 0 0.01n ${B[i]})"
done)
VCin Cin 0 pwl (0n 0 0.01n $Cin)
.include 'add'  # 包含8位全加器网表
.END
EOF

    # 运行HSPICE仿真
    hspice alu_full_adder > /dev/null 2>&1

    # 提取仿真结果（9个输出：S0-S7 + Cout）
    declare -a actual
    echo -n "actual: "
    # 读取S0-S3（第6行）
    line6_values=($(awk 'NR==6 {print $1, $2, $3, $4}' alu_full_adder.mt0))
    for i in {0..3}; do
        voltage=${line6_values[$i]}
        actual[$i]=$(awk -v v="$voltage" 'BEGIN {print (v > 0.5) ? 1 : 0}')
        echo -n "S_${i}: ${actual[$i]} "
    done

    # 读取S4-S7（第7行）
    line7_values=($(awk 'NR==7 {print $1, $2, $3, $4}' alu_full_adder.mt0))
    for i in {0..3}; do
        voltage=${line7_values[$i]}
        idx=$((i + 4))
        actual[$idx]=$(awk -v v="$voltage" 'BEGIN {print (v > 0.5) ? 1 : 0}')
        echo -n "S_${idx}: ${actual[$idx]} "
    done

    # 读取Cout（第8行第1列）
    cout_voltage=$(awk 'NR==8 {print $1}' alu_full_adder.mt0)
    actual_Cout=$(awk -v v="$cout_voltage" 'BEGIN {print (v > 0.5) ? 1 : 0}')
    echo -n "Cout: $actual_Cout"
    echo
    echo

    # 累计错误（9个输出分别比较）
    for ((i=0; i<bit; i++)); do
        if [[ ${actual[i]} -ne ${expected_S[i]} ]]; then
            ((total_errors++))
            exit 1
        fi
    done
    if [[ $actual_Cout -ne $expected_Cout ]]; then
        ((total_errors++))
        exit 1
    fi
done

echo "Total errors after $test_times tests: $total_errors"