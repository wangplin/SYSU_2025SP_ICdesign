    #!/bin/bash

    file="5_stage_ring_oscillator"

    > mos.txt

    for nw in `seq 120e-9 10e-9 300e-9`
    do
        sed -i "s/^\.PARAM nw = [-+]\?[0-9.]\+/.PARAM nw = $nw/" "$file"

        for pw_times in `seq 1 0.5 5`
        do 
            pw=$(echo "$pw_times * $nw" | bc)

            sed -i "s/^\.PARAM pw = [-+]\?[0-9.]\+/.PARAM pw = $pw/" "$file"

            ./run.sh $file

            avg_tphl=$(grep "Average tphl" 1.txt | awk '{print $4}' | tr -d '\n')
            avg_tplh=$(grep "Average tplh" 1.txt | awk '{print $4}' | tr -d '\n')
            avg_t=$(grep "Average t " 1.txt | awk '{print $4}' | tr -d '\n') 

            echo "nw: $nw, pw_times: $pw_times, tphl: $avg_tphl, tplh: $avg_tplh, t: $avg_t" >> mos.txt
        done   
    done