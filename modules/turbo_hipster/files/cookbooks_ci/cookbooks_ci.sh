#!/bin/bash -e

#./$0 %(git_path)s %(job_working_dir)s %(unique_id)s

export GIT_PATH=$1
export JOB_WORKING_DIR=$2
export UNIQUE_ID=$3


/etc/turbo-hipster/scripts/testkitchen-prep.sh
/etc/turbo-hipster/scripts/run-job.sh


exit 0
