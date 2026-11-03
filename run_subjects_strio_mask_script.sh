#!/bin/bash

while read -r subj; do

    (
        echo "processing subj: ${subj}"
        sh strio_mask_script.sh ${subj}
    ) &
done < subject_to_run.txt

wait
echo "all subjects complete"
