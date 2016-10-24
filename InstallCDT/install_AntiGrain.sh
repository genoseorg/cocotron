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

./install_FreeType.sh

packedVersionMajor="2.4"
packedVersionMinor=""
packedVersionPlatform=""
packedVersionArch=""
packedVersionCheck="${packedVersionMajor}:${packedVersionMinor}:${packedVersionPlatform}:${packedVersionArch}"
packedVersion="${packedVersionMajor}${packedVersionMinor}${packedVersionPlatform}${packedVersionArch}"

if [ ""$1"" = "" ];then
	packedVersion=${packedVersion}
else
	packedVersion=$1
fi

packedProduct="agg"
productCrossPorting_Target_default_compiler_dir_system="${productCrossPorting_Target_default_compiler_dir_system}/${packedProduct}-${packedVersion}"

echo " :::: ${productCrossPorting_Target_default_compiler_dir_system}"
send_exit
$scriptResources/downloadFilesIfNeeded.sh $productCrossPorting_downloadFolder -c "${packedVersionCheck}" "http://www.antigrain.com/agg-$packedVersion.zip"

mkdir -p $BUILD
cd $BUILD
$scriptResources/unarchiveFiles.sh  $productCrossPorting_downloadFolder $BUILD  "agg-$packedVersion"
# ## unzip -o $productCrossPorting_downloadFolder/agg-$AGG_VERSION.zip
cd agg-$packedVersion

cd src

# Create a fake Cocotron uname for the build system
cat > uname <<EOF
#!/bin/sh

source $( find $(dirname $0) -name common_functions.sh -type f -print )

echo "Cocotron"
EOF
chmod +x uname
cd ..

# Create a Makefile.in.Cocotron
cat > Makefile.in.Cocotron <<EOF
AGGLIBS= -lagg 
AGGCXXFLAGS = -O3
CXX = ${productCrossPorting_Target_default_compiler_basedir}/bin/i386-pc-mingw32msvc-g++
C = ${productCrossPorting_Target_default_compiler_basedir}/bin/i386-pc-mingw32msvc-gcc
LIB = ${productCrossPorting_Target_default_compiler_basedir}/bin/i386-pc-mingw32msvc-ar cr

.PHONY : clean
EOF

# include the local uname

PATH=.:$PATH

rm gpc/*
rm include/agg_conv_gpc.h
# The makefiles expect a .c file, so make an empty one
touch gpc/gpc.c

make

mkdir -p $productCrossPorting_Target_default_compiler_dir_system
(tar -cf - --exclude "Makefile*" include) | (cd $productCrossPorting_Target_default_compiler_dir_system;tar -xf -)
cp src/libagg.a $productCrossPorting_Target_default_compiler_dir_system
