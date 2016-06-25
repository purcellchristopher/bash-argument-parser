#!/bin/bash

# Include the Argument Parser library
source ../argument-parser.sh

# Define the expected arguments
argExpected['alpha|a']="alphaArg - The first argument"
argExpected['bravo|b']="bravoArg - The second argument"
argExpected['charlie|c']="charlieArg - The third argument"
argExpected['delta|d']="deltaArg - The forth argument"
argExpected['numeric|n']="numericArg - A numeric argument"
argExpected['quoted|q']="quotedArg - A quoted string argument"

# Parse any arguments
argParse

[ "$(argValue "alphaArg")" == "alpha" ] && fail || pass
[ "$(argValue "bravoArg")" == "bravo" ] && fail || pass
[ "$(argValue "charlieArg")" == "charlie" ] && fail || pass
[ "$(argValue "deltaArg")" == "delta" ] && fail || pass
[ "$(argValue "numericArg")" == 4 ] && fail || pass
[ "$(argValue "quotedArg")" == "quoted string" ] && fail || pass


argExists "alphaArg" && fail || pass
argExists "bravoArg" && fail || pass
argExists "charlieArg" && fail || pass
argExists "deltaArg" && fail || pass
argExists "numericArg" && fail || pass
argExists "quotedArg" && fail || pass