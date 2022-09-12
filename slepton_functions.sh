run_point () {
    slep=$1
    dM=$2
    templatetag=${3:-""}
    step=${4:-all}

    N1=$(bc <<< "scale=2; (${slep}-${dM})")

    mergetag="SUSY_SleptonBino_isrslep_${slep}_${N1}"
	
    newconfig="configs/${resultsdir}/${mergetag}.toml"
    echo $newconfig
    
    # ==============================================================================
    # make a new config file from a template
    sed s_"MSLEP = xxx"_"MSLEP = ${slep}"_ configs/SUSY_SleptonBino_isrslep_${templatetag}template.toml |
	sed s_"MN1 = xxx"_"MN1 = ${N1}"_ |
	sed s="/data/users/mhance/SUSY"="$baseresultsdir/$resultsdir"= |
	sed s/"xxx_xxx"/"${slep}_${N1}"/ > $newconfig
    # ==============================================================================
    
    # ==============================================================================
    # run the config file
    mapyde run ${step} ${newconfig}
    # ==============================================================================
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
