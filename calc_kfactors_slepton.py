import glob

masses=[100,150,200,250]
dMs=[0.5,1,2,3,5,8,10,20,30,50]

# read in files
nlo={}
with open(f"cards/crosssecs/slepton.tsv") as f:
    for line in f:
        sline=line.split()
        sl=int(sline[0])
        nlo[sl]=float(sline[1])*3

kfacts=[]

for m in masses:
    for dM in dMs:
        n1=m-dM
        with open(f"/data/users/mhance/SUSY/SUSY_SleptonBino_isrslep_grid_20220907_0jet/SUSY_SleptonBino_isrslep_{m}_{n1}/logs/docker_mgpy.log") as f:
            lo=0
            for line in f:
                if "Cross-section :" in line:
                    lo=float(line.split()[2])
            if lo>0 and m in nlo:
                this_nlo=nlo[m]
                kfactor=this_nlo/lo
                kfacts.append(kfactor)
                print(f"k-factor for {m:3d} {dM:4.1f} = {this_nlo:4.3f}/{lo:4.3f} = {kfactor:3.2f}")
            else:
                print(f"k-factor for {m:3d} {dM:4.1f} = unknown/{lo} = unknown")


avgkfact=sum(kfacts)/len(kfacts)
print(avgkfact)
