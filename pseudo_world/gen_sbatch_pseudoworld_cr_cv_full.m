#!/bin/bash
dist=$1
worldnum=$2
datatype=$3
kcv=$4
fn="SBATCH_PW$2$3_CR$1_KCV.txt"
rn="PW$2$3_KCV"
out="pw$2$3_CR_k$4"

touch $fn

echo "#!/bin/bash" >> $fn
echo "#SBATCH --job-name=$rn" >> $fn
echo "#SBATCH --mem=4GB" >> $fn
echo "#SBATCH --nodelist=iridium" >> $fn
echo "cd /home/geovault-02/avaccaro/hadcrut4.6-graphem/" >> $fn
echo "/usr/bin/matlab -nodesktop -nosplash > ./out/$out.out << EOF" >> $fn
echo "addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'));" >> $fn
echo "dist = $1;" >> $fn
echo "worldnum = $2;" >> $fn
echo "datatype = '$3';" >> $fn
echo "Kcv = $4;" >> $fn
echo "pseudoworld_graphem_cr_CV_kn(dist, Kcv, worldnum, datatype, false, true);" >> $fn
echo "exit" >> $fn
echo "EOF" >> $fn
