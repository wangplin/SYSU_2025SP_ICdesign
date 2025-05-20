import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

res_list = []
cap_list = []
twrite_list = []
tread_list = []

with open('res_cap.txt', 'r') as f:
    for line in f:
        parts = line.strip().split(', ')
        
        # 解析电阻值（去除科学计数法后缀）
        res = float(parts[0].split(': ')[1].replace('e0', ''))
        
        # 解析电容值（处理全零格式）
        cap_str = parts[1].split(': ')[1]
        cap = float(cap_str) if 'e' in cap_str else float(f"{cap_str}e-15")
        
        # 解析时序参数（处理失败情况）
        try:
            twrite = float(parts[2].split(': ')[1])
            tread = float(parts[3].split(': ')[1])
        except ValueError:
            twrite = np.nan
            tread = np.nan
        
        res_list.append(res)
        cap_list.append(cap * 1e15)  # 转换为fF单位
        twrite_list.append(twrite)
        tread_list.append(tread)

# 转换为numpy数组并处理异常值
res_array = np.array(res_list)
cap_array = np.array(cap_list)
twrite_array = np.nan_to_num(np.array(twrite_list), nan=0)
tread_array = np.nan_to_num(np.array(tread_list), nan=0)

# 创建数据网格
res_values = np.unique(res_array)
cap_values = np.unique(cap_array)
X, Y = np.meshgrid(res_values, cap_values)

def create_grid(source_array):
    """将一维数据重塑为二维网格"""
    return source_array.reshape(len(res_values), len(cap_values)).T

twrite_grid = create_grid(twrite_array) * 1e12  # 转换为ps单位
tread_grid = create_grid(tread_array) * 1e12    # 转换为ps单位

# 增强版绘图函数
def plot_timing_surface(X, Y, Z, title, filename):
    fig = plt.figure(figsize=(12, 8))
    ax = fig.add_subplot(111, projection='3d')
    
    # 创建表面图
    surf = ax.plot_surface(X, Y, Z, 
                         cmap='plasma',
                         rstride=1, 
                         cstride=1,
                         alpha=0.9,
                         edgecolor='k',
                         linewidth=0.5)
    
    # 设置标签和标题
    ax.set_xlabel('Resistance (Ω)', labelpad=15, fontsize=12)
    ax.set_ylabel('Capacitance (fF)', labelpad=15, fontsize=12)
    ax.set_zlabel('Delay (ps)', labelpad=15, fontsize=12)
    ax.set_title(title, pad=20, fontsize=14)
    
    # 优化视角
    ax.view_init(35, 45)
    
    # 添加颜色条
    cbar = fig.colorbar(surf, shrink=0.6, aspect=20, pad=0.1)
    cbar.set_label('Delay (ps)', rotation=270, labelpad=20)
    
    # 保存图像
    plt.savefig(filename, dpi=300, bbox_inches='tight')
    plt.close()

# 生成时序分析图
plot_timing_surface(X, Y, twrite_grid, 
                   'Write Timing Analysis', 
                   'write_timing_3d.png')

plot_timing_surface(X, Y, tread_grid, 
                   'Read Timing Analysis', 
                   'read_timing_3d.png')
