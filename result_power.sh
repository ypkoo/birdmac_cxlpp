#!/bin/bash

source config.cfg

for mac in "${macs[@]}"; do
	result_dir="$title"_"$mac"
	rawdata_dir="$result_dir"/rawdata
	mkdir -p ../$result_dir/rates
	rm -f ../$result_dir/rates/*
	rm -f ../$result_dir/min_results/*
	files=$(ls ../$rawdata_dir/*result)

	for file in $files; do
		grep "\[data\]" $file > temp
		cat temp > $file
		rm temp
	done
done

for mac in "${macs[@]}"; do
	result_dir="$title"_"$mac"
	rawdata_dir="$result_dir"/rawdata

	rm -f ../$result_dir/over_rate
	for period in "${periods[@]}"; do
	  for sigma in "${sigmas[@]}"; do
	    for density in "${densities[@]}"; do
				for topology in "${topologies[@]}"; do
					for check_rate in "${check_rates[@]}"; do
						rm -f temp_power
			    	for seed in "${seeds[@]}"; do
							grep "AVG ON" ../$rawdata_dir/$period-$topology-$check_rate-$density-$seed-power >> temp_power
			      done
						awk -v rate="$check_rate" '{sum+=$3}; END {printf "%-4s%-10.3f #seed:%d\n", rate, sum/NR, NR}' temp_power >> ../$result_dir/rates/$period-$topology-$density
						rm -f temp_power
					done
	      done
	    done
	  done
	done
done


for mac in "${macs[@]}"; do
	result_dir="$title"_"$mac"
	rawdata_dir="$result_dir"/rawdata
	rm -f ../$result_dir/over_period
	for topology in "${topologies[@]}"; do
	  for sigma in "${sigmas[@]}"; do
	    for density in "${densities[@]}"; do
				
				echo "# topology" $topology >> ../$result_dir/over_period
				for period in "${periods[@]}"; do
					check_rate=$(./min_rate.sh $period $topology $density $mac)
					rm -f temp_power
			    for seed in "${seeds[@]}"; do
		      	grep "AVG ON" ../$rawdata_dir/$period-$topology-$check_rate-$density-$seed-power >> temp_power
			    done
					awk -v period="$period" -v rate="$check_rate" '{sum+=$3}; END {printf "%-4d%-10.3f # %.1f\n", period, sum/NR, rate}' temp_power >> ../$result_dir/over_period
					rm -f temp_power
				done
				echo "" >> ../$result_dir/over_period
	    done
	  done
	done
done

for mac in "${macs[@]}"; do
	result_dir="$title"_"$mac"
	rawdata_dir="$result_dir"/rawdata
	rm -f ../$result_dir/over_degree
	for period in "${periods[@]}"; do
	  for sigma in "${sigmas[@]}"; do
	    for density in "${densities[@]}"; do
				echo "# period" $period >> ../$result_dir/over_degree
				for topology in "${topologies[@]}"; do
					check_rate=$(./min_rate.sh $period $topology $density $mac)
					rm -f temp_power
	      	for seed in "${seeds[@]}"; do
						grep "AVG ON" ../$rawdata_dir/$period-$topology-$check_rate-$density-$seed-power >> temp_power
	        done
					awk -v degree="$topology" -v rate="$check_rate" '{sum+=$3}; END {printf "%-4d%-10.3f # %.1f\n", degree, sum/NR, rate}' temp_power >> ../$result_dir/over_degree
					rm -f temp_power
	      done
				echo "" >> ../$result_dir/over_degree
	    done
	  done
	done
done



