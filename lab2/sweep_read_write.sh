#!/bin/bash

file="sram_array"

> sram_array_readwrite.txt
p12w=3600

sed -i "s/^\.PARAM p12w = [-+]\?[0-9.]\+/.PARAM p12w = $p12w/" "$file"
for CR in `seq 0.1 0.1 3`
do 
    for PR in `seq 0.1 0.1 3`
    do

    a12w=$(echo "scale=0; $p12w/$PR" | bc)
    n12w=$(echo "scale=0; $CR * $p12w/$PR" | bc)

    echo "a12w: $a12w, n12w: $n12w"

    sed -i "s/^\.PARAM a12w = [-+]\?[0-9.]\+/.PARAM a12w = $a12w/" "$file"
    sed -i "s/^\.PARAM n12w = [-+]\?[0-9.]\+/.PARAM n12w = $n12w/" "$file"
    
    hspice $file > /dev/null 2>&1

    # 提取结果
    result=$(awk '$1 == "read_ability" && $2 == "write_ability" {
        getline  # 跳过标题行
        getline  # 数据行
        if ($1 == "failed" || $2 == "failed") {
            print "read_ability=failed write_ability=failed"
        } else {
            printf "read_ability=%s write_ability=%s\n", $1, $2
        }
        exit
    }' "${file}.mt0" 2>/dev/null)

    # 处理仿真失败的情况
    if [ -z "$result" ]; then
        result="read_ability=failed write_ability=failed"
    fi

    # 记录结果
    eval "$result"
    echo "CR: $CR, PR: $PR, read_ability: $read_ability, write_ability: $write_ability" >> sram_array_readwrite.txt


    done
done
