resultsdir="SUSY_SleptonBino_isrslep_defaulteffics_grid_20230123"
baseresultsdir="/data/users/mhance/SUSY"

mkdir -p "configs/$resultsdir"

N=20

. slepton_functions.sh

# =====================================================================================
# run the main loop.
#
for slep in 100 150 200 250; do
    for dM in 0.5 1 2 3 5 8 10 15 20 30 50; do

	#run_point $slep $dM "defaulteffics_" &
	
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
# in case we need to (re)run something special after the fact
#
for slep in 100 150 200 250; do
    for dM in 0.5 1 2 3 5 8 10 15 20 30 50; do

	#rerun_from_sa2json $slep $dM &
	rerun_from_simpleanalysis $slep $dM &
	#rerun_from_analysis $slep $dM &
	#run_step $slep $dM pyhf &

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
#./check_all_slepton.sh
# =====================================================================================
