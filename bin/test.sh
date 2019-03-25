#!/bin/bash

first=${1:-0.01}
second=${2:-0.02}

echo "first: $first"
echo "second: $second"

i=0
while [ $i -lt 3 ];do
	echo $i
	i=$((i+1))
done;


p=`docker network ls | grep -i 'docker' | awk -F ' ' '{print $1}'`
if [ $p != "" ];then
	echo $p
fi


# default 3 slaves
N=${N:-3}
version=${version:-0.2}

check_success(){
	if [[ $? -eq 0 ]]; then
	    echo "success"
	else
	    echo "failed"
	fi
}


POSITIONAL=()
while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -e|--extension)
    EXTENSION="$2"
    shift # past argument
    shift # past value
    ;;
    -s|--searchpath)
    SEARCHPATH="$2"
    shift # past argument
    shift # past value
    ;;
    -l|--lib)
    LIBPATH="$2"
    shift # past argument
    shift # past value
    ;;
    --default)
    DEFAULT=YES
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

echo FILE EXTENSION  = "${EXTENSION}"
echo SEARCH PATH     = "${SEARCHPATH}"
echo LIBRARY PATH    = "${LIBPATH}"
echo DEFAULT         = "${DEFAULT}"
echo "Number files in SEARCH PATH with EXTENSION:" $(ls -1 "${SEARCHPATH}"/*."${EXTENSION}" | wc -l)
if [[ -n $1 ]]; then
    echo "Last line of file specified as non-opt/last argument:"
    tail -1 "$1"
fi


master_ip=192.169.31.100
printf "%15.15s : %10s\n" "spark-master" "${master_ip}:7077"
printf "%15.15s : %10s\n" "web UI" "${master_ip}:8080"

