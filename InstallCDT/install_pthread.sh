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

packedVersionMajor=""
packedVersionMinor=""
packedVersionRev=""
packedVersionPlatform="win32"
packedVersionArch="X86"
packedVersionCheck="${packedVersionMajor}:${packedVersionMinor}:${packedVersionRev}:${packedVersionPlatform}:${packedVersionArch}"
packedVersion="${packedVersionMajor}${packedVersionMinor}${packedVersionRev}${packedVersionPlatform}${packedVersionArch}"
packedProduct="pthreads"


$scriptResources/downloadFilesIfNeeded.sh $TMPDIR "ftp://sourceware.org/pub/${packedProduct}-${packedVersionPlatform}/dll-latest/dll/${packedVersionArch}/pthreadGC2.dll \
ftp://sourceware.org/pub/${packedProduct}-${packedVersionPlatform}/dll-latest/lib/${packedVersionArch}/libpthreadGC2.a \
ftp://sourceware.org/pub/${packedProduct}-${packedVersionPlatform}/dll-latest/include/pthread.h \
ftp://sourceware.org/pub/${packedProduct}-${packedVersionPlatform}/dll-latest/include/sched.h \
ftp://sourceware.org/pub/${packedProduct}-${packedVersionPlatform}/dll-latest/include/semaphore.h"


cp $TMPDIR/pthreadGC2.dll  ${productCrossPorting_Target_default_compiler_dir_system}/bin || send_exit $0 $LINENO
cp $TMPDIR/libpthreadGC2.a  ${productCrossPorting_Target_default_compiler_dir_system}/lib || send_exit $0 $LINENO
cp $TMPDIR/pthread.h    ${productCrossPorting_Target_default_compiler_dir_system}/include || send_exit $0 $LINENO
cp $TMPDIR/sched.h      ${productCrossPorting_Target_default_compiler_dir_system}/include || send_exit $0 $LINENO
cp $TMPDIR/semaphore.h  ${productCrossPorting_Target_default_compiler_dir_system}/include || send_exit $0 $LINENO

