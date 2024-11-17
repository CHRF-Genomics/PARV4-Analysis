home="/media/chrf/Home03/Trial_Preonath/TPRV/Analysis_on_new_data_v3_16_05_24/raw_assembled_data"
script="/home/chrf/WGS_Scripts/"

# Run mafft
cat $home\/Assembly_Cons/* > $home\/MAFFT/TPRV_57_merged.fa
grep -c ">" $home\/MAFFT/TPRV_57_merged.fa
sed -i -e 's/_TP4/ TP4/g' $home\/MAFFT/TPRV_57_merged.fa
sed -i -e 's/_L1_/ L1_/g' $home\/MAFFT/TPRV_57_merged.fa
cut -f 1 -d ' ' $home\/MAFFT/TPRV_57_merged.fa > $home\/MAFFT/tmp && mv $home\/MAFFT/tmp $home\/MAFFT/TPRV_57_merged.fa

mafft --maxiterate 1000 --localpair --thread 92 /media/chrf/Home03/Trial_Preonath/TPRV/Analysis_on_new_data_v3_16_05_24/mafft_input_output/bd/TPRV_71_bd.fa > /media/chrf/Home03/Trial_Preonath/TPRV/Analysis_on_new_data_v3_16_05_24/mafft_input_output/bd/TPRV_71_bd_mafft.fa

echo "Convert to phylip"
python /home/chrf/WGS_Scripts/fasta2phylip.py /media/chrf/Home03/Trial_Preonath/TPRV/Analysis_on_new_data_v3_16_05_24/mafft_input_output/global/TPRV_111_global_mafft.fasta -o /media/chrf/Home03/Trial_Preonath/TPRV/Analysis_on_new_data_v3_16_05_24/Raxml/global/TPRV_111_bd.phylip

mkdir -p $home\/MAFFT/raxml
cd $home\/MAFFT/

# Compute the best topology ("RAxML_bestTree" file):
time(raxmlHPC-PTHREADS-AVX -p 1501 -s TPRV_57_mafft.phylip -m GTRGAMMA -T 92 -o HQ113143 -n TPRV_57_mafft.bestTree)
# Compute 100 bootstraps to assess tree structure ( "RAxML_bootstrap" file):
time(raxmlHPC-PTHREADS-AVX -p 1501 -x 2023 -s TPRV_57_mafft.phylip -N 100 -m GTRGAMMA -T 92 -o HQ113143 -n TPRV_57_mafft.bsSupport)
# Compute final tree: (with RAxML_bestTree & RAxML_bootstrap)
time(raxmlHPC-PTHREADS-AVX -p 151 -m GTRGAMMA -f b -t RAxML_bestTree.TPRV_57_mafft.bestTree -T 4 -z RAxML_bootstrap.TPRV_57_mafft.bsSupport -o HQ113143 -n TPRV_57_mafft.bestTree.bsSupport)
cd
mv $home\/MAFFT/*TPRV_57_mafft* $home\/MAFFT/raxml/
cp $home\/MAFFT/raxml/RAxML_bipartitionsBranchLabels.* $home\/MAFFT/
cp $home\/MAFFT/RAxML_bipartitionsBranchLabels.TPRV_57_mafft.bestTree.bsSupport $home\/MAFFT/TPRV_57_mafft.bestTree.bsSupport.corrected



############ 71 #################











# Compute the best topology ("RAxML_bestTree" file):
time(raxmlHPC-PTHREADS-AVX  -p 1206 -s TPRV_71_bd.phylip -m GTRGAMMA -T 92 -n TPRV_71.bestTree)

# Compute 100 bootstraps to assess tree structure ( "RAxML_bootstrap" file):
time(raxmlHPC-PTHREADS-AVX -p 1206  -x 2023 -s TPRV_71_bd.phylip -N 1000 -m GTRGAMMA -T 92 -n TPRV_71.bsSupport)

# Compute final tree: (with RAxML_bestTree & RAxML_bootstrap)
time(raxmlHPC-PTHREADS-AVX -p 1206 -m GTRGAMMA -f b -t RAxML_bestTree.TPRV_71.bestTree -T 92 -z RAxML_bootstrap.TPRV_71.bsSupport -n TPRV_71.bestTree.bsSupport)



############### 72 #################

# Compute the best topology ("RAxML_bestTree" file):
time(raxmlHPC-PTHREADS-AVX  -p 1206 -s TPRV_72_bd.phylip -m GTRGAMMA -T 92 -o MH215556.1 -n TPRV_72.bestTree)

# Compute 100 bootstraps to assess tree structure ( "RAxML_bootstrap" file):
time(raxmlHPC-PTHREADS-AVX -p 1206  -x 2023 -s TPRV_72_bd.phylip -N 1000 -m GTRGAMMA -T 92 -o MH215556.1 -N 100 -n TPRV_72.bsSupport)

time(raxmlHPC-PTHREADS-AVX -p 1206 -m GTRGAMMA -f b -t RAxML_bestTree.TPRV_72.bestTree -z RAxML_bootstrap.TPRV_72.bsSupport -n TPRV_72_SNPallel.bestTree.bsSupport)




########### 111 ######################


# Compute the best topology ("RAxML_bestTree" file):
time(raxmlHPC-PTHREADS-AVX  -p 1206 -s TPRV_111_bd.phylip -m GTRGAMMA -T 92 -o MH215556.1 -n TPRV_111.bestTree)

# Compute 100 bootstraps to assess tree structure ( "RAxML_bootstrap" file):
time(raxmlHPC-PTHREADS-AVX -p 1206  -x 2023 -s TPRV_111_bd.phylip -N 1000 -m GTRGAMMA -T 92 -o MH215556.1 -N 100 -n TPRV_111.bsSupport)

time(raxmlHPC-PTHREADS-AVX -p 1206 -m GTRGAMMA -f b -t RAxML_bestTree.TPRV_111.bestTree -z RAxML_bootstrap.TPRV_111.bsSupport -n TPRV_111_SNPallel.bestTree.bsSupport)
