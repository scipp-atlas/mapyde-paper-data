oldresultsdir="SUSY_Higgsino_isr2L_grid_20220824"
resultsdir="SUSY_Higgsino_isr2L_test_20220824"
baseresultsdir="/data/users/mhance/SUSY"

mkdir -p "configs/$resultsdir"

. higgsino_functions.sh

#run_point 100  2 n2n1 &
#run_point 100 40 n2n1  &
#run_point 175 15 n2n1  &

wait

print_results () {
    N2=$1
    N1=$2
    proc=$3
    
    new_exp=$(grep "Expected limit" $baseresultsdir/$resultsdir/SUSY_Higgsino_isr2L_${N2}_${N1}_${proc}/logs/docker_muscan.log)
    old_exp=$(grep "Expected limit" $baseresultsdir/$oldresultsdir/SUSY_Higgsino_isr2L_${N2}_${N1}_${proc}/logs/docker_muscan.log)
    echo "$N2  $N1  $proc:  New: ${new_exp}   Old: ${old_exp}"
}

print_results 100 98   "n2n1"
print_results 100 60   "n2n1"
print_results 175 160  "n2n1"


