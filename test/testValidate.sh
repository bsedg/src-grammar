#!/bin/bash

# colors for printing to screen
RED=$(printf "\033[31m")
TEAL=$(printf "\033[32m")
RESET=$(printf "\033[m")

# input parsing
if [ "$#" -eq 0 ]
then
    command="help"
else
    command="test"
fi

# Commands for script: help, test
case $command in
"help" )
	echo 
"""
testValidate help                    - display help information
testValidate ELEMENT                 - test against ELEMENT.xml.* with ELEMENT.rng.ELEMENT.rng
"""
        ;;
"test" )
	element=$1
	FILES=$(ls xml/$element)

	for f in $FILES
	do
            java -jar ../lib/jing.jar rng/$element.rng xml/$element/$f > validation.temp.txt
	    lines=$(cat validation.temp.txt | wc -l)
	        
	        if [ -s "validation.temp.txt" ]
		        then
		    echo
		    # mac os 
		    echo "$f ${RED}doesn't validate${RESET} against $element grammar."
		    # non-mac os unix system
		    # echo -e "$f \e[1;31mdoesn't validate\e[0m against $element grammar."
		    echo -n "   "
		    srcml2src xml/$element/$f
		    echo

		    while read line
		    do
			echo $line | sed 's/.*xml//'
		    done < validation.temp.txt

		    echo
		else
		    # mac os 
		    echo "$f ${TEAL}validates${RESET} against $element grammar."
		    # non-mac os unix system
		    # echo -e "$f \e[1;34mvalidates\e[0m against $element grammar."
		    echo -n "   "
		    srcml2src xml/$element/$f
		fi

		rm -f validation.temp.txt
	done
	;;
esac
