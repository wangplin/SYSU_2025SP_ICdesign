import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

nw_list = []
pw_list = []
tphl_list = []
tplh_list = []
t_list = []

with open('mos.txt', 'r') as f:
    for line in f:
        parts = line.strip().split(', ')
        nw = float(parts[0].split(': ')[1])
        pw = float(parts[1].split(': ')[1])
        tphl = float(parts[2].split(': ')[1])
        tplh = float(parts[3].split(': ')[1])
        t = float(parts[4].split(': ')[1])
        
        nw_list.append(nw)
        pw_list.append(pw)
        tphl_list.append(tphl)
        tplh_list.append(tplh)
        t_list.append(t)

nw_array = np.array(nw_list)
pw_array = np.array(pw_list)
tphl_array = np.array(tphl_list)
tplh_array = np.array(tplh_list)
t_array = np.array(t_list)

nw_values = np.unique(nw_array)
pw_values = np.unique(pw_array)

X, Y = np.meshgrid(nw_values, pw_values) 

def create_grid(source_array):
    return source_array.reshape(len(nw_values), len(pw_values)).T

tphl_grid = create_grid(tphl_array)
tplh_grid = create_grid(tplh_array)
t_grid = create_grid(t_array)

def plot_and_save(data, label, filename):
    fig = plt.figure(figsize=(10, 7))
    ax = fig.add_subplot(111, projection='3d')
    
    surf = ax.plot_surface(X, Y, data, cmap='viridis', edgecolor='none')
    ax.set_xlabel('Nmos width (m)')
    ax.set_ylabel('Pmos/Nmos ratio')
    ax.set_zlabel(label)
    
    ax.view_init(30, 45)
    fig.colorbar(surf, shrink=0.5, aspect=5)
    plt.savefig(filename, dpi=300, bbox_inches='tight')
    plt.close()

plot_and_save(tphl_grid, 'tphl (s)', 'mos_tphl.png')
plot_and_save(tplh_grid, 'tplh (s)', 'mos_tplh.png')
plot_and_save(t_grid, 't (s)', 'mos_t.png')