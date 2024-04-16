# alphafold_submit_sample
This is the bash file I use to achieve submit job on HPC running alphafold parallel

# AlphaFold Job Submission Script

This repository contains a SLURM job script for running AlphaFold predictions on a GPU-equipped computing cluster. It handles the submission of multiple job arrays to predict protein structures and extract Posterior Expected Accuracy (PAE) data.

## Prerequisites

To run this script, ensure you have:
- Access to a GPU-equipped SLURM cluster.
- Installed AlphaFold and all its dependencies.
- The `extract_pae.py` script placed in the `scripts` directory.

## Files Description

- **SLURM script**: A bash script to submit jobs for running AlphaFold on a list of sequences.
- **extract_pae.py**: Python script to extract PAE data from AlphaFold prediction results.

## Configuration

Before running the script, update the following placeholders in the SLURM script:
- `--output` and `--error`: Specify paths for the job output and error logs.
- `--mail-user`: Enter your email address to receive notifications.
- `PATH`: Update with the path to your bioinformatics tools directory.
- `SEQUENCES_DIR`: Specify the directory containing FASTA files of sequences.

## Usage

1. Place your FASTA files in the directory specified by `SEQUENCES_DIR`.
2. Update the script with required paths and configurations.
3. Submit the job to the SLURM cluster using the following command:
`sbatch <script_name>.sh`
4. Monitor job status with `squeue` or check the output/error files for progress.

## Output

The script will generate:
- PDB files in `output/pdb_files/sequence_{SLURM_ARRAY_TASK_ID}`
- PAE CSV files in `output/pae_files`

These directories will be created if they do not exist.

## Contact

For questions or troubleshooting, please open an issue in this repository or contact the repository maintainer.
