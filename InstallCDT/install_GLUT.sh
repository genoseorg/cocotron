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

# ## refer to https://www.cs.csustan.edu/~rsc/SDSU/GLUTinstall.html
# ## 2016 GLUT 3.7 No Longer Open sourced ....

packedVersionMajor="36"
packedVersionMinor=""
packedVersionRev=""
packedVersionPlatform=""
packedVersionArch=""
packedVersionCheck="${packedVersionMajor}:${packedVersionMinor}:${packedVersionRev}:${packedVersionPlatform}:${packedVersionArch}"
packedVersion="${packedVersionMajor}${packedVersionMinor}${packedVersionRev}${packedVersionPlatform}${packedVersionArch}"
packedProduct="glut"
 
$scriptResources/downloadFilesIfNeeded.sh $productCrossPorting_downloadFolder -c "${packedVersionCheck}" "http://www.opengl.org/resources/libraries/${packedProduct}/${packedProduct}dlls${packedVersion}.zip"

cd $TMPDIR

$scriptResources/unarchiveFiles.sh  $productCrossPorting_downloadFolder $TMPDIR "${packedProduct}dlls${packedVersion}"  

mkdir -pv $productCrossPorting_Target_default_compiler_dir_system/bin
cp -vp ${packedProduct}32.dll $productCrossPorting_Target_default_compiler_dir_system/bin || echo "Error ...." && ls -la $TMPDIR  && send_exit $0 $LINENO

mkdir -pv $productCrossPorting_Target_default_compiler_dir_system/lib
cp -vp ${packedProduct}32.lib $productCrossPorting_Target_default_compiler_dir_system/lib || echo "Error ...." && send_exit $0 $LINENO

mkdir -pv $productCrossPorting_Target_default_compiler_dir_system/include/GLUT
cp -vp ${packedProduct}.h $productCrossPorting_Target_default_compiler_dir_system/include/GLUT/GLUT.h || echo "Error ...." && send_exit $0 $LINENO


