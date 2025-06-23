import random
vdd = 1.1
edge_time = 0.01
write_width = 0.2
write_cycle = write_width*2
prech_width = 0.4
clk_width = 0.4
read_cycle = prech_width+clk_width
write_start = 0.0
write_end = write_cycle * 64
read_start = write_end
read_end = read_start + read_cycle * 64
sim_end = read_end

waveforms = {
    "clk": [(0.0, 0.0)],
    "wre": [(0.0, 0.0)],
    "precharge": [(0.0, vdd)],
    "A0": [(0.0, 0.0)],
    "A1": [(0.0, 0.0)],
    "A2": [(0.0, 0.0)],
    "A3": [(0.0, 0.0)],
    "A4": [(0.0, 0.0)],
    "A5": [(0.0, 0.0)],
    "oe": [(0.0, 0.0)],
}

# 为每个din信号初始化
for i in range(8):
    waveforms[f"din_{i}"] = [(0.0, 0.0)]


def add_edge(signal, time, value):
    time = time+edge_time
    if time > 0:  # 0ns前不能添加点
        prev_value = waveforms[signal][-1][1]
        waveforms[signal].append((time - edge_time, prev_value))
    # 添加跳变点
    waveforms[signal].append((time, value))

add_edge("wre", write_start, vdd)
for pulse in range(64):
    # 计算时间点
    t_start = write_start + pulse * write_cycle
    t_end = t_start + write_width
    a0_val = vdd if (pulse & 1) else 0.0
    a1_val = vdd if (pulse & 2) else 0.0
    a2_val = vdd if (pulse & 4) else 0.0
    a3_val = vdd if (pulse & 8) else 0.0
    a4_val = vdd if (pulse & 16) else 0.0
    a5_val = vdd if (pulse & 32) else 0.0

    # WRE信号（写使能）
    #add_edge("wre", t_start, 0.0)
    #add_edge("wre", t_end, vdd)

    # 地址信号
    add_edge("A0", t_start, a0_val)
    add_edge("A1", t_start, a1_val)
    add_edge("A2", t_start, a2_val)
    add_edge("A3", t_start, a3_val)
    add_edge("A4", t_start, a4_val)
    add_edge("A5", t_start, a5_val)

    # 数据信号 - 行地址为n时，只有din_n为高电平
    for d in range(8):
        val = vdd if random.random() > 0.5 else 0.0
        add_edge(f"din_{d}", t_start, val)

    # 在写周期结束时将数据归零
    #for d in range(8):
    #    add_edge(f"din_{d}", t_end, 0.0)

add_edge("wre", write_end, 0.0)
print(waveforms)
# 读出阶段波形生成
add_edge("oe", read_start, vdd)
for pulse in range(64):
    t_start = read_start + pulse * read_cycle
    t_prech_end = t_start + prech_width
    t_clk_end = t_start + clk_width + prech_width

    # 生成地址信号（二进制表示）
    a0_val = vdd if (pulse & 1) else 0.0
    a1_val = vdd if (pulse & 2) else 0.0
    a2_val = vdd if (pulse & 4) else 0.0
    a3_val = vdd if (pulse & 8) else 0.0
    a4_val = vdd if (pulse & 16) else 0.0
    a5_val = vdd if (pulse & 32) else 0.0

    # Precharge信号
    add_edge("precharge", t_start, 0.0)
    add_edge("precharge", t_prech_end, vdd)

    # CLK信号
    add_edge("clk", t_prech_end+clk_width/2, vdd)
    add_edge("clk", t_clk_end, 0.0)

    # 地址信号
    add_edge("A0", t_start, a0_val)
    add_edge("A1", t_start, a1_val)
    add_edge("A2", t_start, a2_val)
    add_edge("A3", t_start, a3_val)
    add_edge("A4", t_start, a4_val)
    add_edge("A5", t_start, a5_val)

add_edge("oe", read_end, 0)
# 添加结束点保证波形完整
for signal, wave in waveforms.items():
    wave.append((sim_end, wave[-1][1]))



# 生成HSPICE激励源描述
spice_output = ""
for pin, wave in waveforms.items():
    # 按时间排序
    wave.sort(key=lambda x: x[0])

    # 处理相邻时间点相同值的情况
    simplified_wave = [wave[0]]
    for i in range(1, len(wave)):
        #if wave[i][1] != simplified_wave[-1][1] or wave[i][0] == sim_end:
            simplified_wave.append(wave[i])

    # 创建PWL字符串
    pwl_entries = []
    for time, voltage in simplified_wave:
        pwl_entries.append(f"{time:.2f}n {voltage:.1f}")

    # 生成完整语句
    spice_output += f"V{pin} {pin} 0 PWL({', '.join(pwl_entries)})\n"



print(".TRAN 0.02n %.2fn UIC"%(sim_end))
print(spice_output)
print(".END")