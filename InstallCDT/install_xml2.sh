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

echo "Installing libxml2"
./install_zlib.sh


# ## productCrossPorting_Target_default_compiler_dir_system=`pwd`/../system/i386-mingw32msvc
# ## $( echo "/tmp/"$( basename $0 | tr "." " " | awk '{print $1}' ) )



packedVersionMajor="1.9.2"
packedVersionMinor=""
packedVersionRev=""
packedVersionPlatform=".win32"
packedVersionArch=""
packedVersionCheck="${packedVersionMajor}:${packedVersionMinor}:${packedVersionRev}:${packedVersionPlatform}:${packedVersionArch}"
packedVersion="${packedVersionMajor}${packedVersionMinor}${packedVersionRev}${packedVersionPlatform}${packedVersionArch}"
packedProduct="iconv"

packedVersionMajor_xml="2.2.7"
packedVersionMinor_xml=""
packedVersionRev_xml=""
packedVersionPlatform_xml=".win32"
packedVersionArch_xml=""
packedVersionCheck_xml="${packedVersionMajor_xml}:${packedVersionMinor_xml}:${packedVersionRev_xml_xml}:${packedVersionPlatform_xml}:${packedVersionArch_xml}"
packedVersion_xml="${packedVersionMajor}${packedVersionMinor_xml}${packedVersionRev_xml}${packedVersionPlatform_xml}${packedVersionArch_xml}"     
packedProduct_xml="libxml2"



packedProduct="agg"
# ## productCrossPorting_Target_default_compiler_dir_system="${productCrossPorting_Target_default_compiler_dir_system}/${packedProduct}-${packedVersion}"
productCrossPorting_Target_default_compiler_dir_system="${productCrossPorting_Target_default_compiler_dir_system}/"

$scriptResources/downloadFilesIfNeeded.sh $productCrossPorting_downloadFolder -c "${packedVersionCheck_xml}"  "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cocotron-tools-gpl3/${packedProduct_xml}-${packedVersion_xml}.zip" -c "${packedVersionCheck}" "ftp://ftp.zlatkovic.com/libxml/${packedProduct}-${packedVersion}.zip"

 
mkdir -p $productCrossPorting_Target_default_compiler_dir_system
cd $productCrossPorting_Target_default_compiler_dir_system

$scriptResources/unarchiveFiles.sh  $productCrossPorting_downloadFolder $productCrossPorting_Target_default_compiler_dir_system  "${packedProduct_xml}-${packedVersion_xml} ${packedProduct}-${packedVersion}"

# ## unzip -o $productCrossPorting_downloadFolder/libxml2-2.7.7.win32.zip
# ## unzip -o $productCrossPorting_downloadFolder/iconv-1.9.2.win32.zip

