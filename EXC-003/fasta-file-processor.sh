num_seq=$(grep ">" "$1" | wc -l)
total_len=$(echo "$lengths" | awk '{s+=$1} END {print s}')
max_len=$(echo "$lengths" | awk 'BEGIN{m=0} {if($1>m)m=$1} END{print m}')
min_len=$(echo "$lengths" | awk 'NR==1{m=$1} {if($1<m)m=$1} END{print m}')
_count=$(grep -v "^>" "$file" | tr -cd 'GCgc' | wc -c)
FASTA File Statistics:
----------------------
Number of sequences: ______
Echo $num_seq=$(grep ">" "$1" | wc -l)
Total length of sequences: _____
$ total_len=$(echo "$lengths" | awk '{s+=$1} END {print s}')
Length of the longest sequence: ______
max_len=$(echo "$lengths" | awk 'BEGIN{m=0} {if($1>m)m=$1} END{print m}')
Length of the shortest sequence: ______
min_len=$(echo "$lengths" | awk 'NR==1{m=$1} {if($1<m)m=$1} END{print m}')
Average sequence length: ______
GC Content (%): ______
_count=$(grep -v "^>" "$file" | tr -cd 'GCgc' | wc -c)cd