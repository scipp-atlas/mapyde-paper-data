resultsdir="SUSY_Higgsino_isr2L_grid_20220815"
baseresultsdir="/data/users/mhance/SUSY"

mkdir -p "configs/$resultsdir"

madspin=1

for N2 in 250; do
    for dM in 1.5 2 3 5 10 15 20 25 30 40 60; do

	N1=$(bc <<< "scale=2; (${N2}-${dM})")
	C1=$(bc <<< "scale=2; (${N2}+${N1})/2")

	mergeinputs=""
	mergetag="SUSY_Higgsino_isr2L_${N2}_${N1}"
	mergedir=$baseresultsdir/$resultsdir/$mergetag
	mkdir -p ${mergedir}
	
	for proc in n2c1 n2n1 c1c1; do

	    # ==============================================================================
	    # get ready to merge this later
	    cp -p $baseresultsdir/$resultsdir/SUSY_Higgsino_isr2L_${proc}_${N2}_${N1}/EwkCompressed2018.root ${mergedir}/EwkCompressed2018_${proc}.root
	    mergeinputs="$mergeinputs EwkCompressed2018_${proc}.root"
	    # ==============================================================================
	    
        done

	mergeconfig="configs/$resultsdir/${mergetag}.toml"
	
	echo "
[base]
path = \"$baseresultsdir/$resultsdir\"
output = \"${mergetag}\"
template = \"{{PWD}}/templates/ewkinos.toml\"

[analysis]
lumi = 139000

[sa2json]
inputs = \"$mergeinputs\"
" > $mergeconfig

	mapyde run sa2json $mergeconfig
	mapyde run pyhf $mergeconfig
    done
done
