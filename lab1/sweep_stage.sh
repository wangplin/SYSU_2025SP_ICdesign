#!/bin/bash

> stage.txt

for stage in 3 5 7
do 
    file="${stage}_stage_ring_oscillator" 

    ./run.sh $file

    avg_tphl=$(grep "Average tphl" 1.txt | awk '{print $4}' | tr -d '\n')
    avg_tplh=$(grep "Average tplh" 1.txt | awk '{print $4}' | tr -d '\n')
    avg_t=$(grep "Average t " 1.txt | awk '{print $4}' | tr -d '\n') 

    echo "Stage: $stage, tphl: $avg_tphl, tplh: $avg_tplh, t: $avg_t" >> stage.txt
done