#!/bin/bash

while read -r subj; 
    do
    
    sh strio_mask_script.sh ${subj}

end < subject_list.txt