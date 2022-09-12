#
# We can't really do this, since running decays in MG will smear out the N2 mass and allow a lot of
# decays via taus and things like that which will mess up the kinematics/etc.  
#

resultsdir="SUSY_Higgsino_isr2L_grid_20220816"
baseresultsdir="/data/users/mhance/SUSY"

mkdir -p "configs/$resultsdir"

for N2 in 100 125 150 175 200 225 250; do
    for dM in 1.5 2 3 5 10 15 20 25 30 40 60; do

	N1=$(bc <<< "scale=2; (${N2}-${dM})")
	C1=$(bc <<< "scale=2; (${N2}+${N1})/2")

	newconfig="configs/$resultsdir/SUSY_Higgsino_isr2L_${N2}_${N1}.toml"
	
	# ==============================================================================
	# make a new config file from a template
	sed s_"MN2 = xxx"_"MN2 = ${N2}"_ configs/SUSY_Higgsino_isr2L_template.toml |
	    sed s_"MN1 = xxx"_"MN1 = ${N1}"_ |
	    sed s_"MC1 = xxx"_"MC1 = ${C1}"_ |
	    sed s="/data/users/mhance/SUSY"="$baseresultsdir/$resultsdir"= |
	    sed s/"xxx_xxx"/"${N2}_${N1}"/ > $newconfig
	# ==============================================================================


	# ==============================================================================
	# run the config file
	mapyde run all ${newconfig}
	# ==============================================================================

    done
done
