#!/usr/bin/env python
'''
Author: Arif Mohammad Tanmoy (arif.tanmoy@chrfbd.org)
'''
from argparse import (ArgumentParser)

def parse_args():
	"Parse the input arguments, use '-h' for help"
	commands = ArgumentParser(description='Find Parv4 genotype from mapped VCF. Reference NC007018.1')
	commands.add_argument('--vcf', type=str, required=True, help='VCF file (Required).')
	commands.add_argument('--geno', type=str, required=True, help='Gentoype definition data (Required).')
	commands.add_argument('--output', type=str, required=False, default='Genotype_results.txt', help='Location and name for output file.')
	return commands.parse_args()
args = parse_args()

lineage = ['1', '2', '3']
target=[4, 6, 9]

genodata = open(args.geno, 'r')
vcf_file = open(args.vcf, 'r')
result = open(args.output, 'w')
result.write('Sample_Name\tGenotype\tConfidence\n')
sample = str(args.vcf).split('/')[-1]

# parse the genotype definition data
typee, pos, base = [], [], []
for rec in genodata:
	if not rec.startswith('#'):
		po, ba, ty, co =  rec.rstrip().split("\t")
		typee.append(str(ty))
		pos.append(str(po))
		base.append(str(ba))
#print(len(typee), len(pos), len(base))

# Parse VCF file to locate the positions
pos_found, type_found = [], []
for line in vcf_file:
	if not line.startswith("#"):
		CHROM, POS, ID, REF, ALT, QUAL, FILTER, INFO, FORMAT, Details = line.rstrip().split('\t')
		if str(POS) in pos:
			print(POS)
			index = pos.index(str(POS))
			if str(ALT) == str(base[index]):
				pos_found.append(str(POS))
				type_found.append(str(typee[index]))
type_sorted = list(set(type_found))

if len(type_sorted) == 0:
	print('Nothing Found. Could be something new.')
	result.write(sample + '\tnot_found')
elif len(type_sorted) == 1:
	genotype = str(type_sorted[0])
	i = lineage.index(genotype)
	pos_target = target[i]
	conf = round(((len(pos_found)/pos_target)*100),2)
	print('Genotype: '+genotype +' with confidence of '+str(conf)+'%.')
	result.write(sample + '\t' + genotype + '\t' + str(conf))
elif len(type_sorted) > 1:
	print('mixed genotypes has been detected.')
	genotype = str(type_sorted)
	print('Genotype: '+genotype)
	result.write(sample + '\t' + genotype)
