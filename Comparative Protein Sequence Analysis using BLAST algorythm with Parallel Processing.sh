####
# In this script, we will use publically availlable data on mouse and zebrafish genome:
# - first we will do some data exploratory analysis 
# - then we will determine the time needed to complete the BLAST algorythm for 100 sequences and for the whole genome  
####


## Setting up the envoirment, logging into HPC cluster. 

# logging with appropriate ssh key
# setting the working directory 
cd ./mini_project/mouse_protein_sequences

## Downloading reference sequence for zebrafish
curl -O ftp://ftp.ncbi.nih.gov/refseq/D_rerio/mRNA_Prot/zebrafish.1.protein.faa.gz

# Similarly, downloading sequences 1 and 2 for the mouse- this sequences will be compared with reference
curl -O ftp://ftp.ncbi.nih.gov/refseq/M_musculus/mRNA_Prot/mouse.1.protein.faa
curl -O ftp://ftp.ncbi.nih.gov/refseq/M_musculus/mRNA_Prot/mouse.2.protein.faa

## Exploratory data analysis: 
# Counting the number of sequences in the mouse1 and mouse2 files
# Explanation: This uses grep to count the lines that start with ">" in the given files, indicating sequence headers.
grep -c ">" mouse.1.protein.faa
# Expected output: 42251
grep -c ">" mouse.2.protein.faa
# Expected output: 54783

# Total number of sequences: 97034

# Selecting the first 100 sequences using AWK
# Explanation: AWK is used to filter and copy the first 100 sequences from the input file.
awk '/^>/{n++} n<=100' mouse.1.protein.faa > mouse.1.protein.copy.faa

# Creating a BLAST database for the zebrafish protein sequences
# Explanation: This command uses makeblastdb to create a BLAST database from the zebrafish protein sequences.
makeblastdb -in zebrafish.1.protein.faa -dbtype prot

# Perform BLAST analysis for mouse1 and mouse2 sequences against the zebrafish database
# Explanation: BLAST is used to compare mouse protein sequences with zebrafish sequences and save the results.
blastp -query mouse.1.protein.copy.faa -db zebrafish.1.protein.faa -out mouse1_output.txt
blastp -query mouse.2.protein.faa -db zebrafish.1.protein.faa -out mouse2_output.txt

# List of files for BLAST analysis:
# mouse.1.protein.copy.faa
# mouse.2.protein.faa

# Measure the time needed for BLAST with specified parameters and HPC threads
# Explanation: This command runs BLAST with the specified number of threads and records the execution time.
# For 12 threads: 
time blastp -query mouse.protein.faa.output -db zebrafish.1.protein.faa -num_threads 12 > out_12_threads
# For 8 threads: 
time blastp -query mouse.protein.faa.output -db zebrafish.1.protein.faa -num_threads 8 > out_8_threads
# For 4 threads: 
time blastp -query mouse.protein.faa.output -db zebrafish.1.protein.faa -num_threads 4 > out_4_threads
# For 2 threads:
time blastp -query mouse.protein.faa.output -db zebrafish.1.protein.faa -num_threads 2 > out_2_threads
# For 1 thread:
time blastp -query mouse.protein.faa.output -db zebrafish.1.protein.faa -num_threads 1 > out_1_thread

# Expected output: BLAST results will be saved in the 'out_n_threads' file, and the time taken will be measured.


