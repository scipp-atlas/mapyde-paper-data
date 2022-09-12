resultsdir="SUSY_Higgsino_isr2L_grid_20220822"
baseresultsdir="/data/users/mhance/SUSY"

mkdir -p "configs/$resultsdir"

madspin=1
remakeconfig=1

for N2 in 100 125 150 175 200 225 250; do
    for dM in 1.5 2 3 5 10 15 20 30 40 60; do

	N1=$(bc <<< "scale=2; (${N2}-${dM})")
	C1=$(bc <<< "scale=2; (${N2}+${N1})/2")

	mergetag="SUSY_Higgsino_isr2L_${N2}_${N1}"
	mergedir=$baseresultsdir/$resultsdir/$mergetag
	mkdir -p ${mergedir}
	
	for proc in n2n1 n2c1p n2c1m; do

	    newconfig="configs/${resultsdir}/${mergetag}_${proc}.toml"

	    if [[ $remakeconfig == 1 ]]; then
		# ==============================================================================
		# make a new config file from a template
		sed s_"MN2 = xxx"_"MN2 = ${N2}"_ configs/SUSY_Higgsino_isr2L_template.toml |
		    sed s_"MN1 = xxx"_"MN1 = ${N1}"_ |
		    sed s_"MC1 = xxx"_"MC1 = ${C1}"_ |
		    sed s="/data/users/mhance/SUSY"="$baseresultsdir/$resultsdir"= |
		    sed s/"xxx_xxx"/"${N2}_${N1}_${proc}"/ > $newconfig
		# ==============================================================================
		
		
		# ==============================================================================
		# if we're using Madspin for decays then set that up here
		if [[ $madspin == 1 ]]; then
		    echo "
[madspin]	    
skip = false	    
card = \"{{madgraph['proc']['name']}}\"
" >> $newconfig		
		    
		    sed -i s/"\[madgraph\]"/"\[madgraph\]\nrun_without_decays=false"/ $newconfig
		    
		    echo "
[madgraph.proc] 
name = \"isr2L_${proc}_nodecays\"
" >> $newconfig
		else
		    echo "
[madgraph.proc] 
name = \"isr2L_${proc}\"
" >> $newconfig
		fi
  	        # ==============================================================================
	    
	    
  	        # ==============================================================================
	        # set the BR's for C1C1 correctly
		if [[ $proc == "c1c1" ]]; then
		    br=1
		    case $dM in
			1.5) br="0.155";;
			[1-3]) br="0.155";;
			5) br="0.133";;
			10) br="0.112";;
			*) br="0.111";;
		    esac
		    br2=$(echo "${br}" | awk '{printf "%f", $1 * $1}')
		    sed -i s/"\[analysis\]"/"\[analysis\]\nbranchingratio = $br2"/ $newconfig
		fi
		# ==============================================================================
	    fi
	    
	    
	    # ==============================================================================
	    # run the config file
	    #mapyde run delphes ${newconfig}
	    #mapyde run analysis ${newconfig}
	    #mapyde run simpleanalysis ${newconfig}
	    mapyde run all ${newconfig} &
	    # ==============================================================================

        done

	# wait for previous jobs to complete
	wait

	# ==============================================================================
	# get ready to merge
	mergeinputs=""
	for proc in n2n1 n2c1p n2c1m; do
	    cp -p $baseresultsdir/$resultsdir/${mergetag}_${proc}/EwkCompressed2018.root ${mergedir}/EwkCompressed2018_${proc}.root
	    mergeinputs="$mergeinputs EwkCompressed2018_${proc}.root"
	done
	# ==============================================================================
	
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
