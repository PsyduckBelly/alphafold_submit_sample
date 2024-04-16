#!/bin/bash
#SBATCH --partition=scu-gpu
#SBATCH --job-name=alf_test
#SBATCH --nodelist=gpunode
#SBATCH --output=
#SBATCH --error=
#SBATCH --time=00:05:00
#SBATCH --mem=5G
#SBATCH --array=1-5
#SBATCH --mail-user=
#SBATCH --mail-type=ALL


# Update PATH with the directory of bioinformatics tools
export PATH=

# Debug: Echo PATH to ensure tools are correctly located
echo "Current PATH: $PATH"

# Define base directory for sequences
SEQUENCES_DIR="" # Updated from 'running_code/sequences'

# Define output directories for AlphaFold output (PDB files) and PAE files
PDB_OUTPUT_DIR="output/pdb_files/sequence_${SLURM_ARRAY_TASK_ID}"
PAE_OUTPUT_DIR="output/pae_files"
mkdir -p ${PDB_OUTPUT_DIR}
mkdir -p ${PAE_OUTPUT_DIR}

# Define the directory where the extract_pae.py script is located
PAE_SCRIPT_DIR="scripts"

# Debug: Ensure directories exist
echo "Checking directory presence:"
echo "SEQUENCES_DIR: ${SEQUENCES_DIR}"
echo "PDB_OUTPUT_DIR: ${PDB_OUTPUT_DIR}"
echo "PAE_OUTPUT_DIR: ${PAE_OUTPUT_DIR}"
echo "PAE_SCRIPT_DIR: ${PAE_SCRIPT_DIR}"

# Use SLURM_ARRAY_TASK_ID to select the sequence
FASTA_FILE="${SEQUENCES_DIR}/sequence_${SLURM_ARRAY_TASK_ID}.fasta"

# Debug: Echo FASTA path and list file to ensure it exists
echo "Running AlphaFold with FASTA file: ${FASTA_FILE}"
ls -l ${FASTA_FILE}

# Run AlphaFold for the selected sequence, ensuring all parameters are properly set
echo "Executing AlphaFold script..."
bash running_code/run_alphafold.sh -d running_code/sequences --fasta_paths "${FASTA_FILE}" -o "${PDB_OUTPUT_DIR}" -t 2024-03-14

# Extract PAE data from the resulting pkl files, assuming they are named according to sequence IDs
PKL_FILE="${PDB_OUTPUT_DIR}/result_${SLURM_ARRAY_TASK_ID}.pkl" 
CSV_FILE="${PAE_OUTPUT_DIR}/sequence_${SLURM_ARRAY_TASK_ID}_pae.csv"

# Debug: Check if the pickle file exists before attempting extraction
echo "Checking for pickle file at: ${PKL_FILE}"
if [ -f "$PKL_FILE" ]; then
    echo "Extracting PAE data to ${CSV_FILE}"
    python ${PAE_SCRIPT_DIR}/extract_pae.py "$PKL_FILE" "$CSV_FILE"
else
    echo "Pickle file not found: $PKL_FILE"
fi