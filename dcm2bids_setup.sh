#!/bin/bash

## Create fmri data folder structure for bids in <output_dir>
# 
# based on dcm2bids_scaffold
#
# <output_dir>
# └── code
# └── data
#     ├── bids_data
#     │   ├── derivatives
#     │   │   └── logs
#     │   └── logs
#     ├── logs
#     └── sourcedata


## Define test function for folders
function testdir {
	if [ ! -d $1 ]; then
		mkdir $1
	else
		echo "Output directory already exists: $1" 
	fi
}

## Process input arguments
usage(){ echo "Usage: `basename $0` -o <output_dir>" 1>&2; exit 1; }

if [ $# -ne 2 ]; then
	usage
fi

while getopts "o:" opt; do
    case "${opt}" in
        o)
            output_dir=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "$output_dir" ]; then
	usage
fi


## Create directories
if [ ! -d $output_dir ]; then
	echo "Creating output directory: $output_dir"
	testdir $output_dir
	
	if [ ! -d $output_dir ]; then
		echo "Error creating output directory: $output_dir"
		exit 1
	fi
fi

echo "Creating $output_dir/code"
testdir "$output_dir/code"

echo "Creating $output_dir/data"
testdir "$output_dir/data"

echo "Creating $output_dir/data/logs"
testdir $output_dir/data/logs

echo "Creating $output_dir/data/sourcedata"
testdir $output_dir/data/sourcedata

echo "Creating $output_dir/data/bids_data/"
testdir $output_dir/data/bids_data

echo "Creating $output_dir/data/bids_data/logs"
testdir $output_dir/data/bids_data/logs

echo "Creating $output_dir/data/bids_data/derivatives"
testdir $output_dir/data/bids_data/derivatives

echo "Creating $output_dir/data/bids_data/derivatives/logs"
testdir $output_dir/data/bids_data/derivatives/logs

echo "Copying initial dataset description and participant info files"
cp dataset_description.json $output_dir/data/bids_data/
cp participants.json $output_dir/data/bids_data/
cp participants.tsv $output_dir/data/bids_data/

echo "Done"


