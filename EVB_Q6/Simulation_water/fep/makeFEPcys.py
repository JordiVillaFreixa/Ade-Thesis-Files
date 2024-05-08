from Qpyl.qmakefep import make_fep
fepstring = make_fep(qmap_file="fep2.qmap", 
                        pdb_file="../Diol_water.pdb", 
                        forcefield="oplsaa",
                        parm_files=[".././ff/mysystem.prm"],
                        lib_files=[".././reactant/STO/STO.lib", ".././product/RRDiol/RRD.lib" , ".././reactant/ASH/ASH.lib", ".././reactant/ASP/ASP.lib",  ".././reactant/ARG/ARG.lib" ,  ".././ff/qoplsaa.lib", "../ff/H2O.lib"])
open("Diol_water.fep", "w").write(fepstring)
