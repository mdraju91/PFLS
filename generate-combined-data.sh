#!/bin/bash

# Check required structure
if [ ! -d "RAW-DATA" ]; then
    echo "ERROR: RAW-DATA directory not found."
    exit 1
fi

if [ ! -f "RAW-DATA/sample-translation.txt" ]; then
    echo "ERROR: sample-translation.txt not found inside RAW-DATA."
    exit 1
fi

# Create output directory
mkdir -p COMBINED-DATA

# Loop through all DNA folders in RAW-DATA
for folder in RAW-DATA/DNA*; do

    lib=$(basename "$folder")

    # Get culture/sample name from column 2
    culture=$(awk -v lib="$lib" '$1==lib {print $2}' RAW-DATA/sample-translation.txt)

    if [ -z "$culture" ]; then
        echo "WARNING: No culture name found for $lib"
        continue
    fi

    echo "Processing $lib -> $culture"

    # Copy metadata files
    cp "$folder/checkm.txt" "COMBINED-DATA/${culture}-CHECKM.txt"
    cp "$folder/gtdb.gtdbtk.tax" "COMBINED-DATA/${culture}-GTDB-TAX.txt"

    mag_count=1
    bin_count=1

    # Process each FASTA in bins/
    for fasta in "$folder"/bins/*.fasta; do

        filename=$(basename "$fasta")

        # Handle unbinned separately
        if [[ "$filename" == *"unbinned"* ]]; then
            awk -v prefix="${culture}_UNBINNED" '
            /^>/ {print ">" prefix "_" substr($0,2); next}
            {print}
            ' "$fasta" > "COMBINED-DATA/${culture}_UNBINNED.fa"

        else
            # Strip .fasta
            binname="${filename%.fasta}"

            # Extract numeric part of bin and normalize
            binnum=$(echo "$binname" | sed -E 's/^bin[-_]?(.*)$/\1/')
            binname_clean="bin.$binnum"

            # Match in checkm.txt case-insensitively
            line=$(grep -i "$binname_clean" "$folder/checkm.txt")

            if [ -z "$line" ]; then
                echo "WARNING: No match in checkm.txt for $filename (tried $binname_clean)"
                continue
            fi

            # Get completion and contamination from columns 13 and 14
            completion=$(echo "$line" | awk '{print $13}')
            contamination=$(echo "$line" | awk '{print $14}')

            # Classify MAG vs BIN
            if (( $(echo "$completion >= 50" | bc -l) )) && \
               (( $(echo "$contamination <= 5" | bc -l) )); then

                number=$(printf "%03d" $mag_count)
                prefix="${culture}_MAG_${number}"

                awk -v prefix="$prefix" '
                /^>/ {print ">" prefix "_" substr($0,2); next}
                {print}
                ' "$fasta" > "COMBINED-DATA/${prefix}.fa"

                mag_count=$((mag_count + 1))

            else

                number=$(printf "%03d" $bin_count)
                prefix="${culture}_BIN_${number}"

                awk -v prefix="$prefix" '
                /^>/ {print ">" prefix "_" substr($0,2); next}
                {print}
                ' "$fasta" > "COMBINED-DATA/${prefix}.fa"

                bin_count=$((bin_count + 1))
            fi
        fi
    done
done

echo "All done! Check COMBINED-DATA directory."
