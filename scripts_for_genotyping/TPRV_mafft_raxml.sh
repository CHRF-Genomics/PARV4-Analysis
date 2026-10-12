home="/path/to/project/raw_assembled_data"
script="/path/to/scripts/"

# Run mafft
cat $home\/Assembly_Cons/* > $home\/MAFFT/TPRV_57_merged.fa
grep -c ">" $home\/MAFFT/TPRV_57_merged.fa
sed -i -e 's/_TP4/ TP4/g' $home\/MAFFT/TPRV_57_merged.fa
sed -i -e 's/_L1_/ L1_/g' $home\/MAFFT/TPRV_57_merged.fa
cut -f 1 -d ' ' $home\/MAFFT/TPRV_57_merged.fa > $home\/MAFFT/tmp && mv $home\/MAFFT/tmp $home\/MAFFT/TPRV_57_merged.fa

mafft --maxiterate 1000 --localpair --thread 92 /path/to/project/mafft_input_output/global/TPRV_106_global.fa > /path/to/project/mafft_input_output/global/TPRV_106_global_mafft.fa

echo "Convert to phylip"
python /path/to/scripts/fasta2phylip.py /path/to/project/mafft_input_output/global/TPRV_106_global_mafft.fasta -o /path/to/project/Raxml/global/TPRV_106_bd.phylip

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


########### 106 ######################


# Compute the best topology ("RAxML_bestTree" file):
time(raxmlHPC-PTHREADS-AVX  -p 1206 -s TPRV_106_bd.phylip -m GTRGAMMA -T 92 -o MH215556.1 -n TPRV_106.bestTree)

# Compute 1000 bootstraps to assess tree structure ( "RAxML_bootstrap" file):
time(raxmlHPC-PTHREADS-AVX -p 1206  -x 2023 -s TPRV_106_bd.phylip -N 1000 -m GTRGAMMA -T 92 -o MH215556.1 -n TPRV_106.bsSupport)

time(raxmlHPC-PTHREADS-AVX -p 1206 -m GTRGAMMA -f b -t RAxML_bestTree.TPRV_106.bestTree -z RAxML_bootstrap.TPRV_106.bsSupport -n TPRV_106_SNPallel.bestTree.bsSupport)
