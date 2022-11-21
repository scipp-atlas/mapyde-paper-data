run_point () {
    slep=$1
    dM=$2
    templatetag=${3:-""}
    step=${4:-all}
    model=${5:-"SleptonBino"}
    proc=${6:-"isrslep"}

    N1=$(bc <<< "scale=2; (${slep}-${dM})")

    mergetag="SUSY_${model}_${proc}_${slep}_${N1}"
	
    newconfig="configs/${resultsdir}/${mergetag}.toml"
    echo $newconfig
    
    # ==============================================================================
    # make a new config file from a template
    sed s_"MSLEP = xxx"_"MSLEP = ${slep}"_ configs/SUSY_${model}_${proc}_${templatetag}template.toml |
	sed s_"MN1 = xxx"_"MN1 = ${N1}"_ |
	sed s="/data/users/mhance/SUSY"="$baseresultsdir/$resultsdir"= |
	sed s/"xxx_xxx"/"${slep}_${N1}"/ > $newconfig
    # ==============================================================================
    
    # ==============================================================================
    # run the config file
    mapyde run ${step} ${newconfig}
    # ==============================================================================
}

run_3D_point () {
    slep=$1
    dM1=$2
    dM2=$3
    templatetag=${4:-""}
    step=${5:-all}
    model=${6:-"SleptonWinoBino"}
    proc=${7:-"isrslep"}

    N2=$(bc <<< "scale=2; (${slep}-${dM1})")
    N1=$(bc <<< "scale=2; (${N2}-${dM2})")

    mergetag="SUSY_${model}_${proc}_${slep}_${N2}_${N1}"

    if [ -e $baseresultsdir/$resultsdir/$mergetag/madgraph ]; then
	echo "Output for  $baseresultsdir/$resultsdir/$mergetag already exists; skipping"
    else
	
	newconfig="configs/${resultsdir}/${mergetag}.toml"
	echo $newconfig
	
	# ==============================================================================
	# make a new config file from a template
	sed s_"MSLEP = xxx"_"MSLEP = ${slep}"_ configs/SUSY_${model}_${proc}_${templatetag}template.toml |
	    sed s_"MN1 = xxx"_"MN1 = ${N1}"_ |
	    sed s_"MN2 = xxx"_"MN2 = ${N2}"_ |
	    sed s_"MC1 = xxx"_"MC1 = ${N2}"_ |
	    sed s_"MSNU = xxx"_"MSNU = ${N2}"_ |
	    sed s="/data/users/mhance/SUSY"="$baseresultsdir/$resultsdir"= > $newconfig
	# ==============================================================================
	
	# ==============================================================================
	# run the config file
	mapyde run ${step} ${newconfig}
	# ==============================================================================
	
    fi
}

run_step () {
    slep=$1
    dM=$2
    N1=$(bc <<< "scale=2; (${slep}-${dM})")

    step=$3

    mergetag="SUSY_SleptonBino_isrslep_${slep}_${N1}"
    newconfig="configs/${resultsdir}/${mergetag}.toml"

    # ==============================================================================
    # run the config file
    mapyde run ${step} ${newconfig}
    # ==============================================================================
}

rerun_from_delphes () {
    slep=$1
    dM=$2
    N1=$(bc <<< "scale=2; (${slep}-${dM})")
    mergetag="SUSY_SleptonBino_isrslep_${slep}_${N1}"
    newconfig="configs/${newresultsdir}/${mergetag}.toml"
    
    # ==============================================================================
    # run the config file
    for step in delphes analysis simpleanalysis sa2json; do
	mapyde run ${step} ${newconfig}
    done	
    # ==============================================================================
}

rerun_from_analysis () {
    slep=$1
    dM=$2
    N1=$(bc <<< "scale=2; (${slep}-${dM})")
    mergetag="SUSY_SleptonBino_isrslep_${slep}_${N1}"
    newconfig="configs/${resultsdir}/${mergetag}.toml"
    
    # ==============================================================================
    # run the config file
    for step in analysis simpleanalysis sa2json pyhf; do
	mapyde run ${step} ${newconfig}
    done	
    # ==============================================================================
}

rerun_from_simpleanalysis () {
    slep=$1
    dM=$2
    N1=$(bc <<< "scale=2; (${slep}-${dM})")
    mergetag="SUSY_SleptonBino_isrslep_${slep}_${N1}"
    newconfig="configs/${resultsdir}/${mergetag}.toml"
    
    # ==============================================================================
    # run the config file
    for step in simpleanalysis sa2json pyhf; do
	mapyde run ${step} ${newconfig}
    done	
    # ==============================================================================
}

rerun_from_sa2json () {
    slep=$1
    dM=$2
    N1=$(bc <<< "scale=2; (${slep}-${dM})")
    mergetag="SUSY_SleptonBino_isrslep_${slep}_${N1}"
    newconfig="configs/${resultsdir}/${mergetag}.toml"
    
    # ==============================================================================
    # run the config file
    for step in sa2json pyhf; do
	mapyde run ${step} ${newconfig}
    done	
    # ==============================================================================
}
