import mapyde
from mapyde.runner import run_madgraph, run_delphes, run_ana, run_sa2json, run_simpleanalysis, run_pyhf
from mapyde.utils import build_config, load_config
import os
import os.path

def create_config_file(filename):
    with open(filename,'w') as configfile:
        configfile.write("""
[base]
output = "SUSY_4305333_test_jupyter"
template = "{{PWD}}/templates/ewkinos.toml"
process_path = "{{PWD}}/cards/process/"
param_path = "{{PWD}}/cards/param/"

[madgraph]
params="4305333.spheno"
nevents=10000

[madspin]
skip = true

[madgraph.proc]
name = "ewkinos"

[pythia]
mpi = "off"

[analysis]
kfactor = 1.2
branchingratio = 1.0
""")
    return


def loadfile(filename):
    if not os.path.exists(filename) or True:
        create_config_file(filename)
    user = load_config(filename)
    config = build_config(user)
    return config

def run_all(filename):
    config = loadfile(filename)
    run_madgraph(config)
    run_delphes(config)
    run_ana(config)
    run_simpleanalysis(config)
    run_sa2json(config)
    if not config["pyhf"]["skip"]:
        stdout,stderr,results=run_pyhf(config)
    print(results)
    return results


results=run_all("test_mapyde.toml")
stdout,stderr,results=run_pyhf(loadfile("test_mapyde.toml"))
print(results)
