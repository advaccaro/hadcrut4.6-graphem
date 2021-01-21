#!/bin/bash
spars=$1
worldnum=$2
datatype=$3
kcv=$4
fn="SBATCH_PW$2$3_SP$1_KCV.txt"
rn="PW$2$3_KCV"
out="pw$2$3_SP_KCV"

touch $fn

echo "#!/bin/bash" >> $fn
echo "#SBATCH --job-name=$rn" >> $fn
echo "#SBATCH --mem=4GB" >> $fn
echo "#SBATCH --nodelist=iridium" >> $fn
echo "cd /home/geovault-02/avaccaro/hadcrut4.6-graphem/" >> $fn
echo "/usr/bin/matlab -nodesktop -nosplash > ./out/$out.out << EOF" >> $fn
echo "addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'));" >> $fn
echo "target_spars = $1/100;" >> $fn
echo "worldnum = $2;" >> $fn
echo "datatype = '$3';" >> $fn
echo "Kcv = $4;" >> $fn
echo "pseudoworld_graphem_sp_CV_kn(target_spars, Kcv, worldnum, datatype, false, true);" >> $fn
echo "exit" >> $fn
echo "EOF" >> $fn
