resultsdir="SUSY_Higgsino_isr2L_grid_20220902"
baseresultsdir="/data/users/mhance/SUSY"

mkdir -p "configs/$resultsdir"

N=20
procs=("n2n1" "n2c1p" "n2c1m" "c1c1")

. higgsino_functions.sh

# =====================================================================================
# run the main loop.
#
for N1 in 80 100 125 150 200 250; do
    for dM in 1.5 2 3 5 10 15 20 30 40 60; do

	N2=$(bc <<< "scale=2; (${N1}+${dM})")

	for proc in ${procs[@]}; do

	    run_point $N2 $dM $proc &

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
# in case we need to (re)run something special after the fact
#
for N1 in 80 100 125 150 200 250; do
    for dM in 1.5 2 3 5 10 15 20 30 40 60; do

	N2=$(bc <<< "scale=2; (${N1}+${dM})")

	for proc in ${procs[@]}; do

	    # run_step $N2 $dM $proc pyhf &

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
for N1 in 80 100 125 150 200 250; do
    for dM in 1.5 2 3 5 10 15 20 30 40 60; do

	N2=$(bc <<< "scale=2; (${N1}+${dM})")

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
./check_all_higgsino.sh
# =====================================================================================
