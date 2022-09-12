import glob

n1masses=[80,100,125,150,200]#,250]
dMs=[2,3,5,10,15,20,30,40,60]
procs=["n2n1","n2c1p","n2c1m","c1c1"]

# read in files
nlo={}
for p in procs:
    nlo[p]={}
    with open(f"cards/crosssecs/higgsino_{p}.tsv") as f:
        for line in f:
            sline=line.split()
            n2=float(sline[0])
            n1=int(sline[2])
            dM=n2-n1
            if n1 not in nlo[p]:
                nlo[p][n1]={}
            nlo[p][n1][n2]=float(sline[3])

kfacts=[]

for n1 in n1masses:
    for dM in dMs:
        for proc in procs:
            n2=n1+dM
            with open(f"/data/users/mhance/SUSY/SUSY_Higgsino_isr2L_0jet_grid_20220902/SUSY_Higgsino_isr2L_{n2}_{n1}_{proc}_0jet_nodecays/logs/docker_mgpy.log") as f:
                lo=0
                for line in f:
                    if "Cross-section :" in line:
                        lo=float(line.split()[2])
                if lo>0 and proc in nlo and n1 in nlo[proc] and n2 in nlo[proc][n1]:
                    this_nlo=nlo[proc][n1][n2]
                    kfactor=this_nlo/lo
                    kfacts.append(kfactor)
                    print(f"k-factor for {proc:6s} {n1:3d} {dM:2d} = {this_nlo:4.3f}/{lo:4.3f} = {kfactor:3.2f}")
                else:
                    print(f"k-factor for {proc:6s} {n1:3d} {dM:2d} = unknown/{lo} = unknwn")


avgkfact=sum(kfacts)/len(kfacts)
print(avgkfact)
