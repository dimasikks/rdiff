#!/bin/bash

if [ $(echo $@ | grep '.*\@.*\:.*' | wc -l) -eq 0 ]; then
	diff $@
	exit 0
fi

ON='\033[0;33m'
OFF='\033[0m'

local_path=$1

input=($(echo $2 | tr '@' ' ' | tr ':' ' '))
user=${input[0]}
host=${input[1]}
remote_path=${input[2]}

output=$(ssh -o StrictHostKeyChecking=no -q "$user@$host" cat "$remote_path" | diff "$local_path" -)

echo -e "\n${ON}Differences that exist in local:${OFF}\n"
echo "$output" | grep '^<' | awk '{print $2}'

echo -e "\n${ON}Differences that exist in remote:${OFF}\n"
echo "$output" | grep '^>' | awk '{print $2}'


