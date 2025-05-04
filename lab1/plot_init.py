import matplotlib.pyplot as plt
import numpy as np


inits, tphl_list, tplh_list, t_list = [], [], [], []

with open("init.txt", "r") as f:
    for line in f:
        if "Lin init" in line:
            parts = line.strip().split(", ")
            inits.append(float(parts[0].split(": ")[1]))
            tphl_list.append(float(parts[1].split(": ")[1]))
            tplh_list.append(float(parts[2].split(": ")[1]))
            t_list.append(float(parts[3].split(": ")[1]))


tphl = np.array(tphl_list) * 1e12  
tplh = np.array(tplh_list) * 1e12  
t_osc = np.array(t_list) * 1e12     


t_pre = (tphl + tplh) * 5


plt.figure(figsize=(8, 5))
plt.plot(inits, tphl, 'b-o', linewidth=2, markersize=8)
plt.xlabel('Lin Init (V)', fontsize=12)
plt.ylabel('Fall Delay (ps)', fontsize=12)
plt.title('tphl vs Lin init', fontsize=14)
plt.grid(True, linestyle='--', alpha=0.7)
plt.tight_layout()
plt.savefig('init_tphl.png', dpi=300)
plt.close()


plt.figure(figsize=(8, 5))
plt.plot(inits, tplh, 'r-s', linewidth=2, markersize=8)
plt.xlabel('Lin Init (V)', fontsize=12)
plt.ylabel('Rise Delay (ps)', fontsize=12)
plt.title('tplh vs Lin init', fontsize=14)
plt.grid(True, linestyle='--', alpha=0.7)
plt.tight_layout()
plt.savefig('init_tplh.png', dpi=300)
plt.close()


plt.figure(figsize=(8, 5))
plt.plot(inits, t_pre, 'm-^', label='Theoretical Oscillation Period= 5*(tphl + tplh)')
plt.plot(inits, t_osc, 'g--o', label='Experimental Oscillation Period (t)')

plt.xlabel('Lin Init (V)', fontsize=12)
plt.ylabel('Time (ps)', fontsize=12)  
plt.title('Theoretical Oscillation Period vs Experimental Oscillation Period', fontsize=14)
plt.grid(True, linestyle='--', alpha=0.7)
plt.legend()
plt.tight_layout()
plt.savefig('init_t.png', dpi=300)
plt.close()