#!/bin/bash -l

#!/bin/bash
#SBATCH --time=90:59:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=8gb
## #SBATCH --job-name=equilibration
#SBATCH --partition=regular

##SBATCH --job-name=equil
##SBATCH -A snic2022-3-2
##SBATCH --time=20:00:00
##SBATCH -n 1
##SBATCH -c 16
##SBATCH --gpus-per-task=1


##################################################################################################################################
#                                                                                                                                #
#                                                                                                                                #
#     A_convertPdb2GaussianFilesForDifferentlyChargedMolecules_2024_03_27A.mcr                                                   #
#                                                                                                                                #
#     Hein. J. Wijma, 2023-03-27, h.j.wijma@rug.nl                                                                               #
#                                                                                                                                #
#                                                                                                                                #
##################################################################################################################################


# TableTarget = 'listPdbs'
Numerical='No'


#CONSOLE off
DEBUG = 1
# important for the charges, otherwise the Gaussian files get the wrong charge
Forcefield Yamber3 

# ensure to get random numbers each time, no repeats
RandomSeed Time

# number of processors gaussian is allowed to use
NumberOfProcessors  = 4 
    


ListElements() = 'H','He','Li','Be','B','C','N','O','F','Ne','Na','Mg','Al','Si','P','S','Cl','Ar','K','Ca','Sc','Ti','V','Cr','Mn','Fe','Co','Ni','Cu','Zn','Ga','Ge','As','Se','Br','Kr'


# read the table files
# --------------------------------------------------------------------------------------------------------------------------------



if (count TableTarget) == 0
  if MacroTarget == ''
    RAISEERROR Found not target for the macro
  else
    listStructures1 = '(MacroTarget)' 
else
  SHOWMESSAGE Please make sure you left the first line of the table file blank and that there are no .pdb file extensions
  WAIT ContinueButton
  LOADTAB (TableTarget)
  listStructures() = TAB 1
  DELTAB 1   
  SHOWMESSAGE A total  of (count listStructures) pdb files will be loaded and converted to mol2 files suitable for docking
  WAIT ContinueButton


# the list with protein structures to use
#LOADTAB (TableTarget)
#listStructures() = TAB 1
#DELTAB 1






# start working through the list of structures. 
# ================================================================================================================================

