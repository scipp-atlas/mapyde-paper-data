oldresultsdir="SUSY_Higgsino_isr2L_grid_20220824_noMPI"
newresultsdir="SUSY_Higgsino_isr2L_grid_20220824_delphes_leptoneff_001"
resultsdir=${newresultsdir}
baseresultsdir="/data/users/mhance/SUSY"

mkdir -p "configs/$newresultsdir"

N=20
procs=("n2n1" "n2c1p" "n2c1m") # "c1c1"

. higgsino_functions.sh



# =====================================================================================
# in case we need to (re)run something special after the fact
#
for N2 in 100 125 150 175 200 225 250; do # 100
    for dM in 1.5 2 3 5 10 15 20 30 40 60; do
	N1=$(bc <<< "scale=2; (${N2}-${dM})")
	
	for proc in ${procs[@]}; do

	    #mkdir -p $baseresultsdir/$newresultsdir/SUSY_Higgsino_isr2L_${N2}_${N1}_${proc}/madgraph/PROC_madgraph/Events/run_01_decayed_1
	    #cp -p $baseresultsdir/$oldresultsdir/SUSY_Higgsino_isr2L_${N2}_${N1}_${proc}/madgraph/PROC_madgraph/Events/run_01_decayed_1/tag_1_pythia8_events.hepmc.gz $baseresultsdir/$newresultsdir/SUSY_Higgsino_isr2L_${N2}_${N1}_${proc}/madgraph/PROC_madgraph/Events/run_01_decayed_1/

	    #mkdir -p $baseresultsdir/$newresultsdir/SUSY_Higgsino_isr2L_${N2}_${N1}_${proc}/logs
	    #cp -p $baseresultsdir/$oldresultsdir/SUSY_Higgsino_isr2L_${N2}_${N1}_${proc}/logs/docker_mgpy.log $baseresultsdir/$newresultsdir/SUSY_Higgsino_isr2L_${N2}_${N1}_${proc}/logs/
	    
	    #rerun_from_delphes $N2 $dM $proc &

	    # allow to execute up to $N jobs in parallel
	    if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
		# now there are $N jobs already running, so wait here for any job
		# to be finished so there is a place to start next one.
		wait -n
	    fi

        done
    done
done
# =====================================================================================

wait

# =====================================================================================
# now merge things together.
#
for N2 in 100 125 150 175 200 225 250; do
    for dM in 1.5 2 3 5 10 15 20 30 40 60; do

	merge_point $N2 $dM &

	# allow to execute up to $N jobs in parallel
	if [[ $(jobs -r -p | wc -l) -ge $N ]]; then
	    # now there are $N jobs already running, so wait here for any job
	    # to be finished so there is a place to start next one.
	    wait -n
	fi
    done
done
# =====================================================================================

wait

# =====================================================================================
# check that files exist
#
for N2 in 100 125 150 175 200 225 250; do
    for dM in 1.5 2 3 5 10 15 20 30 40 60; do

	N1=$(bc <<< "scale=2; (${N2}-${dM})")

	res=$(grep "Expected limit" "$baseresultsdir/$resultsdir/SUSY_Higgsino_isr2L_${N2}_${N1}"/logs/docker_muscan.log)
	stat=$?

	echo "$N2  $N1  $stat  $res"
    done
done
# =====================================================================================
