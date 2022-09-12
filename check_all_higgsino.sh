resultsdir="SUSY_Higgsino_isr2L_grid_20220906"
baseresultsdir="/data/users/mhance/SUSY"

# =====================================================================================
# check that files exist
#
for N2 in 100 125 150 175 200 225 250; do # 100
    for dM in 1.5 2 3 5 10 15 20 30 40 60; do

	res=$(grep "Expected limit" "$baseresultsdir/$resultsdir/SUSY_Higgsino_isr2L_${N2}_${N1}"/logs/docker_muscan.log)
	stat=$?

	echo "$N2  $N1  $stat  $res"
    done
done
# =====================================================================================
