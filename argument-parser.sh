#!/bin/bash

# Define the regex for matching the arguments
regexArgShort='^-([a-zA-Z])$'
regexArgShortChained='^-([a-zA-Z]{2,})$'
regexArgLong='^--([a-zA-Z\-]{2,})$'

argChunks=()

# Expand chained short form arguments, eg -aih => -a -i -h
for argChunk in "$@"; do

	# See if this argument is a chained short form argument
	[[ $argChunk =~ $regexArgShortChained ]]
	if [ "${BASH_REMATCH[1]}" != "" ]; then

		# Get the chunk or arguments
		chainedChunk="${BASH_REMATCH[1]}";
		i=0
		# Expand out the chunk into individual arguments
		while (( i++ < ${#chainedChunk} )); do

			# Get just the argument on its own
			argumentIsolated="${chainedChunk:$i-1:1}"

			# Add the isolated argument to the argument chunk array
			argChunks+=("-$argumentIsolated")
		done
		continue;
	fi

	# Add the argument to the argument array
	argChunks+=("$argChunk")
done

# Initialise some variables
declare -A args
lastWasArgument=0
lastArgument=""

# Loop over all the argument chunks and determine if the argument type and value
for argChunk in "${argChunks[@]}"; do

	# Check if this chunk is a short form argument
	[[ $argChunk =~ $regexArgShort ]]
	if [ "${BASH_REMATCH[1]}" != "" ]; then
		argument="${BASH_REMATCH[1]}"
		lastWasArgument=1
		lastArgument="$argument"

		# Add the argument to the arguments array
		args["${BASH_REMATCH[1]}"]=''

		#echo "Argument (short): ${BASH_REMATCH[1]}"

		continue;
	fi

	# Check if this chunk is a long form argument
	[[ $argChunk =~ $regexArgLong ]]
	if [ "${BASH_REMATCH[1]}" != "" ]; then
		argument="${BASH_REMATCH[1]}"
		lastWasArgument=1
		lastArgument="$argument"

		# Add the argument to the arguments array
		args["${BASH_REMATCH[1]}"]=''

		#echo "Argument (long): ${BASH_REMATCH[1]}"

		continue;
	fi

	# If the last chunk was an argument and this wasn't assume its an argument value
	if [ $lastWasArgument == 1 ]; then

		# Add the arguments value to the arguments array
		args["$lastArgument"]="$argChunk"

		#echo "Argument Value: $argChunk"

		lastWasArgument=0
	fi
done

echo "---------"
for k in "${!args[@]}"
do
    echo "ARG: $k = ${args[$k]}"
done

[ ${args["u"]+abc} ] && echo "you passed the -u flag"

