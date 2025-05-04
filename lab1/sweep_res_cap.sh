#!/bin/bash

file="5_stage_ring_oscillator"

> res_cap.txt

for res in `seq 0 1e2 1e3`
do
    sed -i "s/^\.PARAM res = [-+]\?[0-9.]\+/.PARAM res = $res/" "$file"

    for cap in `seq 0 1e-15 1e-14`
    do 
        sed -i "s/^\.PARAM cap = [-+]\?[0-9.]\+/.PARAM cap = $cap/" "$file"

        ./run.sh $file

        avg_tphl=$(grep "Average tphl" 1.txt | awk '{print $4}' | tr -d '\n')
        avg_tplh=$(grep "Average tplh" 1.txt | awk '{print $4}' | tr -d '\n')
        avg_t=$(grep "Average t " 1.txt | awk '{print $4}' | tr -d '\n') 

        echo "Res: $res, Cap: $cap, tphl: $avg_tphl, tplh: $avg_tplh, t: $avg_t" >> res_cap.txt
    done   
done


