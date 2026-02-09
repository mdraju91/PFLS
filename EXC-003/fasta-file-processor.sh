

echo "FASTA File Statistics:"
echo "----------------------"
num_seq=$(grep ">" "$1" | wc -l)
echo "Number of sequences: $num_seq"
echo "Total length of sequences: 0"
echo "Length of the longest sequence: 0"
echo "Length of the shortest sequence: 0"
echo "Average sequence length: 0"
echo "GC Content (%): 0"
