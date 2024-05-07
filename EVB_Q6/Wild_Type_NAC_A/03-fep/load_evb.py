import os
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('pdb_file', help='Path to PDB topology file.')
parser.add_argument('input_folder', help='Folder with EVB dcd files')
args=parser.parse_args()
pdb_file = args.pdb_file
input_folder = args.input_folder

fep_files = {}
eql_files = []

for f in sorted(os.listdir(input_folder)):
    if f.endswith('.dcd'):
        if 'equil' in f:
            eql_files.append(input_folder+'/'+f)
        else:
            if f.split('_')[-1].split('.')[0] == '1':
                lbda = 1.0
            else:
                lbda = float('0.'+f.split('_')[-1].split('.')[1])
            fep_files[lbda] = input_folder+'/'+f

load_order = []
for lbda in sorted(fep_files, reverse=True):
    load_order.append(fep_files[lbda])
load_order = eql_files + load_order

os.system('vmd '+pdb_file+' '+' '.join(load_order))
