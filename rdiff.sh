#!/bin/bash

if [ $(echo $@ | grep '.*\@.*\:.*' | wc -l) -eq 0 ]; then
	diff $@
	echo 123
	exit 0
fi

ON='\033[0;33m'
OFF='\033[0m'

type=''

output_msg () {
	out_1=$(echo "$3" | grep '^<' | awk '{print $2}' | awk '/^$/ {print "[EMPTY FIELD]"; next} {print}')
	out_2=$(echo "$3" | grep '^>' | awk '{print $2}' | awk '/^$/ {print "[EMPTY FIELD]"; next} {print}')
	
	result=''
	if [ -z "$out_1" ]; then
		result='None'
	fi
	echo -e "\n${ON}Differences that exist in $1:${OFF} $result\n$out_1"
	
	result=''
	if [ -z "$out_2" ]; then
		result='None'
	fi
	echo -e "\n${ON}Differences that exist in $2:${OFF} $result\n$out_2"
}

choose_diff() {
	type=$3

	input_1=($(echo $1 | tr '@' ' ' | tr ':' ' '))
	input_2=($(echo $2 | tr '@' ' ' | tr ':' ' '))

	if [ "$type" == "both" ]; then
		user_1=${input_1[0]}
		host_1=${input_1[1]}
		remote_path_1=${input_1[2]}

		user_2=${input_2[0]}
		host_2=${input_2[1]}
		remote_path_2=${input_2[2]}

		started=$(ssh -o StrictHostKeyChecking=no -q "$user_2@$host_2" cat "$remote_path_2")
		output=$(echo -e "$started" | diff - <(ssh -o StrictHostKeyChecking=no -q "$user_1@$host_1" cat "$remote_path_1"))

		output_msg "$host_1:$remote_path_1" "$host_2:$remote_path_2" "$output"
	fi

	if [ "$type" == "left" ]; then
		user=${input_1[0]}
		host=${input_1[1]}
		remote_path=${input_1[2]}

		local_path=${input_2[0]}

		output=$(cat "$local_path" | diff - <(ssh -o StrictHostKeyChecking=no -q "$user@$host" cat "$remote_path"))

		output_msg "$host:$remote_path" "$local_path" "$output"
	fi

	if [ "$type" == "right" ]; then
		user=${input_2[0]}
		host=${input_2[1]}
		remote_path=${input_2[2]}

		local_path=${input_1[0]}

		output=$(ssh -o StrictHostKeyChecking=no -q "$user@$host" cat "$remote_path" | diff "$local_path" -)

		output_msg "$local_path" "$host:$remote_path" "$output"
	fi
}

res_1=$(echo $1 | grep '.*\@.*\:.*' | wc -l)
res_2=$(echo $2 | grep '.*\@.*\:.*' | wc -l)

if [[ ( $res_1 -eq 1) && ( $res_2 -eq 1) ]]; then
	choose_diff $1 $2 "both"
elif [ $res_1 -eq 1 ]; then
	choose_diff $1 $2 "left"
elif [ $res_2 -eq 1 ]; then
	choose_diff $1 $2 "right"
fi