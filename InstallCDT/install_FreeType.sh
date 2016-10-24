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

./install_zlib.sh


packedVersionMajor="2.3.5"
packedVersionMinor=""
packedVersionRev="-1"
packedVersionPlatform=""
packedVersionArch=""
packedVersionCheck="${packedVersionMajor}:${packedVersionMinor}:${packedVersionRev}:${packedVersionPlatform}:${packedVersionArch}"
packedVersion="${packedVersionMajor}${packedVersionMinor}${packedVersionRev}${packedVersionPlatform}${packedVersionArch}"
packedProduct="freetype"

$scriptResources/downloadFilesIfNeeded.sh $productCrossPorting_downloadFolder -c "${packedVersionCheck}" "http://downloads.sourceforge.net/gnuwin32/${packedProduct}-${packedVersion}-bin.zip"
 

cd $productCrossPorting_Target_default_compiler_dir_system

$scriptResources/unarchiveFiles.sh  $productCrossPorting_downloadFolder $productCrossPorting_Target_default_compiler_dir_system   "${packedProduct}-${packedVersion}-bin"

