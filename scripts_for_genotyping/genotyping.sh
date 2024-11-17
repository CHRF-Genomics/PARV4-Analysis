home=/media/chrf/Home03/Trial_Preonath/TPRV/Tanmoy_Recheck_tetratype
References=/home/chrf/Reference_Sequences/

mkdir -p $home\/Genotype/SAM

#for dir in $home\/Assembly_Cons/*; do
for dir in $home\/raw_assembled_data/*; do
	#name=$(basename ${dir} | cut -d '_' -f 1,2| cut -d '.' -f 1)
	name=$(basename ${dir} | cut -d '.' -f 1)
	echo "processsing : ${name}"
	minimap2 -ax asm5 $References\/TPRV/NC007018.1.fasta ${dir} | samtools sort -O bam -o $home\/Genotype/SAM/${name}_sorted.bam
	samtools index -@ 82 $home\/Genotype/SAM/${name}_sorted.bam
	echo "# Call SNPs and Indels"
	samtools mpileup -d 1000 -t DP -t SP -ugBf $References\/TPRV/NC007018.1.fasta $home\/Genotype/SAM/${name}_sorted.bam | bcftools call -cv --threads 80 | bcftools view -v snps --threads 80 > $home\/Genotype/SAM/$name\.raw.vcf
	echo "Running TetraType"
	python $home\/Tetratype.py --vcf $home\/Genotype/SAM/$name\.raw.vcf --geno $home\/Parv4_genotype_definition.txt --output $home\/Genotype/$name\.genotype
done

cat $home\/Genotype/*.genotype > $home\/CHRF_57.genotype

cat $home\/Genotype/*.genotype > $home\/NCBI30.genotype

cat $home\/Genotype/*.genotype > $home\/CHRF57_NCBI30.genotype

