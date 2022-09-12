resultsdir="SUSY_SleptonBino_isrslep_grid_20220907"
baseresultsdir="/data/users/mhance/SUSY"

# =====================================================================================
# check that files exist
#
for slep in 100 150 200 250; do
    for dM in 0.5 1 2 3 5 10 15 20 30 50; do

	N1=$(bc <<< "scale=2; (${slep}-${dM})")
	
	res=$(grep "Expected limit" "$baseresultsdir/$resultsdir/SUSY_SleptonBino_isrslep_${slep}_${N1}"/logs/docker_muscan.log)
	stat=$?

	echo "$slep  $N1  $stat  $res"
    done
done
# =====================================================================================
