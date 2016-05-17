#!/bin/bash
# Brian Lynch 05/17/2016
# This script will search a directory (specified with the -f command line
# option) for files containing the extension (specified with the -e command
# line option).If no extension is specified, it will find all files. 
# It will then write all results to a file named
# <search/path>/<parentdirectory>List.list. If the output file already exists,
# it will move the existing file to ~/.local/share/Trash and create a new one.
# Spaces in directories must be escaped with \ \ on the command line option.

echo '---------------Running GetFilesinDir.sh---------------'

usage()
{
   echo 'Example Command: bash GetFilesinDir.sh -e <extention> -f <search/path>'
}

if [[ -z "$1" ]]; then usage; exit ; fi

# Parse the command line arguments
echo 'Parsing command line arguments...'
while [[ $# > 0 ]]; do

   key="$1" # $0 is the name of the script (always); $1 is the first argument

   # Check to see if the first argument matches a known argument
   case $key in
       -f|--extension)
          INPUTPATH="$2"
          shift 1  # Move past the argument by 1 so that $N -> $(N-1)
       ;;
       -e|--extension)
          EXTENSION="$2"
          shift 1  # Move past the argument by 1 so that $N -> $(N-1)
       ;;
       *)
         echo 'Unrecognized command line option' # Unknown option
         usage 
         exit
       ;;
   esac

   shift # Past argument or value

done

# Check if the input path is specified. If so, perform search
if [[ -n $INPUTPATH ]]; then

   echo Searching Path:  "${INPUTPATH}"
   parentdir="$(basename "${INPUTPATH}")"
   OUTFILE="${parentdir}List.list"
   echo Writing to file: "${OUTFILE}"

   mv "${INPUTPATH}/${OUTFILE}" ~/.local/share/Trash #rm -rf is a BAD IDEA

   # Loop through all the files in the current directory (if any)
   for file in "$INPUTPATH"/*$EXTENSION; do

      if [ -e "$file" ] ; then  # Make sure it isn't an empty match
         filename=$(basename "$file")
         echo "${filename}" >> "${INPUTPATH}/${OUTFILE}"      
      fi

      echo "${filename}"

   done

else
   echo 'ERROR: No search path specified'
   usage
fi

echo '---------------Exiting GetFilesinDir.sh---------------'
