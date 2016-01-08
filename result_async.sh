#!/bin/bash

source config.cfg

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
					init_time=$(./init_time.sh $topology $mac)
			    for seed in "${seeds[@]}"; do
						cycle_num=29
		      	ontime=$(grep "AVG ON" ../$rawdata_dir/$period-$topology-$check_rate-$density-$seed-power | awk '{print $3}')
						echo $init_time $cycle_num $ontime | awk '{printf "%.3f\n", ($3-$1)/$2}' >> temp_power
			    done
					awk -v period="$period" -v rate="$check_rate" '{sum+=$1}; END {printf "%-4d%-10.6f # %.1f\n", period, sum/(NR*1000000), rate}' temp_power >> ../$result_dir/over_period
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
					init_time=$(./init_time.sh $topology $mac)
	      	for seed in "${seeds[@]}"; do
						cycle_num=29
		      	ontime=$(grep "AVG ON" ../$rawdata_dir/$period-$topology-$check_rate-$density-$seed-power | awk '{print $3}')
						echo $init_time $cycle_num $ontime | awk '{printf "%.3f\n", ($3-$1)/$2}' >> temp_power
	        done
					
					awk -v degree="$topology" -v rate="$check_rate" '{sum+=$1}; END {printf "%-4d%-10.6f # %.1f\n", degree, sum/(NR*1000000), rate}' temp_power >> ../$result_dir/over_degree
					rm -f temp_power
	      done
				echo "" >> ../$result_dir/over_degree
	    done
	  done
	done
done
