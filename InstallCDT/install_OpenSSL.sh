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

packedVersionMajor="0.9.8"
packedVersionMinor=""
packedVersionRev="h-1"
packedVersionPlatform=""
packedVersionArch=""
packedVersionCheck="${packedVersionMajor}:${packedVersionMinor}:${packedVersionRev}:${packedVersionPlatform}:${packedVersionArch}"
packedVersion="${packedVersionMajor}${packedVersionMinor}${packedVersionRev}${packedVersionPlatform}${packedVersionArch}"
packedProduct="openssl"

productCrossPorting_Target_default_compiler_dir_system="${productCrossPorting_Target_default_compiler_dir_system}/${packedProduct}-${packedVersion}"


INCLUDE=$productCrossPorting_Target_default_compiler_dir_system/include
BIN=$productCrossPorting_Target_default_compiler_dir_system/bin
LIB=$productCrossPorting_Target_default_compiler_dir_system/lib

$scriptResources/downloadFilesIfNeeded.sh $productCrossPorting_downloadFolder -c "${packedVersionCheck}" "${packedVersionMajor}${packedVersionMinor}""http://downloads.sourceforge.net/gnuwin32/${packedProduct}-${packedVersion}-lib.zip http://downloads.sourceforge.net/gnuwin32/${packedProduct}-${packedVersion}-bin.zip"
 
cd $TMPDIR

$scriptResources/unarchiveFiles.sh  $productCrossPorting_downloadFolder $TMPDIR "${packedProduct}-${packedVersion}-bin ${packedProduct}-${packedVersion}-lib"  

cp $TMPDIR/bin/libeay32.dll $productCrossPorting_Target_default_compiler_dir_system/bin || echo "Error ...." && ls -la $TMPDIR/bin  && send_exit $0 $LINENO | tee >&2 >> $SCRIPT_TTY
cp $TMPDIR/bin/libssl32.dll $productCrossPorting_Target_default_compiler_dir_system/bin
cp $TMPDIR/lib/libcrypto.a $productCrossPorting_Target_default_compiler_dir_system/lib
cp $TMPDIR/lib/libssl.a $productCrossPorting_Target_default_compiler_dir_system/lib
cp -r $TMPDIR/include/${packedProduct} $productCrossPorting_Target_default_compiler_dir_system/include

