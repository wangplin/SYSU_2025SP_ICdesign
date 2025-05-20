#!/bin/bash
# 全信号精确时序SRAM测试生成脚本

n=4  # BL数量
m=4  # WL数量

# 全局时间参数
HOLD_TIME=0.01      # 维持窗口(n)
BIT_HOLD=5          # 数据保持时间(n)
PRE_RECOVERY=0.01   # 预充电恢复时间(n)

# 初始化信号存储
declare -A wl_signals=() din_signals=()
for ((i=0; i<m; i++)); do wl_signals[$i]="0n 0"; done
for ((i=0; i<n; i++)); do din_signals[$i]="0n 0"; done

# 特殊信号初始化
precharge_signal="0n 1.1"
wre_signal="0n 0"

generate_transition() {
    local time=$1
    local from=$2
    local to=$3
    local end_time=$4
    
    # 生成三段式波形
    printf "%s " "$(bc <<< "$time - $HOLD_TIME")n $from"
    printf "%s " "$(bc <<< "$time")n $to"
    printf "%s " "$(bc <<< "$end_time - $HOLD_TIME")n $to"
    printf "%s " "$(bc <<< "$end_time")n $from"
}

parse_case() {
    local time=$1 op=$2 wl=$3 data=$4

    # WL信号处理
    wl_end=$(bc <<< "$time + 1")
    wl_signals[$wl]+=" $(generate_transition $time 0 1.1 $wl_end)"
    
    if [ "$op" == "write" ]; then
        # WRE信号处理
        wre_end=$(bc <<< "$time + 1")
        wre_signal+=" $(generate_transition $time 0 1.1 $wre_end)"
        
        # 数据信号处理
        for ((i=0; i<n; i++)); do
            bit=${data:$i:1}
            current_voltage=$(echo ${din_signals[$i]} | awk '{print $NF}')
            new_voltage=$([ "$bit" == "1" ] && echo "1.1" || echo "0")
            data_end=$(bc <<< "$time + $BIT_HOLD")
            
            din_signals[$i]+=" $(generate_transition $time $current_voltage $new_voltage $data_end)"
        done
    elif [ "$op" == "read" ]; then
        # 预充电处理（精确时序）
        pre_low_time=$(bc <<< "$time - 1")
        recovery_time=$(bc <<< "$time + $PRE_RECOVERY")
        
        precharge_signal+=" $(generate_transition $pre_low_time 1.1 0 $time)"
        
    fi
}

# 测试用例
parse_case 5  write 2 1101
parse_case 10 write 2 0011
parse_case 15 read  2 0011

# 生成HSPICE文件
cat > sram_test.sp <<EOF
* 全信号精确时序测试

Vwre wre 0 pwl ($wre_signal 999n 0)

$(for i in {0..3}; do
echo "Vwl_${i} wl_$i 0 pwl (${wl_signals[$i]} 999n 0)"
done)

$(for i in {0..3}; do
echo "Vdin_${i} din_$i 0 pwl (${din_signals[$i]} 999n 0)"
done)

Vprecharge precharge 0 pwl ($precharge_signal 999n 1.1)

.end
EOF

echo "信号波形验证："
echo "=== WRE信号 ==="
echo "Vwre wre 0 pwl ($wre_signal 999n 0)"
echo "=== WL2信号 ==="
echo "Vwl_2 wl_2 0 pwl (${wl_signals[2]} 999n 0)"
echo "=== DIN0信号 ==="
echo "Vdin_0 din_0 0 pwl (${din_signals[0]} 999n 0)"
echo "=== 预充电信号 ==="
echo "Vprecharge precharge 0 pwl ($precharge_signal 999n 1.1)"