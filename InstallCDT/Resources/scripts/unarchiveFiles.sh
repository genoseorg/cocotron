#!/bin/sh

# ########## # ########### ########### ########### ##########
# ##
# ##    Cocotron installer compmunity updates
# ##    Based from Christopher J. W. Lloyd
# ##        :: Cocotron project ::
# ##
# ##    Created by Genose.org (Sebastien Ray. Cotillard)
# ##    Date 10-oct-2016
# ##    last update 25-oct-2016
# ##
# ##    Please support genose.org, the author and his projects
# ##    
# ##    Based on genose.org tools
# ##
# ##    //////////////////////////////////////////////////////////////
# ##    // http://project2306.genose.org  // git :: project2306_ide //
# ##    /////////////////////////////////////////////////////////////
# ##
# ##    -- Cocotron compmunity updates
# ##
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

source $( find $(dirname $0) -name common_functions.sh -type f -print )

#Copyright (c) 2006 Christopher J. W. Lloyd
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this
#software and associated documentation files (the "Software"), to deal in the Software
#without restriction, including without limitation the rights to use, copy, modify,
#merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
#permit persons to whom the Software is furnished to do so, subject to the following
#conditions:
#
#The above copyright notice and this permission notice shall be included in all copies
#or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
#PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
#OR OTHER DEALINGS IN THE SOFTWARE.


set -eu
sourceFolder=$1
destinationFolder=$2
listOfFiles="$3"
 
echo "Unarchive Get : (${sourceFolder}): (${destinationFolder}) :: (${listOfFiles})"
 
lastPwd=$(pwd)
unArchiverTool=$( which false )
unArchiverTool_path_tar=$( ($(test ""$(uname -s)""  == "Darwin" ) && which tar) || which bsdtar )

mkdir -p $destinationFolder

cd $destinationFolder;

for locationOfFile_cur in $listOfFiles
do
    
    locationOfFile=$sourceFolder/$locationOfFile_cur

    if [ -f $locationOfFile.tar.gz ];then
        extension=".tar.gz"
        unarchiveFlags="-xzf"
        unArchiverTool=$unArchiverTool_path_tar
        
    elif [ -f $locationOfFile.tar.bz2 ]; then
       extension=".tar.bz2"
       unarchiveFlag="-xjf"
       unArchiverTool=$unArchiverTool_path_tar
       
    elif [ -f $locationOfFile.zip ]; then  
        unarchiveFlags="-ov"
        extension=".zip"
        unArchiverTool="unzip"
    else
        echo "Unable to determine archive format of $locationOfFile, exiting" | tee >&2 >> $SCRIPT_TTY
        exit 1
    fi
     
    /bin/echo "Unarchiving $locationOfFile$extension ..." | tee >&2 >> $SCRIPT_TTY
 
    # ## (cd $destinationFolder; $unArchiverTool   $unarchiveFlags $locationOfFile$extension)
    
   if [ "${SYSTEM_HOST}" = "Darwin" ]; then
       
       # ## echo "=====xxxxxxx"
      # ##
      rm -Rv $destinationFolder/$( echo $locationOfFile_cur | tr "-" " " | awk '{print $1}' )*  || echo "Error ...."   && send_exit $0 $LINENO  | tee >&2 >> $SCRIPT_TTY
       
       cp -v $sourceFolder/$locationOfFile_cur$extension $destinationFolder || echo "Error ...."    && send_exit $0 $LINENO  | tee >&2 >> $SCRIPT_TTY   
       
       /System/Library/CoreServices/Applications/Archive\ Utility.app/Contents/MacOS/Archive\ Utility  $destinationFolder/$locationOfFile_cur$extension 
       # ## echo " status : " $?
       
       
      # ## find $destinationFolder -name  $( echo $locationOfFile_cur | tr "-" " " | awk '{ print $1 }' )"*" -type d  -print >> $SCRIPT_TTY
              
       
       rm  -v  $destinationFolder/$locationOfFile_cur$extension   || echo "Error ...."    && send_exit $0 $LINENO  | tee >&2 >> $SCRIPT_TTY     
     
   else
       $unArchiverTool $unarchiveFlags $locationOfFile$extension || echo "Error ...."    && send_exit $0 $LINENO  | tee >&2 >> $SCRIPT_TTY
   fi

    sleep 1
    echo " done." | tee >&2 >> $SCRIPT_TTY
done

cd $lastPwd
