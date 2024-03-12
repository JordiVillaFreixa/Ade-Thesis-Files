from Qpyl.qmakefep import make_fep
fepstring = make_fep(qmap_file="fep2.qmap", 
                        pdb_file="../RRDiol.pdb", 
                        forcefield="oplsaa",
                        parm_files=["../mysystem.prm"],
                        lib_files=["../Stilbene_oxide/Stilbene_Oxide.lib", "../RRDiol/RRD_Product.lib", "../qoplsaa.lib", "../ff/H2O.lib"])
open("RRD_Diol.fep", "w").write(fepstring)
