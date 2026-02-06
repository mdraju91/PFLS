num_seq=$(grep ">" "$1" | wc -l)
total_len=$(echo "$lengths" | awk '{s+=$1} END {print s}')