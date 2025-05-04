# Lab1 环形振荡器

利用反相器构造环形振荡器，计算传播延时和振荡周期，讨论不同初始化情况对起振的影响，讨论晶体管长宽比、互连线 RC、温度对振荡器的影响。


# 项目结构

```
├─3_stage_ring_oscillator
├─5_stage_ring_oscillator
├─7_stage_ring_oscillator
├─plot_init.py
├─plot_mos.py
├─plot_res_cap.py
├─plot_temprerature.py
├─run.sh
├─sweep_init.sh
├─sweep_mos.sh
├─sweep_stage.sh
└─sweep_temp.sh

```

# 实验环境

1. HSPICE R-2020.12-SP1 linux64
2. CPU Intel(R) Xeon(R) Gold 5218R CPU @ 2.10GHz
3. TSMC40LP_PDK/PDK/tn40cmsp001k3_2_0_2a/PDK/PDK/models/hspice/toplevel.l

# 实验复现

> 需要保证参数为基本配置

## 传播延时和振荡周期

```shell
# 结果在 stage.txt
./sweep_stage.sh
```

## PMOS/NMOS 宽长比

```shell
./sweep_mos.sh
python3 plot_mos.py
```

## 初始化激励

```shell
./sweep_init.sh

# init.txt 需要删除离异值
python3 plot_init.py
```

## 互连线RC延迟

```shell
./sweep_res_cap.sh
python3 plot_res_cap.py
```

## 温度

```shell
./sweep_temp.sh
python3 plot_temprerature.py
```
