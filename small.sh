#!/bin/bash
wd=`pwd`
jobname=`basename $wd`

cat << EOF > small.slurm
#!/bin/bash
#SBATCH --job-name=$jobname
#SBATCH --output=$jobname
#SBATCH -p astro2
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=8
#SBATCH --time=4-23:59:59

echo
echo "SLURM ENVIRONMENT"
echo "-----------------"
env | grep SLURM_ | sort | while read var; do
  echo " * $var"
done

echo
echo "STENO ENVIRONMENT"
echo "-----------------"
echo " * SCRATCH=$SCRATCH"
env | grep STENO_ | sort | while read var; do
  echo " * $var"
done

module load intel
module load mvapich2/intel

# Two job "steps"
srun hostname
srun -n32 --mpi=none ./pluto
#srun ./snoopy
#srun ./a.out
EOF


sbatch small.slurm


