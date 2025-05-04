#!/bin/bash

file="5_stage_ring_oscillator"

> temperature.txt

for temp in `seq -20 1 50`
do
    sed -i "s/^\.PARAM temp = [-+]\?[0-9.]\+/.PARAM temp = $temp/" "$file"

    ./run.sh 5_stage_ring_oscillator

    avg_tphl=$(grep "Average tphl" 1.txt | awk '{print $4}' | tr -d '\n')
    avg_tplh=$(grep "Average tplh" 1.txt | awk '{print $4}' | tr -d '\n')
    avg_t=$(grep "Average t " 1.txt | awk '{print $4}' | tr -d '\n') 

    echo "Tempreature: $temp, tphl: $avg_tphl, tplh: $avg_tplh, t: $avg_t" >> temperature.txt
done


