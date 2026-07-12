#!/bin/bash

ml matlab

subj=$1

matlab -batch "get_strio_mask_on_server(${subj})"