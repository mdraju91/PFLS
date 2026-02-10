

echo "FASTA File Statistics:"
echo "----------------------"
echo "Number of sequences: 0"
echo "Total length of sequences: 0"
echo "Length of the longest sequence: 0"
echo "Length of the shortest sequence: 0"
echo "Average sequence length: 0"
echo "GC Content (%): 0"

echo "FASTA File Statistics:"

# Count number of sequences (lines starting with >)
number_of_seq=$(grep -c "^>" "$1")
echo "Number of sequences: $number_of_seq"

# Total length of all sequences (excluding header lines)
total_length=$(grep -v "^>" "$1" | tr -d '\n' | wc -c)
echo "Total length of sequences: $total_length"

# Longest sequence
longest_seq=$(awk '
/^>/ {
    if (seqlen > max) max = seqlen
    seqlen = 0
    next
}
{
    seqlen += length($0)
}
END {
    if (seqlen > max) max = seqlen
    print max
}' "$1")
echo "Length of the longest sequence: $longest_seq"

# Shortest sequence
shortest_seq=$(awk '
/^>/ {
    if (seqlen && (min == 0 || seqlen < min)) min = seqlen
    seqlen = 0
    next
}
{
    seqlen += length($0)
}
END {
    if (seqlen && (min == 0 || seqlen < min)) min = seqlen
    print min
}' "$1")
echo "Length of the shortest sequence: $shortest_seq"

# Average length
if [ "$number_of_seq" -gt 0 ]; then
    average_seq=$((total_length / number_of_seq))
else
    average_seq=0
fi
echo "Average sequence length: $average_seq"

# GC count
amount_GC=$(grep -v "^>" "$1" | grep -o "[GgCc]" | wc -l)

# GC percentage
if [ "$total_length" -gt 0 ]; then
    percentage_GC=$(echo "scale=2; $amount_GC / $total_length * 100" | bc)
else
    percentage_GC=0
fi
echo "GC Content (%): $percentage_GC"