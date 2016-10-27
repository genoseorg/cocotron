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


INCLUDE=$productCrossPorting_Target_default_compiler_dir_system/include
BIN=$productCrossPorting_Target_default_compiler_dir_system/bin
LIB=$productCrossPorting_Target_default_compiler_dir_system/lib

packedVersionMajor="0.1.5"
packedVersionMinor=""
packedVersionRev=""
packedVersionPlatform=""
packedVersionArch=""
packedVersionCheck="${packedVersionMajor}:${packedVersionMinor}:${packedVersionRev}:${packedVersionPlatform}:${packedVersionArch}"
packedVersion="${packedVersionMajor}${packedVersionMinor}${packedVersionRev}${packedVersionPlatform}${packedVersionArch}"
packedProduct="plibc"
 
$scriptResources/downloadFilesIfNeeded.sh $productCrossPorting_downloadFolder  -c "${packedVersionCheck}" "http://sourceforge.net/projects/${packedProduct}/files/plibc/${plibVersion}/${packedProduct}-${packedVersion}.zip"

$scriptResources/unarchiveFiles.sh  $productCrossPorting_downloadFolder $TMPDIR "${packedProduct}-${packedVersion}"  

mkdir -p $productCrossPorting_Target_default_compiler_dir_system/bin
cp bin/libplibc-1.dll  $productCrossPorting_Target_default_compiler_dir_system/bin || send_exit $0 $LINENO

mkdir -p $productCrossPorting_Target_default_compiler_dir_system/lib
cp lib/libplibc.dll.a $productCrossPorting_Target_default_compiler_dir_system/lib/libplibc.a || send_exit $0 $LINENO

mkdir -p $productCrossPorting_Target_default_compiler_dir_system/include
(cd include;tar -cf - *) | (cd $productCrossPorting_Target_default_compiler_dir_system/include;tar -xf -) || send_exit $0 $LINENO

