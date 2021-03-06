 #!/bin/bash 
{
declare -A diffs
counter=0
HOM="HOM"

ARGS=( "$@" )
ORIGINAL_SOURCE=$1

OUTPUT_DIR=$(dirname ${ORIGINAL_SOURCE})"/HOM/"

for i in "${ARGS[@]:1}"
do
  FOM=$i
  
  #Find out where the FOMs is mutating the orginal file
  diff_FOM="$(diff -abB "$ORIGINAL_SOURCE" "$FOM" | head -1 | cut -f1 -d'c')"
  
  #Make sure no two FOMs mutate the same line in the original file
  for i in ${diffs[@]}; do
    if [ "$i" -eq $diff_FOM ]; then
      exit 255;
    fi
  done
  
  diffs[$counter]=$diff_FOM
  counter=$((counter+1))
  
  #Append the FOM file name to the HOM file name
  filename="${FOM##*/}"
  filenameWithoutExtension="${filename%.*}"
  HOM+="_${filename%.*}"
  
  
  #Check if we are making a HOM from a FOM or a HOM
  if [ "$counter" -eq 1 ]; then
    #Replace line number: diff_FOM of the original file with line:diff_FOM of the FOM
    sed -e "$diff_FOM c\\$(sed -n $diff_FOM'p' $FOM)" $ORIGINAL_SOURCE > 'tmp_HOM';
  fi
  
  #Replace line number: diff_FOM of current HOM file with line:diff_FOM of the FOM
  sed -i -e "$diff_FOM c\\$(sed -n $diff_FOM'p' $FOM)" 'tmp_HOM'

done

#Rename the newly generated HOM to reflect its FOMs
HOM+=".c"
echo "$HOM $OUTPUT_DIR$HOM" > hom_dir.log
mkdir -p $OUTPUT_DIR
mv 'tmp_HOM' $OUTPUT_DIR$HOM

}&>combineFOM.log

mv combineFOM.log $OUTPUT_DIR
mv hom_dir.log $OUTPUT_DIR
