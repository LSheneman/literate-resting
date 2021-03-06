#!/bin/bash

# Authored by Leigh Sheneman 
#set -x

script=${1}.sh
echo ${script}

#clearing out the IFS to make bash not strip out leading whitespace
IFS=''
inshell=FALSE #wrapper
incode=FALSE  #exe code-block flag
looped=FALSE  #switch for end of exe code-block
rm -f ${script}

#clearing out the IFS to make bash not strip out leading whitespace
IFS=''
inshell=FALSE

while read line
do
   if [ "$line" = ".. shell start" ]
   then
       inshell=TRUE    
   elif [ "$line" = ".. shell stop" ]
   then

       inshell=FALSE
   fi
   if [ "$inshell" = "TRUE" ] && [[ $(echo "$line" | cut -c-2) == "::" ]]
   then
       incode=TRUE
   fi
   if [ "$incode" = "TRUE" ] && ( echo $line | grep '^   ' ) 
   then
       echo $line | cut -c4- >> ${script}
       looped=TRUE
   elif [ "$looped" = "TRUE" ] && [ "$line" != "::" ]
   then
       incode=FALSE
       looped=FALSE
   fi
done < $1