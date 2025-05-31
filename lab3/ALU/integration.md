# ALU 集成

## AND 
```spice
.include 'AND/and' 

XALU_ADD_0 A_0 A_1 A_2 A_3 A_4 A_5 A_6 A_7 B_0 B_1 B_2 B_3 B_4 B_5 B_6 B_7 Y_0 Y_1 Y_2 Y_3 Y_4 Y_5 Y_6 Y_7 vdd vss ALU_ADD

```

## OR

```
.include 'OR/or' 

XALU_OR_0 A_0 A_1 A_2 A_3 A_4 A_5 A_6 A_7 B_0 B_1 B_2 B_3 B_4 B_5 B_6 B_7 Y_0 Y_1 Y_2 Y_3 Y_4 Y_5 Y_6 Y_7 vdd vss ALU_OR
```

## Full_ADDER

```
.include 'FULL_ADDER/add' 


* 逐位进位加法器
Xripple_carry_adder_0 A_0 A_1 A_2 A_3 A_4 A_5 A_6 A_7 B_0 B_1 B_2 B_3 B_4 B_5 B_6 B_7 S_0 S_1 S_2 S_3 S_4 S_5 S_6 S_7 Cin Cout vdd vss ripple_carry_adder

* 对数超前进位加法器
* Xcarry_lookahead_adder_0 A_0 A_1 A_2 A_3 A_4 A_5 A_6 A_7 B_0 B_1 B_2 B_3 B_4 B_5 B_6 B_7 S_0 S_1 S_2 S_3 S_4 S_5 S_6 S_7 Cin Cout vdd vss carry_lookahead_adder
```




