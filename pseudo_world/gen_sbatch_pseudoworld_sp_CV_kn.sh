#!/bin/bash
spars=$1
kcv=$2
wn=$3
fn="SBATCH_CCI_SP$1_K$2_all.txt"
rn="PW_SP$1_K$2_A"
out="cci_graphem_sp$1_k$2_all"

touch $fn

echo "#!/bin/bash" >> $fn
echo "#SBATCH --job-name=$rn" >> $fn
echo "#SBATCH --mem=1GB" >> $fn
echo "#SBATCH --nodelist=equake-03" >> $fn
echo "cd /home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world" >> $fn
echo "/usr/bin/matlab -nodesktop -nosplash > ./out/$out.out << EOF" >> $fn
echo "addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'));" >> $fn
echo "target_spars = $1/100;" >> $fn
echo "Kcv = $2;" >> $fn
echo "cci_graphem_sp_CV_kn_Call(target_spars, Kcv);" >> $fn
echo "exit" >> $fn
echo "EOF" >> $fn
