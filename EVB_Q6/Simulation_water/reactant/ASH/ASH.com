%Mem=8192MB
%NProcShared=8
%chk=098457434.chk
#P B3LYP/6-31g* Opt=(MaxCycle=900)

Protonated Aspartate

0 1
C          0.38800       -4.60200       -1.62000
H          0.23600       -5.65500       -1.85100
H          1.02800       -4.49900       -0.73800
H          0.90500       -4.11100       -2.45000
C         -0.95200       -3.94300       -1.38100
O         -2.01300       -4.53500       -1.48400
O         -0.93500       -2.64900       -1.05000
H         -0.01700       -2.26700       -0.94100

--link1--
%chk=098457434.chk
#P HF/6-31G* SCF=(Tight,MaxCycle=900) Geom=AllCheck Guess=Read Pop=MK IOp(6/33=2,6/41=10,6/42=17)

