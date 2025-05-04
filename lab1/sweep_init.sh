#!/bin/bash

file="5_stage_ring_oscillator"

> init.txt

for init in `seq 0.0 0.03 1.1`
do
    sed -i "s/^\.PARAM init_lin = [-+]\?[0-9.]\+/.PARAM init_lin = $init/" "$file"

    ./run.sh $file

    avg_tphl=$(grep "Average tphl" 1.txt | awk '{print $4}' | tr -d '\n')
    avg_tplh=$(grep "Average tplh" 1.txt | awk '{print $4}' | tr -d '\n')
    avg_t=$(grep "Average t " 1.txt | awk '{print $4}' | tr -d '\n') 

    echo "Lin init: $init, tphl: $avg_tphl, tplh: $avg_tplh, t: $avg_t" >> init.txt
done


