#!/bin/bash
# Brian Lynch 07/26/2016
# This script will read an input file (specified with the -f command line
# option) that contains a list of other movie file names. It will then use
# my video_player and tracking routines to perform Particle Tracking
# Velocimetry.

# ls -d -1 "$PWD"/{*.img,.*}

echo '-----------------------------------------------------\n'
echo 'TrackProcessScript.sh \n'

usage()
{
   echo 'Example Calling Command: bash TrackProcessScript.sh -f <filename>'
}

if [[ -z "$1" ]]; then usage; exit ; fi

# Use > 1 to consume two arguments per pass in the loop (e.g. each
# argument has a corresponding value to go with it).
# Use > 0 to consume one or more arguments per pass in the loop (e.g.
# some arguments don't have a corresponding value to go with it such
# as in the --default example).
# note: if this is set to > 0 the /etc/hosts part is not recognized ( may be a bug )
while [[ $# > 0 ]]; do

   key="$1" # $0 is the name of the script (always); $1 is the first argument

   # Check to see if the first argument matches a known argument
   case $key in
       -f|--extension)
          INPUTFILE="$2"
          shift 1  # Move past the argument by 1 so that $N -> $(N-1)
       ;;
       *)
         echo 'Unrecognized command line option\n' # unknown option
         usage 
         exit
       ;;
   esac

   shift # past argument or value

done

if [[ -n $INPUTFILE ]]; then

   echo INPUT FILENAME  "${INPUTFILE}"

   pkill video_player
   pkill track

   parentdir="$(basename "${INPUTFILE}")"
   OUTFILE="${parentdir}List.list"
   echo Writing List to file: "${OUTFILE}"

   mv "${OUTFILE}" ~/.local/share/Trash #rm -rf is a BAD IDEA

   # Loop through the filenames
   while read -r line || [[ -n "$line" ]]; do

      name="$line"
      echo "Opening file - $name"

      # Remove any periods in the filename (.img ->img)
      fname="${line//./}" 
      echo "Output file - $fname"

      # Write the output filename to a list file
      echo "${fname}/_list.txt" >> "${OUTFILE}"

      # Run the player in background, sync with track is automatic
      video_player -d 0 -z -f --file="${name}" &
      sleep 1   

      # Start tracking
      track -s -f -i 55 --pstateo="${fname}"

      echo "Done processing file $name"
      sleep 1

      # Since they read/write shared memory, make absolutely sure they are dead
      pkill video_player
      pkill track

   done < "$INPUTFILE"
fi

echo '-----------------------------------------------------\n'
