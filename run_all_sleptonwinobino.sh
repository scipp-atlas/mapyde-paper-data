resultsdir="SUSY_SleptonWinoBino_grid_20221116"
baseresultsdir="/data/users/mhance/SUSY"

mkdir -p "configs/$resultsdir"

. slepton_functions.sh

N=18

# =====================================================================================
# run the main loop.
#
for slep in 125; do #100 150 200 250; do
    for dM1 in 0.5 1 2 3 5 8 10 15 20 30 50; do
	for dM2 in 0.5 1 2 3 5 8 10 15 20 30 50; do

	    #run_3D_point $slep $dM1 $dM2 &
	    # sleep 1

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

for j in SUSY_SleptonWinoBino_isrslep_125_124_114 \
	     SUSY_SleptonWinoBino_isrslep_125_124_116 \
	     SUSY_SleptonWinoBino_isrslep_125_124_119 \
	     SUSY_SleptonWinoBino_isrslep_125_124_121 \
	     SUSY_SleptonWinoBino_isrslep_125_124_122 \
	     SUSY_SleptonWinoBino_isrslep_125_124_123.5 \
	     SUSY_SleptonWinoBino_isrslep_125_124_123 \
	     SUSY_SleptonWinoBino_isrslep_125_124.5_104.5 \
	     SUSY_SleptonWinoBino_isrslep_125_124.5_109.5 \
	     SUSY_SleptonWinoBino_isrslep_125_124.5_114.5 \
	     SUSY_SleptonWinoBino_isrslep_125_124.5_116.5 \
	     SUSY_SleptonWinoBino_isrslep_125_124.5_119.5 \
	     SUSY_SleptonWinoBino_isrslep_125_124.5_121.5 \
	     SUSY_SleptonWinoBino_isrslep_125_124.5_122.5 \
	     SUSY_SleptonWinoBino_isrslep_125_124.5_123.5 \
	     SUSY_SleptonWinoBino_isrslep_125_124.5_124.0 \
	     SUSY_SleptonWinoBino_isrslep_125_124.5_74.5 \
	     SUSY_SleptonWinoBino_isrslep_125_124.5_94.5 \
	 ; do
    mapyde run all configs/${resultsdir}/${j}.toml &
done

wait
    
# =====================================================================================
# in case we need to (re)run something special after the fact
#
for slep in 100 150 200 250; do
    for dM1 in 0.5 1 2 5 10 20 50; do
	for dM2 in 0.5 1 2 5 10 20 50; do

	    #rerun_from_sa2json $slep $dM &
	    #rerun_from_simpleanalysis $slep $dM &
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
done
# =====================================================================================

wait

# =====================================================================================
# check that files exist
#
#./check_all_slepton.sh
# =====================================================================================
