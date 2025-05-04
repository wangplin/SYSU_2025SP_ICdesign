#!/bin/sh

file="${1:-5_stage_ring_oscillator}"
sum_tphl=0
sum_tplh=0
sum_t=0
count=0

for RISE_FALL in `seq 3 1 10`
do
    sed -i "s/\(.PARAM RISE_FALL = \)[0-9]\+/\1$RISE_FALL/" "$file"

    hspice $file > /dev/null 2>&1

    eval $(awk '$1 == "tphl" && $2 == "tplh" { 
        getline  
        getline  
        if ($1 == "failed" || $2 == "failed" || $3 == "failed") {
            print "tphl=failed tplh=failed t=failed"
        } else {
            printf "tphl=%s tplh=%s t=%s", $1, $2, $3
        }
        exit
    }' "${file}.mt0")

    if [ "$tphl" = "failed" ] || [ "$tplh" = "failed" ] || [ "$t" = "failed" ]; then
        echo "Simulation failed at RISE_FALL=$RISE_FALL"
        break
    fi

    sum_tphl=$(awk "BEGIN {print $sum_tphl + $tphl; exit}")
    sum_tplh=$(awk "BEGIN {print $sum_tplh + $tplh; exit}")
    sum_t=$(awk "BEGIN {print $sum_t + $t; exit}")
    count=$((count + 1))

    echo "RISE_FALL=$RISE_FALL: tphl=$tphl, tplh=$tplh, t=$t"

done

if [ $count -gt 0 ]; then
    avg_tphl=$(awk "BEGIN {printf \"%.4e\", $sum_tphl/$count; exit}")
    avg_tplh=$(awk "BEGIN {printf \"%.4e\", $sum_tplh/$count; exit}")
    avg_t=$(awk "BEGIN {printf \"%.4e\", $sum_t/$count; exit}")
    
    echo "Average tphl = $avg_tphl" > 1.txt
    echo "Average tplh = $avg_tplh" >> 1.txt
    echo "Average t = $avg_t" >> 1.txt
else
    echo "No valid data for averaging" > 1.txt
fi




