#!/bin/bash
run_sbatch_cci_graphem_sp_CV_kn () {
	echo "#!/bin/bash
	#SBATCH --mem=250MB
	#SBATCH --job-name=CCI_SP$1_K$2
	#SBATCH --nodelist=equake-01,equake-02,equake-03,equake-04,equake-05
	cd /home/geovault-02/avaccaro/hadcrut4.6-graphem/CCI
	/usr/bin/matlab -nodesktop -nosplash > ./out/CCI_graphem_sp$1_k$2_CV.out << EOF
	addpath(genpath('/home/geovault-02/avaccaro/hadcrut4.6-graphem/'));
	target_spars = $1/100;
	Kcv = $2;
	cci_graphem_sp_CV_kn(target_spars, Kcv);
	exit
	EOF" >> tmp.slurm
	sbatch tmp.slurm
	rm tmp.slurm
}