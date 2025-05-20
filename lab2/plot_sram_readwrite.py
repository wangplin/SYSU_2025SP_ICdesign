import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

# 初始化数据容器
cr_list = []
pr_list = []
read_list = []
write_list = []

# 读取数据文件
with open('sram_array_readwrite.txt', 'r') as f:
    for line in f:
        # 解析每行数据
        parts = line.strip().split(', ')
        cr = float(parts[0].split(': ')[1])
        pr = float(parts[1].split(': ')[1])
        read = float(parts[2].split(': ')[1])
        write = float(parts[3].split(': ')[1])
        
        # 存储数据
        cr_list.append(cr)
        pr_list.append(pr)
        read_list.append(read)
        write_list.append(write)

# 转换为numpy数组
cr_array = np.array(cr_list)
pr_array = np.array(pr_list)
read_array = np.array(read_list)
write_array = np.array(write_list)

# 获取唯一值并生成网格
cr_values = np.unique(cr_array)
pr_values = np.unique(pr_array)
X, Y = np.meshgrid(cr_values, pr_values)

# 数据重塑函数
def create_grid(source_array):
    """将一维数据重塑为二维网格"""
    return source_array.reshape(len(cr_values), len(pr_values)).T

# 创建数据网格
read_grid = create_grid(read_array)
write_grid = create_grid(write_array)

# 3D绘图函数
def plot_3d_surface(X, Y, Z, xlabel, ylabel, zlabel, filename):
    fig = plt.figure(figsize=(10, 7))
    ax = fig.add_subplot(111, projection='3d')
    
    surf = ax.plot_surface(X, Y, Z, 
                          cmap='viridis',
                          rstride=1,
                          cstride=1,
                          edgecolor='none')
    
    ax.set_xlabel(xlabel, labelpad=12)
    ax.set_ylabel(ylabel, labelpad=12)
    ax.set_zlabel(zlabel, labelpad=12)
    
    # 设置视角
    ax.view_init(30, 45)
    
    # 添加颜色条
    fig.colorbar(surf, shrink=0.5, aspect=5)
    
    # 保存图像
    plt.savefig(filename, dpi=300, bbox_inches='tight')
    plt.close()

# 生成并保存图像
plot_3d_surface(X, Y, read_grid, 
               'CR Ratio', 'PR Ratio', 'Read Ability', 
               'read_ability.png')

plot_3d_surface(X, Y, write_grid, 
               'CR Ratio', 'PR Ratio', 'Write Ability', 
               'write_ability.png')
