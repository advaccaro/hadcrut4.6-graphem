#!/bin/bash
dist=$1
kcv=$2
fn="SBATCH_CCI_KRIG$1_K$2_all.txt"
rn="CCI_KRIG$1_K$2"
out="cci_graphem_krig$1_k$2"

touch $fn

echo "#!/bin/bash" >> $fn
echo "#SBATCH --job-name=$rn" >> $fn
echo "#SBATCH --mem=1GB" >> $fn
echo "#SBATCH --nodelist=equake-03" >> $fn
echo "cd /home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI" >> $fn
echo "/usr/bin/matlab -nodesktop -nosplash > ./out/$out.out << EOF" >> $fn
echo "addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'));" >> $fn
echo "dist = $1;" >> $fn
echo "Kcv = $2;" >> $fn
echo "cci_krig_kn(dist, Kcv);" >> $fn
echo "exit" >> $fn
echo "EOF" >> $fn
