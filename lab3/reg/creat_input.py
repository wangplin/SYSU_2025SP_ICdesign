def generate_PWL(rows=3, cols=1, index = 0, signal = [0, 0, 1, 1, 0, 1]):
    max_signal_len = 10
    cycle = 10
    epsilon = 0.01
    high_V = 1.1
    low_V = 0.0
    bgn_tick = 0
    end_tick = 0

    signal.extend([0] * (1 + max_signal_len - len(signal)))
    lines = [
        ''.join([f"VWL_{index} "]) + 
        ' '.join([f"WL_{index}"]) + " VSS"
        ' PWL('
    ]

    old_signal = 0
    for i in range(len(signal)):
        bgn_tick = cycle / 2 + cycle * (i)
        end_tick = 0
        # for high voltage
        if signal[i] == 1:
            # having rising edg
            # build rising edge
            if old_signal != signal[i]:
                line = "+ " + f"{bgn_tick - epsilon}n {low_V} {bgn_tick}n {high_V}"
                lines.append(line) 
            # build falling edge
            if signal[i + 1] == 0:
                end_tick = bgn_tick + cycle
                line = "+ " + f"{end_tick - epsilon}n {high_V} {end_tick}n {low_V}"
                lines.append(line)
        old_signal = signal[i]
    # final tick
    final_tick = cycle / 2 + max_signal_len * cycle
    if end_tick < final_tick:
        line = "+ " + f"{final_tick}n {low_V}"
        lines.append(line)

    lines.extend(')')
    return "\n".join(lines)

if __name__ == "__main__":
    out = generate_PWL()
    print(out)