def generate_reg_array(rows=8, cols=1):
    lines = [
        '.subckt reg_array VDD VSS CLK CLK_B RESET_N ENABLE ' +
        ' '.join([f"D_{i}" for i in range(rows - 1, -1, -1)]) + ' ' +
        ' '.join([f"Q_{i}" for i in range(rows - 1, -1, -1)])
    ]

    for j in range(rows):
        name = f"X_reg{j}"
        # left
        D_in  = [f"D_{j}"]
        # right
        Q_out  = [f"Q_{j}"]

        line = f"{name} VDD VSS CLK CLK_B RESET_N ENABLE {' '.join(D_in)} {' '.join(Q_out)} reg"
        lines.append(line)
    lines.extend(['.end'])
    return "\n".join(lines)


if __name__ == "__main__":
    out = generate_reg_array()
    print(out)