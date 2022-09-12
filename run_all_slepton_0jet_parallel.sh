resultsdir="SUSY_SleptonBino_isrslep_grid_20220907_0jet"
baseresultsdir="/data/users/mhance/SUSY"

mkdir -p "configs/$resultsdir"

N=20

. slepton_functions.sh

# =====================================================================================
# run the main loop.
#
for slep in 100 150 200 250; do
    for dM in 0.5 1 2 3 5 10 15 20 30 50; do

	    run_point $slep $dM "0jet_" madgraph &

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
