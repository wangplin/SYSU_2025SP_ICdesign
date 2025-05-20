#!/bin/bash

file="sram_array"

> res_cap.txt

for res in `seq 0 1e2 1e3`
do
    sed -i "s/^\.PARAM res = [-+]\?[0-9.]\+/.PARAM res = $res/" "$file"

    for cap in `seq 0 1e-15 1e-14`
    do 
        sed -i "s/^\.PARAM cap = [-+]\?[0-9.]\+/.PARAM cap = $cap/" "$file"

        hspice $file > /dev/null 2>&1


        eval $(awk '$1 == "twrite" && $2 == "tread" {
        getline  
        getline  
        if ($1 == "failed" || $2 == "failed") {
            print "twrite=failed tread=failed"
        } else {
            printf "twrite=%s tread=%s\n", $1, $2
        }
        exit
    }' "${file}.mt0")


        echo "Res: $res, Cap: $cap, twrite: $twrite, tread: $tread" >> res_cap.txt
    done   
done


