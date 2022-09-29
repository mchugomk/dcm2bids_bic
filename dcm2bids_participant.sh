#!/bin/bash

## Run dcm2bids for a single subject


## Set study specific folders and files
study=rto											# study name
study_dir=/data/analysis/maureen/$study				# main study directory
data_dir=${study_dir}/data							# main data directory for sourcedata and bids output
bids_dir=$data_dir/bids_data						# bids data directory
sourcedata_dir=$data_dir/sourcedata					# directory with raw imaging files (e.g. IMA)
config_file=$study_dir/code/${study}_dcm2bids/dcm2bids_json_files/dcm2bids_config.json	# default json file describing imaging files for dcm2bids


## Process command line arguments
usage(){ echo "Usage: `basename $0` -d <source_subject_dir> -i <subject_id> -s <session_id> -c <config_file>
d:	directory containing single subject raw data for dcm2bids
i:	subject id for bids 
s:	session id for bids
c:	optional json config file for dcm2bids 

Example: `basename $0` -d RTO_300_1_181298 -i 300 -s 01
" 1>&2; exit 1; }

if [ $# -lt 6 ]; then
	usage
fi
	
while getopts "d:i:s:c:" opt; do
    case "${opt}" in
        d)
            source_subject_dir=${OPTARG}
            ;;
        i)
            subject_id=${OPTARG}
            ;;
        s)
            session_id=${OPTARG}
            ;;
        c)
        	config_file=${OPTARG}
        	;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))



## Check inputs
if [ ! -d $data_dir ]; then
	echo "Data directory $data_dir does not exist"
	exit 1
fi
if [ ! -d $bids_dir ]; then
	echo "BIDS data directory $bids_dir does not exist"
	exit 1
fi
if [ ! -d $sourcedata_dir/$source_subject_dir ]; then
	echo "Source data directory $sourcedata_dir/$source_dir does not exist"
	exit 1
fi
if [ ! -e $config_file ]; then
	echo "JSON file describing imaging files for dcm2bids does not exist: $config_file"
	exit 1
fi



## Run dcm2bids
echo "Running dcm2bids:
dcm2bids -d $sourcedata_dir/$source_subject_dir \
-p $subject_id \
-s $session_id \
-c $config_file \
-o $bids_dir
"
dcm2bids -d $sourcedata_dir/$source_subject_dir \
	-p $subject_id \
	-s $session_id \
	-c $config_file \
	-o $bids_dir




