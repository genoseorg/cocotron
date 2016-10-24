#!/bin/bash
 
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

if [ ""$1"" = "" ];then
  targetPlatform="Windows"
else
  targetPlatform=$1
fi

if [ ""$2"" = "" ];then
  targetArchitecture="i386"
else
  targetArchitecture=$2
fi

if [ ""$3"" = "" ];then
  gccVersion="4.3.1"
else
  gccVersion=$3
fi

BASEDIR=/Developer/Cocotron/1.0/$targetPlatform/$targetArchitecture
PREFIX=`pwd`/../system/i386-mingw32msvc/libjpeg

BUILD=/tmp/build_libjepg

mkdir -p $PREFIX

$scriptResources/downloadFilesIfNeeded.sh $downloadFolder http://www.ijg.org/files/jpegsrc.v8c.tar.gz

mkdir -p $BUILD
cd $BUILD
tar -xzf $downloadFolder/jpegsrc.v8c.tar.gz
cd jpeg-8c
make clean

pwd 

GCC=$(echo $BASEDIR/gcc-$gccVersion/bin/*gcc |  tr -s " " ":" | cut -d':' -f 2 | awk "{print $1;  fflush();}" )
RANLIB=$(echo $BASEDIR/gcc-$gccVersion/bin/*ranlib |  tr -s " " ":" | cut -d':' -f 2 | awk "{print $1;  fflush();}" )
TARGET=$($GCC -dumpmachine)
echo "***************************************** *"
echo "***************************************** *"
echo "Configure with  :: "
echo " --prefix=$PREFIX "
echo " --disable-shared "
echo " --host=$TARGET "
echo " --target=$TARGET "
echo " CC=$GCC "
echo " RANLIB=" $RANLIB
echo "***************************************** *"
echo "***************************************** *"

./configure --prefix="$PREFIX" --disable-shared -host=$TARGET -target=$TARGET CC=$GCC RANLIB=$RANLIB

tty_echo "Install ${COCOTRON} on TARGET : ${TARGET} ::  ${AS} ::  ${AR} :: ${RANLIB}"

make && make install

