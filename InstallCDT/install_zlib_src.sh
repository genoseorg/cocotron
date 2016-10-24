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

BASEDIR=/Developer/Cocotron/1.0/$targetPlatform/$targetArchitecture
 
packedVersionMajor="1.9.2"
packedVersionMinor=""
packedVersionRev=""
packedVersionPlatform=".win32"
packedVersionArch=""
packedVersionCheck="${packedVersionMajor}:${packedVersionMinor}:${packedVersionRev}:${packedVersionPlatform}:${packedVersionArch}"
packedVersion="${packedVersionMajor}${packedVersionMinor}${packedVersionRev}${packedVersionPlatform}${packedVersionArch}"
packedProduct="zlib"

 

$scriptResources/downloadFilesIfNeeded.sh $downloadFolder -c "${packedVersionCheck}" "http://freefr.dl.sourceforge.net/project/libpng/${packedProduct}/${packedVersion}/${packedProduct}-${packVersion}.tar.bz2"

mkdir -p $BUILD
cd $BUILD
tar -xvjf $downloadFolder/${packedProduct}-${packVersion}.tar.bz2
cd ${packedProduct}-${packVersion} || send_exit $0 $LINENO

pwd 

GCC=$(echo $BASEDIR/gcc-$gccVersion/bin/*gcc)
RANLIB=$(echo $BASEDIR/gcc-$gccVersion/bin/*ranlib)
AR=$(echo $BASEDIR/gcc-$gccVersion/bin/*ar)


INSTALL_PREFIX=${productCrossPorting_Target_default_compiler_basedir}/${packedProduct}-${packVersion}/
BINARY_PATH=$INSTALL_PREFIX/bin
INCLUDE_PATH=$INSTALL_PREFIX/include
LIBRARY_PATH=$INSTALL_PREFIX/lib

make clean
make -p $BINARY_PATH
make -p $LIBRARY_PATH
make -p $INCLUDE_PATH

PATH=$COCOTRON/binutils-2.21-20111025/binutils:$PATH make -f win32/Makefile.gcc  CC=$GCC AR=$AR RANLIB=$RANLIB RCFLAGS="-I /Developer/Cocotron/1.0/PlatformInterfaces/i386-mingw32msvc/include -DGCC_WINDRES" BINARY_PATH=$BINARY_PATH INCLUDE_PATH=$INCLUDE_PATH LIBRARY_PATH=$LIBRARY_PATH SHARED_MODE=1 install

