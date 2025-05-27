## SMIC 40NM 使用方法


1. 添加工艺库
```
.OPTIONS POST BRIEF
.OP
.LIB "/home/wangpl/smic40_oa/smic40ll_1125_1tm_oa_cds_1P9M_2012_10_11_v1.4/models/hspice/l0040ll_v1p4_1r.lib" tt
.TEMP 25
```


2. 使用晶体管

```

* 接口  D   G   S   B

XP vo vi vdd_0 vdd_0 p11ll_ckt w=330n l=40n $ PMOS

XN vo vi gnd gnd n11ll_ckt w=280n l=40n $ NMOS


```