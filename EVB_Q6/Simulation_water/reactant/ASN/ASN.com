%Mem=8192MB
%NProcShared=8
%chk=098457434.chk
#P B3LYP/6-31g* Opt=(MaxCycle=900)

Asparagine molecule

0 1
C          2.93700        3.00300        3.56800
H          2.46800        3.10900        4.54900
H          3.45000        3.93200        3.30900
H          3.67800        2.20000        3.64300
C          1.87700        2.59000        2.56300
O          1.10800        1.65400        2.82300
N          1.85200        3.26800        1.39700
H          1.17200        3.04100        0.66400
H          2.46900        4.05000        1.24700

--link1--
%chk=098457434.chk
#P HF/6-31G* SCF=(Tight,MaxCycle=900) Geom=AllCheck Guess=Read Pop=MK IOp(6/33=2,6/41=10,6/42=17)

