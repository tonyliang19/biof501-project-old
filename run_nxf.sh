#!/bin/bash
# =============================================================
# Use this script now to run nextflow with relevant parameters
# And allowing for running with resume
# Author: Tony Liang
# =============================================================

# Configuration options
NXF_SRC_MAIN=main.nf # Main script to run
RESUME=FALSE # Initially run without resume
OUTDIR=results # Output directory for publishing files

# Add a parser from cli arg i.e.
# bash run_nxf.sh -r allows for resuming workflow
while getopts ":r" option;  # include both 'r' and 's' options
do 
  case $option in
  r)
    echo -e "Resuming pipeline\n"
    RESUME=TRUE
    ;;
  *)
    echo "Invalid option: -$OPTARG"
    exit 1
    ;;
  esac
done

# Always make sure to create the output directory
#mkdir -p $OUTDIR

if [ "${RESUME}" == "TRUE" ];
then
  # Only when provide -r in cli, then run the pipeline with resume
  nextflow run ${NXF_SRC_MAIN} \
  --outdir ${OUTDIR} \
  -resume
else
  # Otherwise run without resume
  nextflow run ${NXF_SRC_MAIN} \
  --outdir ${OUTDIR}
fi