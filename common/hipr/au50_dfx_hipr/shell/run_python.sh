#!/bin/bash -e

python_name=$1
python_arg1=$2
python_arg2=$3
python_arg3=$4
python_arg4=$5

python3 ${python_name} ${python_arg1} -t ${python_arg2} -f ${python_arg3} -a ${python_arg4} 

