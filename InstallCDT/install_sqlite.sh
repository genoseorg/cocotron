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

packedVersionMajor="3150000"
packedVersionMinor=""
packedVersionRev=""
packedVersionPlatform="win32"
packedVersionArch="x86"
packedVersionCheck="${packedVersionMajor}:${packedVersionMinor}:${packedVersionRev}:${packedVersionPlatform}:${packedVersionArch}"
packedVersion="${packedVersionMajor}${packedVersionMinor}${packedVersionRev}${packedVersionPlatform}${packedVersionArch}"
packedProduct="sqlite"

productCrossPorting_Target_default_compiler_dir_system="${productCrossPorting_Target_default_compiler_dir_system}/${packedProduct}-${packedVersion}"

rm -Rv $productCrossPorting_downloadFolder/${packedProduct}-dll-${packedVersionPlatform}-${packedVersionArch}*

$scriptResources/downloadFilesIfNeeded.sh $productCrossPorting_downloadFolder "https://sqlite.org/2016/${packedProduct}-dll-${packedVersionPlatform}-${packedVersionArch}-${packedVersion}.zip"
# ## "http://cocotron.googlecode.com/files/sqlite-dll-win32-x86-3070600.zip"

# ## TMPDIR=$productCrossPorting_downloadFolder/install_sqlite
# ## $( echo "/tmp/"$( basename $0 | tr "." " " | awk '{print $1}' ) )


mkdir -vp $TMPDIR
rm -Rv $TMPDIR/*
mkdir -vp $TMPDIR

mkdir -p "${productCrossPorting_Target_default_compiler_dir_system}/lib"

cd $TMPDIR
    
    $scriptResources/unarchiveFiles.sh  $productCrossPorting_downloadFolder $TMPDIR  
    
    cp -vp $TMPDIR/sqlite-dll-win32-x86-${packedVersion}/sqlite3.* ${productCrossPorting_Target_default_compiler_dir_system}/bin/
    
    # ##  unzip -ovx $productCrossPorting_downloadFolder/sqlite-dll-win32-x86-${SQLITE_VERSION}.zip $TMPDIR/ || echo " ERROR ..." && send_exit $0 $LINENO 
    # ##  cp -vp $TMPDIR/sqlite3.* $productCrossPorting_Target_default_compiler_dir_system/bin/

# ## build the new binarie file like :: cp -vp $productCrossPorting_Target_default_compiler_dir_system/bin/sqlite3.dll $productCrossPorting_Target_default_compiler_dir_system/lib/libsqlite3.a

${productCrossPorting_Target_default_compiler_basedir}/bin/i386-pc-mingw32msvc-dlltool --def ${productCrossPorting_Target_default_compiler_dir_system}/bin/sqlite3.def --dllname sqlite3.dll --output-lib ${productCrossPorting_Target_default_compiler_dir_system}/lib/libsqlite3.a


