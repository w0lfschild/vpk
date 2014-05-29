#!/bin/bash

# Make log directory
if [ ! -e ./logs ]; then 
	mkdir ./logs
fi

# Make all log files
for (( c=1; c<6; c++ )); do 
	if [ ! -e ./logs/${c}.log ]; then touch ./logs/${c}.log; fi 
done

# Cycle log files up (4->5, 3->4, 2->3, 1->2)
for (( c=5; c>1; c-- )); do 
	cat ./logs/$((c - 1)).log > ./logs/${c}.log
done

# Clear first log for data entry 
> ./logs/1.log
