#!/bin/bash
spars=$1
fn="SBATCH_PW_SP$1.txt"
rn="PW_SP$1"
out="pw_graphem_sp$1"

touch $fn

echo "#!/bin/bash" >> $fn
echo "#SBATCH --job-name=$rn" >> $fn
echo "#SBATCH --mem=8GB" >> $fn
echo "#SBATCH --nodelist=iridium" >> $fn
echo "cd /home/geovault-02/avaccaro/hadcrut4.6-graphem/pseudo_world" >> $fn
echo "/usr/bin/matlab -nodesktop -nosplash > ./out/$out.out << EOF" >> $fn
echo "addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem'));" >> $fn
echo "target_spars = $1/100;" >> $fn
echo "run_pw_graphem_sp_full(target_spars);" >> $fn
echo "exit" >> $fn
echo "EOF" >> $fn