for i = 1 to count listStructures
  if 1
    # initialize the number of temporary saved structures
    savedStructuresN = 0
    
    # load the structure
    if Numerical=='Yes'
      listStructures(i) = (0+listStructures(i))
    LOADPDB (listStructures(i))
    
    
    
    if DEBUG
      PRINT ' '
      PRINT just loaded (listStructures(i))
   
    #get the overall charge, UNCLEAR HOW WELL THIS WILL WORK
    CurrentCharge = CHARGEOBJ 1
     
    # now need to get a list of all atoms that need to be frozen. 
    # ----------------------------------------------------------------------------------------------------------------------------
    
    # get a list of them all
    ListCurrentAtoms() = LISTATOM all
    
    # now determine for all of them whether they need to be frozen and get relevant data like their atom and their x, y, z positions. 
    for k = 1 to count ListCurrentAtoms
      # initialize as not frozen and adapt if necessary. Could be progremmmaed in easily
      FrozenStatus(k) = 0
      for l = 1 to count ToBeFrozen
        DoesItNeedToBeFrozen = COUNTATOM atom (k) and (ToBeFrozen(l))
        if DoesItNeedToBeFrozen > 0.5
          FrozenStatus(k) = -1
      # get x, y, z coordinates
      Xcoord(k),Ycoord(k),Zcoord(k) =POSATOM (k)
      Xcoord(k) = (0.00000 - (Xcoord(k)))
      Ycoord(k) = (0.00000 + (Ycoord(k)))
      Zcoord(k) = (0.00000 + (Zcoord(k)))
      
      # get element 
      NameElement(k) = ELEMENTATOM (k)
      NameElement(k) = '(ListElements(NameElement(k)))'   


    SHELL echo 'This line will be replaced'> (listStructures(i)).com
    for k = 1 to 3
      SHELL echo 'This line will be replaced'>> (listStructures(i)).com
    SHELL echo '(0+(CurrentCharge)) 1' >> (listStructures(i)).com
    for k = 1 to count ListCurrentAtoms
      SHELL echo '(NameElement(k))       (FrozenStatus(k))       (Xcoord(k))       (Ycoord(k))       (Zcoord(k))'  >> (listStructures(i)).com
    SHELL echo ''>> (listStructures(i)).com
    
    
    # also save a file with all relevant data in it (element, 
    
    for k = 1 to count ListCurrentAtoms
      # atom number
      TABULATE (k)
      # atom name
      NameAtom = LISTATOM (k), FORMAT=ATOMNAME
      TABULATE '(NameAtom)'
      # atom element
      TABULATE '(NameElement(k))'
      # frozen or not
      if FrozenStatus(k) < -0.5
        TABULATE 'frozen'
      else
        TABULATE 'free'

      
    SAVETAB 1,  (listStructures(i))_extraInfor.tab, format=text, columns=4, Numformat=12.4f, header='_atom_number _origin_name _the_element _ESP_charge'
    
    DELTAB 1  
    
    # store the file names and their charge
    savedStructuresN = (savedStructuresN) + 1
    nameSavedStructures(savedStructuresN) ='(listStructures(i))'
    nameSavedStructShort(savedStructuresN)='(listStructures(i))'
    WAIT ContinueButton    
        
    
    # for each of the generate .com files, adapt them to give them the proper settings for the RESP calculations
    # ============================================================================================================================ 
    

    
    
    for k =1 to savedStructuresN
      # get a random number to get a unique name for the chk file. Otherwise calculations might interfere.
      futureNameChkFile = rnd (100000000)
      futureNameChkFile = 000000000 +(futureNameChkFile)

      # now all this is to set up the right parameters for the RESP calculation of the .com file 
      # --------------------------------------------------------------------------------------------------------------------------    
   
      # this is to give the right set up  in the .com file for a RESP calculation, first AM1, then HF/6-31G*
      SHELL echo '%Mem=8192MB' > tmp.txt
      SHELL echo '%NProcShared=(NumberOfProcessors)' >> tmp.txt
      SHELL echo '%chk=(futureNameChkFile).chk' >> tmp.txt
      #SHELL echo '#P AM1 Opt=XXXMaxCycle=900,InitialHarmonic=50000YYY'| sed "s/XXX/\(/g"| sed 's/YYY/\)/g' >> tmp.txt
      SHELL echo '#P B3LYP/6-31g* Opt=XXXMaxCycle=900YYY'| sed "s/XXX/\(/g"| sed 's/YYY/\)/g' >> tmp.txt
      #SHELL echo '#P AM1 Opt=XXXMaxCycle=900YYY'| sed "s/XXX/\(/g"| sed 's/YYY/\)/g' >> tmp.txt
      SHELL echo '' >> tmp.txt
      SHELL echo 'first AM1 optimization' >> tmp.txt
      SHELL echo '' >> tmp.txt
      SHELL sed '5,1000!d' (nameSavedStructures(k)).com >> tmp.txt
      SHELL echo '--link1--'  >> tmp.txt
      SHELL echo '%chk=(futureNameChkFile).chk'  >> tmp.txt
      #SHELL echo '#P HF/6-31G* Opt=XXXMaxCycle=900,InitialHarmonic=50000YYY SCF=XXXTight,MaxCycle=900YYY Geom=AllCheck Guess=Read Pop=MK IOpXXX6/33=2,6/41=10,6/42=17YYY'| sed "s/XXX/\(/g"| sed 's/YYY/\)/g' >> tmp.txt
      SHELL echo '#P HF/6-31G* SCF=XXXTight,MaxCycle=900YYY Geom=AllCheck Guess=Read Pop=MK IOpXXX6/33=2,6/41=10,6/42=17YYY'| sed "s/XXX/\(/g"| sed 's/YYY/\)/g' >> tmp.txt
      #SHELL  echo '#P HF/6-31G* Opt=XXXMaxCycle=900YYY SCF=XXXTight,MaxCycle=900YYY Geom=AllCheck Guess=Read Pop=MK IOpXXX6/33=2,6/41=10,6/42=17YYY'| sed "s/XXX/\(/g"| sed 's/YYY/\)/g' >> tmp.txt
      SHELL mv tmp.txt (nameSavedStructures(k)).com


      # This is to make a batch_script to run the .com file at the Hábrók cluster
      # ------------------------------------------------------------------------------------------------------------------------------

      SHELL echo '#!/bin/bash' > tmp.txt
      SHELL echo '#SBATCH --time=01:59:00' >> tmp.txt
      SHELL echo '#SBATCH --ntasks=1' >> tmp.txt
      SHELL echo '#SBATCH --cpus-per-task=(NumberOfProcessors)' >> tmp.txt
      SHELL echo '#SBATCH --mem=8gb' >> tmp.txt
      SHELL echo '#SBATCH --job-name=QM-(listStructures(i))' >> tmp.txt
      SHELL echo '#SBATCH --partition=regular' >> tmp.txt
      SHELL echo '\n' >> tmp.txt
      SHELL echo 'module load    Gaussian/16.B.01' >> tmp.txt  
      SHELL echo 'srun g16  (nameSavedStructShort(k)).com (nameSavedStructShort(k)).out' >> tmp.txt
      SHELL mv tmp.txt  (nameSavedStructures(k))_batch_script
      SHELL chmod +x    (nameSavedStructures(k))_batch_script


    
    DELOBJ all 
EXIT    
