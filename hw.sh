#!/bin/bash

#--------------------------------------Function--------------------------------

help()
{
    echo "Usage: $(basename $0) [options]
    <empty parameters>   Traverses all the files in the current directory and for each file displays message:
              \"File <filename> is executable\"
              \"File <filename> is soft link\"
    Options:
      -h            Display this information

      <directory>   Traverses all the files in the specified directory and for each file displays message:
                    \"File <filename> is executable\"
                    \"File <filename> is soft link\" 
      -d <arg>      Serch recursively <depth of recursion in directory>
      -r            Search recursively
      "
    exit 0    
}

function check_file_type
{
if [ $# -eq 1 ]
then
if [ -x $1 ]
then 
   echo "File $1 executable"
elif [-L $1 ]
then
  echo "File $1 is soft link"  
fi
fi
}

function check_current_dir
{

for file in $1;
do

  check_file_type $file

done

}

function  Search_recursively
{

  for F in `find $1 -type f`
  do
    if [ -f $F ]
    then
      # echo '$F is file'
      if [ -x $F ]
        then 
            echo "File $F executable"
        elif [ -L $F ]
        then 
            echo "File $F is soft link"
      fi
    fi
  done

}


function  Search_recursively_maxdepth
{

  for F in `find $1  -maxdepth $2 -type f,l`
  do
    # echo "$F is file"
    if [ -f $F ]
    then
      
      if [ -x $F ]
      then 
          echo "File $F executable"
      fi

      if [ -L $F ]
      then 
          echo "File $F is soft link"
      fi
    fi
  done

}

#--------------------------------------Main------------------------------------


DEPTH_RECURSION=0
PATH_DIR="./"
# Get the options

if [ $# -eq 0 ]
then
  Search_recursively_maxdepth $PATH_DIR 1
else
  while getopts ':dhr' option; do
    case $option in
        h)
          help
          exit;;
        d)
          # echo "$(basename $0) -d $2 $3"
          if [ -z "$3" ]
          then
            # echo "No argument supplied"
            PATH_DIR="./"
          else
            PATH_DIR=${3}
          fi

          Search_recursively_maxdepth $PATH_DIR $2
          ;;
        r)
          # echo "$(basename $0) -r $2"
          if [ -z "$2" ]
          then
            # echo "No argument supplied"
            PATH_DIR="./"
          else
            PATH_DIR=${2}
          fi

          Search_recursively $PATH_DIR

          ;;
        \?)
          echo "Error: Invalid option"
          echo "Invalid option: -$OPTARG"
          exit 1
          ;;
    esac
  done

fi
