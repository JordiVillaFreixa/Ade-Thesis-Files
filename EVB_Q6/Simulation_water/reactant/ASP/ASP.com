%Mem=8192MB
%NProcShared=8
%chk=098457434.chk
#P B3LYP/6-31g* Opt=(MaxCycle=900)

 Deprotonated Aspartate

-1 1
C         -4.42300        2.33300        2.95800
H         -5.34200        2.48100        3.52600
H         -4.20300        3.23300        2.37400
H         -3.58400        2.18400        3.64600
C         -4.54600        1.13300        2.02400
O         -5.62900        0.50700        1.98700
O         -3.51300        0.85100        1.31800

--link1--
%chk=098457434.chk
#P HF/6-31G* SCF=(Tight,MaxCycle=900) Geom=AllCheck Guess=Read Pop=MK IOp(6/33=2,6/41=10,6/42=17)

