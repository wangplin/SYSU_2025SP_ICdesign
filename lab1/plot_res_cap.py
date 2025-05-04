import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

res_list = []
cap_list = []
tphl_list = []
tplh_list = []
t_list = []

with open('res_cap.txt', 'r') as f:
    for line in f:
        parts = line.strip().split(', ')
        res = int(parts[0].split(': ')[1])
        cap = float(parts[1].split(': ')[1])
        tphl = float(parts[2].split(': ')[1])
        tplh = float(parts[3].split(': ')[1])
        t = float(parts[4].split(': ')[1])
        
        res_list.append(res)
        cap_list.append(cap)
        tphl_list.append(tphl)
        tplh_list.append(tplh)
        t_list.append(t)

res_array = np.array(res_list)
cap_array = np.array(cap_list)
tphl_array = np.array(tphl_list)
tplh_array = np.array(tplh_list)
t_array = np.array(t_list)

res_values = np.unique(res_array)
cap_values = np.unique(cap_array)

X, Y = np.meshgrid(res_values, cap_values * 1e14) 

def create_grid(source_array):
    return source_array.reshape(len(res_values), len(cap_values)).T

tphl_grid = create_grid(tphl_array)
tplh_grid = create_grid(tplh_array)
t_grid = create_grid(t_array)

def plot_and_save(data, label, filename):
    fig = plt.figure(figsize=(10, 7))
    ax = fig.add_subplot(111, projection='3d')
    
    surf = ax.plot_surface(X, Y, data, cmap='viridis', edgecolor='none')
    ax.set_xlabel('Resistance (Ω)')
    ax.set_ylabel('Capacitance (1e-14 F)')
    ax.set_zlabel(label)
    
    ax.view_init(30, 45)
    fig.colorbar(surf, shrink=0.5, aspect=5)
    plt.savefig(filename, dpi=300, bbox_inches='tight')
    plt.close()

plot_and_save(tphl_grid, 'tphl (s)', 'res_cap_tphl.png')
plot_and_save(tplh_grid, 'tplh (s)', 'res_cap_tplh.png')
plot_and_save(t_grid, 't (s)', 'res_cap_t.png')