num_seq=$(grep ">" "$1" | wc -l)
total_len=$(echo "$lengths" | awk '{s+=$1} END {print s}')
max_len=$(echo "$lengths" | awk 'BEGIN{m=0} {if($1>m)m=$1} END{print m}')