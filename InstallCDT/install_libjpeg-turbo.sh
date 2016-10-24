#!/bin/sh
installResources=`pwd`/Resources
scriptResources=$installResources/scripts

productFolder=/Developer/Cocotron/1.0
downloadFolder=$productFolder/Downloads

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

BUILD=/tmp/build_libjepgturbo

mkdir -p $PREFIX


$scriptResources/downloadFilesIfNeeded.sh $downloadFolder http://freefr.dl.sourceforge.net/project/libjpeg-turbo/1.3.0/libjpeg-turbo-1.3.0.tar.gz

mkdir -p $BUILD
cd $BUILD
tar -xvzf $downloadFolder/libjpeg-turbo-1.3.0.tar.gz
cd libjpeg-turbo-1.3.0

pwd 

GCC=$(echo $BASEDIR/gcc-$gccVersion/bin/*gcc |  tr -s " " ":" | cut -d':' -f 2 | awk "{print $1;  fflush();}")
AS=$(echo $BASEDIR/gcc-$gccVersion/bin/*as |  tr -s " " ":" | cut -d':' -f 2 | awk "{print $1;  fflush();}")
AR=$(echo $BASEDIR/gcc-$gccVersion/bin/*ar |  tr -s " " ":" | cut -d':' -f 2 | awk "{print $1;  fflush();}")
RANLIB=$(echo $BASEDIR/gcc-$gccVersion/bin/*ranlib |  tr -s " " ":" | cut -d':' -f 2 | awk "{print $1;  fflush();}")
TARGET=$($GCC -dumpmachine)
export MAKE="$(which make)"

make clean
./configure --prefix="$PREFIX"  --disable-shared --host=$TARGET --target=$TARGET  AR=$AR AS=$AS CC=$GCC RANLIB=$RANLIB --with-jpeg8

make && make install
