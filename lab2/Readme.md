# Lab2 SRAM读写阵列
使用HSPICE生成SRAM阵列，BL和WL能自主控制；能反映BL上电压变化；写入时能反映单元内的电压翻转。每个SRAM单元都有一个电源，考虑节点间的RC延迟。电源连接到电源网络角落，电源网络的理想电源，放置于拓扑中心。


# 项目结构

```
├─get_all.sh
├─gen_test.sh   # have little bugs
├─plot_res_cap.py
├─plot_sram_readwrite.py
├─sram_array
├─sweep_read_write.sh
└─sweep_res_cap.sh
```


# 实验环境

1. HSPICE R-2020.12-SP1 linux64
2. CPU Intel(R) Xeon(R) Gold 5218R CPU @ 2.10GHz
3. smic40ll_1125_1tm_oa_cds_1P9M_2012_10_11_v1.4/models/hspice/l0040ll_v1p4_1r.lib


# 实验复现


## 构建SRAM阵列

```shell
# 在gen_all.sh中指定 BL WL
source gen_all.sh
```

## SRAM阵列读写操作

```shell
hspice sram_array
wv sram_array.tr0
```

## SRAM阵列读写稳定性

```shell
source sweep_read_write.sh
python3 plot_sram_readwrite.py
```

## 互连线延时
```shell
source sweep_res_cap.sh
python3 plot_res_cap.py
```








