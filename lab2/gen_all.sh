#!/bin/bash

n=4  # bl
m=4  # wl

center_x=$(echo "scale=1; ($n - 1)/2" | bc)  
center_y=$(echo "scale=1; ($m - 1)/2" | bc)  

exec > all_template

echo "* Sram Array"

for ((i=0; i<n; i++)); do
    for ((j=0; j<m; j++)); do
        is_center=0
        if (( $(echo "$i == $center_x && $j == $center_y" | bc -l) )); then
            is_center=1  
        fi
        
        dx=$(echo "scale=1; if (($i - $center_x) < 0) ($i - $center_x) * -1 else ($i - $center_x)" | bc)
        dy=$(echo "scale=1; if (($j - $center_y) < 0) ($j - $center_y) * -1 else ($j - $center_y)" | bc)

        manhattan=$(echo " $dx + $dy" | bc -l)  
        

        if (( is_center )); then
            vdd_index=0    
        else
            # vdd_index=$(( 2 * manhattan ))  
            vdd_index=$(echo "scale=0; (2 * $manhattan + 0.5)/1" | bc -l)
        fi
        
        echo "Xcell_${i}_${j} bl_${i} blb_${i} vdd_${vdd_index} vdd_${vdd_index} gnd wl_${j} sram_cell"
    done
done


echo -e "\n* Vdd Network"
for ((i=1; i<n+m-1; i++))
do
    echo "Xl${i} vdd_$((i-1)) vdd_${i} gnd RC_line"
done


echo -e "\n* Write Driver"

for ((i=0; i<n; i++)); do
    for ((j=0; j<m; j++)); do
        echo "Xwrite_driver_${i}_${j} vdd_$((n+m-2)) gnd din_${i} wre bl_${i} blb_${i} write_driver"
    done
done

echo -e "\n* Precharge Circuit"

for ((i=0; i<n; i++)); do
    echo "Xprecharge_${i} bl_${i} blb_${i} vdd_$((n+m-2)) precharge precharge_circuit"
done



