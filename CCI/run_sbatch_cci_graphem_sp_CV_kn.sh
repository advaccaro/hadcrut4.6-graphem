#!/bin/bash
spars=$1
kcv=$2
fn="SBATCH_CCI_SP$1_K$2.txt"
rn="CCI_SP$1_K$2"
out="cci_graphem_sp$1_k$2"

touch $fn

echo "#!/bin/bash" >> $fn
echo "#SBATCH --jobname=$rn" >> $fn
echo "#SBATCH --mem=250MB" >> $fn
echo "#SBATCH --nodelist=equake-02" >> $fn
echo "cd /home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI" >> $fn
echo "/usr/bin/matlab -nodesktop -nosplash > ./out/$out.out << EOF" >> $fn
echo "addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'));" >> $fn
echo "target_spars = $1/100;" >> $fn
echo "Kcv = $2;" >> $fn
echo "cci_graphem_sp_CV_kn(target_spars, Kcv);" >> $fn
echo "exit" >> $fn
echo "EOF" >> $fn
