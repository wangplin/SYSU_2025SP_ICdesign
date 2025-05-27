#!/bin/bash

bit=8
total_errors=0
test_times=100

for ((test_num=0; test_num<test_times; test_num++)); do
    # 生成随机输入并计算预期结果
    echo "Test $test_num:"
    declare -a A B expected
    echo -n "expect: "  # -n表示不换行
    for ((i=0; i<bit; i++)); do
        A[$i]=$((RANDOM % 2))
        B[$i]=$((RANDOM % 2))
        expected[$i]=$((A[i] | B[i]))
    echo -n "Y_${i}: ${expected[$i]} "
    done
    echo 

    # 生成测试激励文件
    cat > alu_or <<EOF
.IC v(Y_0)=0 v(Y_1)=0 v(Y_2)=0 v(Y_3)=0 v(Y_4)=0 v(Y_5)=0 v(Y_6)=0 v(Y_7)=0
$(for ((i=0; i<bit; i++)); do
  echo "VA_${i} A_$i 0 pwl (0n 0 0.01n ${A[i]})"
  echo "VB_${i} B_$i 0 pwl (0n 0 0.01n ${B[i]})"
done)
.include 'or'  # 包含之前生成的子电路
.END
EOF

    # 运行HSPICE仿真
    hspice alu_or > /dev/null 2>&1

    # 提取仿真结果
    declare -a actual
    echo -n "actual: "  # -n表示不换行
    line6_values=($(awk 'NR==6 {print $1, $2, $3, $4}' alu_or.mt0))
    line7_values=($(awk 'NR==7 {print $1, $2, $3, $4}' alu_or.mt0))

    # 处理y_0到y_3（第6行的四个列）
    for i in {0..3}; do
        voltage=${line6_values[$i]}
        actual[$i]=$(awk -v v="$voltage" 'BEGIN {print (v > 0.5) ? 1 : 0}')
        echo -n "Y_${i}: ${actual[$i]} "
    done

    # 处理y_4到y_7（第7行的四个列）
    for i in {0..3}; do
        voltage=${line7_values[$i]}
        idx=$((i + 4))
        actual[$idx]=$(awk -v v="$voltage" 'BEGIN {print (v > 0.5) ? 1 : 0}')
      echo -n "Y_${idx}: ${actual[$idx]} "
    done
    echo
    echo

    # 累计错误
    for ((i=0; i<bit; i++)); do
        if [[ ${actual[i]} -ne ${expected[i]} ]]; then
            ((total_errors++))
        fi
    done
done

echo "Total errors after $test_times tests: $total_errors"