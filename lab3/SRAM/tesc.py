for i in range(64):
    # 将i转换为6位二进制列表，低bit在前（index0对应A0）
    bits = [(i >> j) & 1 for j in range(6)]  # j=0是最低位（A0），j=5是最高位（A5）
    # 根据每一位是0还是1，选择原信号或反相信号
    signals = []
    for j in range(6):  # j=0~5对应bit0~5，即A0~A5
        if bits[j] == 1:
            signals.append(f"A{j}")
        else:
            signals.append(f"A{j}_bar")
    # 连接这些信号到与非门
    # 信号顺序：A0, A1, A2, A3, A4, A5 （即signals[0]对应A0，signals[5]对应A5）
    signals_str = " ".join(signals)
    # 写xnand语句和反相器
    print(f"xand{i} {signals_str} Y{i} VDD GND and6")
    #print(f"xinv{i}_out net{i} Y{i} VDD GND inva")