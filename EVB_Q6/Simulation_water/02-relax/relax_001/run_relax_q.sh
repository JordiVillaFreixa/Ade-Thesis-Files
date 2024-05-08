#!/bin/bash -l

#!/bin/bash -l

#!/bin/bash
#SBATCH --time=20:59:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=8gb
#SBATCH --job-name=relax
#SBATCH --partition=regular

##SBATCH --job-name=equil
##SBATCH -A snic2022-3-2
##SBATCH --time=20:00:00
##SBATCH -n 1
##SBATCH -c 16
##SBATCH --gpus-per-task=1

module load GCC/11.3.0
alias evb="module load Anaconda3;module load GCC/11.3.0;conda activate evb"

OK="(\033[0;32m   OK   \033[0m)"
FAILED="(\033[0;31m FAILED \033[0m)"

steps=( $(ls -1v *inp | sed 's/.inp//') )

rs=$((1 + $RANDOM % 1000000))
sed -i s/987654321/$rs/ relax_001.inp

for step in ${steps[@]}
do
  echo "Running equilibration step ${step}"
  if Qdyn6 ${step}.inp > ${step}.log
  then
    echo -e "$OK"
  else 
    echo -e "$FAILED"
    echo "Check output (${step}.log) for more info."
    exit 1
  fi
done
