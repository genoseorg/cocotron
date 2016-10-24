#!/bin/sh

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
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



# #### # #### # ####
# ## set a default value awise a NULL / not declared param

# #### # #### # ####
# ## set a default value awise a NULL / not declared param
DEFAULT_FUNC_PARAM=""
DEFAULT="${DEFAULT_FUNC_PARAM}"
# #### # #### # ####


SCRIPT_TTY=$( (ps ax | grep -i "install.sh" || ps ax | grep -vi "install.sh" | grep -vi "$0" | grep -i "install" | grep -i ".sh"  | grep -vi "log" || ps ax | grep $$) | awk '{ print "/dev/tty" $2 }' | uniq )

# #### # #### # ####
export HISTTIMEFORMAT="%d/%m/%y %T "
set -o history

# ########### ########### ########### ########### ########### ########### ##########
# ## http://stackoverflow.com/questions/3572030/bash-script-absolute-path-with-osx
# ########### ########### ########### ########### ########### ########### ##########
declare realpathx_return="./"
realpathx() {

OURPWD=$PWD
cd "$(dirname "$1")"
LINK=$(readlink "$(basename "$1")")
while [ "$LINK" ]; do
cd "$(dirname "$LINK")"
LINK=$(readlink "$(basename "$1")")
done
REALPATH="$PWD/$(basename "$1")"
cd "$OURPWD"
# ## echo ":::: realpathx == ${REALPATH} "
    realpathx_return=${REALPATH}

}

realpathx $0
## 
installResources=$( dirname "${realpathx_return}/"  | grep -i "Resources"  && true ||  dirname $( find $( dirname $( dirname "${realpathx_return}/" ) ) -name common_functions.sh -type f -exec  dirname {} \;    )   )
##
scriptResources=$installResources/scripts/
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########




enableLanguages="c,objc,c++,obj-c++"

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

installFolder=/Developer
productName=Cocotron
productVersion=1.0

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

# ## binutilsVersion=2.21-20111025
binutilsVersion=2.21.1
mingwRuntimeVersion=3.20
mingwAPIVersion=3.17-2
gmpVersion=4.2.3
mpfrVersion=2.3.2

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

binutilsConfigureFlags=""

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

# #################
# URLs
# #################

# ########### ##########
# ## 2016 deprecated
# ## url_Download_GPL3_v1="https://code.google.com/archive/p/cocotron-tools-gpl3/downloads/"
# ########### ##########

# ########### ##########
# ## 2016/10 new
# ## but still deprecated ...
url_Download_GPL3="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/cocotron-tools-gpl3"
# ########### ##########

productCrossPorting_Name="Cocotrom"
productCrossPorting_Version="1.0"
productCrossPorting_Folder="/Developer/${productCrossPorting_Name}/${productCrossPorting_Version}"
productCrossPorting_downloadFolder="${productCrossPorting_Folder}/Downloads"
productCrossPorting_Target_default="Windows"
productCrossPorting_Target_default_arch="i386"
productCrossPorting_Target_default_arch_wordSize="32"
productCrossPorting_Target_default_compiler="gcc"

productCrossPorting_Target_default_compiler_dir_build_platform="${productCrossPorting_Folder}/build/$productCrossPorting_Target_default/$productCrossPorting_Target_default_arch"

# ## productCrossPorting_Target_default_compiler_dir_system="${productCrossPorting_Folder}/system/i386-mingw32msvc/"
productCrossPorting_Target_default_compiler_dir_system=$( dirname `pwd` )"/system/i386-mingw32msvc/"

productCrossPorting_Target_default_compiler_version="4.3.1"
productCrossPorting_Target_default_compiler_version_Date=""

productCrossPorting_Target_default_compiler_dir_system=`pwd`/../system/i386-mingw32msvc/

productCrossPorting_Target_default_compiler_basedir="${productCrossPorting_Folder}/${productCrossPorting_Target_default}/${productCrossPorting_Target_default_arch}/${productCrossPorting_Target_default_compiler}-${productCrossPorting_Target_default_compiler_version}/"



productCrossPorting_Target_avail=("Windows" "Linux" "BSD" "Solaris" "Darwin")



# ## productCrossPorting_Target_default=""
# ## productCrossPorting_Target_default_arch=""
# ## productCrossPorting_Target_default_compiler_version=""
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

if [ ""${1-DEFAULT}"" = "" ];then
  productCrossPorting_Target_default="${productCrossPorting_Target_default}"
else
  productCrossPorting_Target_default=${1-DEFAULT}
fi
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

if [ ""${2-DEFAULT}"" = "" ];then
  productCrossPorting_Target_default_arch="${productCrossPorting_Target_default_arch}"
else
  productCrossPorting_Target_default_arch=${2-DEFAULT}
fi
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

if [ ""${3-DEFAULT}"" = "" ];then
	productCrossPorting_Target_default_compiler="${productCrossPorting_Target_default_compiler}"
else
	productCrossPorting_Target_default_compiler=${3-DEFAULT}
fi
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
 
# ## productCrossPorting_Target_default_compiler_version="4.3.1"

if [ ""${4-DEFAULT}"" = "" ];then
  productCrossPorting_Target_default_compiler_version="${productCrossPorting_Target_default_compiler_version}"
else
  productCrossPorting_Target_default_compiler_version=${4-DEFAULT}
fi
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

if [ ""${5-DEFAULT}"" = "" ];then
	if [ "$productCrossPorting_Target_default_compiler" = "gcc" ]; then
		productCrossPorting_Target_default_compiler_version=$productCrossPorting_Target_default_compiler_version
	elif [ "$productCrossPorting_Target_default_compiler" = "llvm-clang" ]; then
		productCrossPorting_Target_default_compiler_version="trunk"
	else
		/bin/echo "Unknown productCrossPorting_Target_default_compiler "$productCrossPorting_Target_default_compiler
		exit 1
	fi
else
	productCrossPorting_Target_default_compiler_version=${5-DEFAULT}
fi

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

if [ ""${6-DEFAULT}"" = "" ];then
	if [ "$productCrossPorting_Target_default_compiler" = "gcc" ]; then
        productCrossPorting_Target_default_compiler_version_Date="-02242010"
	elif [ "$productCrossPorting_Target_default_compiler" = "llvm-clang" ]; then
        productCrossPorting_Target_default_compiler_version_Date="-05042011"
	else
		/bin/echo "Unknown productCrossPorting_Target_default_compiler "$productCrossPorting_Target_default_compiler
		exit 1
	fi
else
	productCrossPorting_Target_default_compiler_version_Date="-"${6-DEFAULT}
fi

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

osVersion=${7-DEFAULT}

if [ ""$osVersion"" = "" ];then
	if [ ""$osVersion"" = "" -a ""$productCrossPorting_Target_default"" = "Solaris" ];then
		osVersion="2.10"
	elif [ ""$osVersion"" = "" -a ""$productCrossPorting_Target_default"" = "FreeBSD" ];then
		osVersion="7"
	else
		osVersion=""
	fi
else
	osVersion=$osVersion
fi

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

if [ $productCrossPorting_Target_default_arch = "x86_64" ];then
	productCrossPorting_Target_default_arch_wordSize="64"
else
	productCrossPorting_Target_default_arch_wordSize="32"
fi

packedVersionMajor=""
packedVersionMinor=""
packedVersionRev=""
packedVersionPlatform=".win32"
packedVersionArch="-X86"
packedVersionCheck="${packedVersionMajor}:${packedVersionMinor}:${packedVersionRev}:${packedVersionPlatform}:${packedVersionArch}"
packedVersion="${packedVersionMajor}${packedVersionMinor}${packedVersionRev}${packedVersionPlatform}${packedVersionArch}"
packedProduct=""

BUILD=$( echo "/tmp/"$( basename $0 | tr "." " " | awk '{print $1}' ) )
TMPDIR=$( echo "/tmp/"$( basename $0 | tr "." " " | awk '{print $1}' ) )

mkdir -p $BUILD
rm -Rv $BUILD/* 2>/dev/null
 

mkdir -p $TMPDIR
rm -Rv $TMPDIR/* 2>/dev/null
cd $TMPDIR

mkdir -p $productCrossPorting_Target_default_compiler_dir_system
mkdir -p $productCrossPorting_Target_default_compiler_dir_system/include
mkdir -p $productCrossPorting_Target_default_compiler_dir_system/bin
mkdir -p $productCrossPorting_Target_default_compiler_dir_system/lib

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

SYSTEM_HOST=`uname -s`
SYSTEM_HOST_VERSION=$( ((sw_vers -productVersion  2>/dev/null  ) ||   uname -r )   | tr "." " " | awk '{ print  $1"."$2 }'  )
SYSTEM_HOST_VERSION_NAME=$( uname -s )
# ## system type
# ## 1 : MacOS
# ## 2 : Unix / GNU / Linux
# ## 3 : Windows
SYSTEM_HOST_TYPE=1
# ########
# ########
# ## Cocotrons Default Goal : Apple Cocoa -- > > Windows
SYSTEM_TARGET_TYPE=3
# ########
# ########



# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
tty_echo() {
	/bin/echo $@ >>  $SCRIPT_TTY
}
function tty_dialog() {
/bin/echo " "
/bin/echo "########### # ########### ########### ########### ###########" >>  $SCRIPT_TTY
/bin/echo "########### # ########### ########### ########### ###########" >>  $SCRIPT_TTY
/bin/echo "# ##    $1 ::                                  " >>  $SCRIPT_TTY
/bin/echo "# ##        -- $2                                     " >>  $SCRIPT_TTY
/bin/echo "########### # ########### ########### ########### ###########" >>  $SCRIPT_TTY
/bin/echo "########### # ########### ########### ########### ###########" >>  $SCRIPT_TTY
/bin/echo " "

}

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
function lastcmd(){
	
CallStackHistory=$(history |tail -n15)

last_script_name=$(echo $CallStackHistory | tr " " "\n" | grep -i "\.sh" | tail -n1 )

last=$(echo $CallStackHistory |tail -n5 | sed 's/[0-9]* //')
# printf "##### >>>> Call Stack / last command ($last_script_name) :: []"
#echo "++++"
#	for line_last in $( echo ""$last"" | tr ";" "\n" ) ; do
#		tty_echo " >>>> "$line_last
#	done 
#echo "##### >>>> should exit <<<<"
SCRIPT_TTY_STACK=$( ( ps ax  | grep -vi "$0" | grep -i "install" | grep -i ".sh"  | grep -vi "log" || ps ax | grep $$) | awk '{ print "/dev/tty" $6 }'  )
SCRIPT_TTY_SUPER=$( basename $( echo "${SCRIPT_TTY_STACK[*]}" | tail -n1 )  )
SCRIPT_TTY_UP=$( basename $( echo "${SCRIPT_TTY_STACK[*]}" | head -n1 )  )
tyy_in=$(echo $SCRIPT_TTY | sed -e 's;/dev/tty;;g' )
    tyy_out_ps_match=$( ps ax | grep -i "$tyy_in"  | grep -i "install" | grep -i ".sh" | grep -vi 'grep' | grep -vi 'exec')
    
    tyy_out=$( echo "${tyy_out_ps_match[*]}" | awk '{ print $2 }' | uniq )
    tyy_out_ps=$( echo "${tyy_out_ps_match[*]}" | awk '{ print $1 }' | uniq )
    echo " "| tee >&2 >> $SCRIPT_TTY
    echo "#### @@@@  #### @@@@  "   | tee >&2 >> $SCRIPT_TTY
    echo "#### @@@@ Receive Quit .... from ($tyy_in:"$( basename "$0"   )") in (up:${SCRIPT_TTY_UP} from super:$SCRIPT_TTY_SUPER)  to ($tyy_out):("$( echo "${tyy_out_ps[*]}" | tr "\\n" '; ' ) ") " | tee >&2 >> $SCRIPT_TTY
    echo "#### @@@@  #### @@@@  "   | tee >&2 >> $SCRIPT_TTY
    echo " "| tee >&2 >> $SCRIPT_TTY
    echo "@@@@@@@@   @@@@@@@@   @@@@@@@@ " | tee >&2 >> $SCRIPT_TTY
    echo "@@@@@@@@  Call Stack  @@@@@@@@ " | tee >&2 >> $SCRIPT_TTY
    echo "@@@@@@@@   @@@@@@@@   @@@@@@@@ " | tee >&2 >> $SCRIPT_TTY
     echo " "| tee >&2 >> $SCRIPT_TTY
    echo " #0 - > ${SCRIPT_TTY} : ("$(whoami)")"| tee >&2 >> $SCRIPT_TTY
    num=0
    num_x=0
    for l_stack in $( echo "${SCRIPT_TTY_STACK[*]}" | uniq ) ; do
        let "num=num+1"
        let "num_x=num*2"
        v=$(printf "%-${num_x}s" "-")
        l=$(printf "%-${num_x}s" " ")
		n=$(printf "%-${num}s" " ")
        c=$(printf "%-${#num}s" " ")
        # ## echo " #${num} ${n// / }i"  | tee >&2 >> $SCRIPT_TTY
        # ## echo " ${c// / } ${l// / }L${v// /-} > > ${l_stack}" | tee >&2 >> $SCRIPT_TTY
		echo " #${num} ${l// / }L${v// /-} > > ${l_stack}" | tee >&2 >> $SCRIPT_TTY
    done

}

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

function tty_waitforpath () {

tty_awaitingpath=$1
tty_awaitingpath_since=0
tty_awaitingpath_since_too_long=300

tty_awaitingpath_valid_path=$( $( echo "$tty_awaitingpath" ) || echo false )
tty_awaitingpath_valid=$( test -x $tty_awaitingpath_valid_path && echo 1 || echo 0 )

# ########### # ############ ###########
echo "#### >>>>> Awainting for path : ${tty_awaitingpath} :: ${tty_awaitingpath_valid}"
while [  $tty_awaitingpath_valid -eq 0  ]; do
printf "." >> $SCRIPT_TTY
sleep 1

tty_awaitingpath_valid_path=$( $( echo "$tty_awaitingpath" ) || echo false )
tty_awaitingpath_valid=$( test -x $tty_awaitingpath_valid_path && echo 1 || echo 0 )
let "tty_awaitingpath_since= tty_awaitingpath_since + 1"
let "tty_awaitingpath_since_long= ((tty_awaitingpath_since %60) == 0)?0:1"


if [ $tty_awaitingpath_since_too_long -lt $tty_awaitingpath_since ]; then
/bin/echo " "
exit_witherror " Still Waiting ... Too Long, Come back when it's done "
fi

if [ $tty_awaitingpath_since_long -eq 0 ]; then

/bin/echo " Still Waiting "
fi
done

/bin/echo "******* ******* ******* ******* ******* ******* ******* ******* "
/bin/echo "******* ******* ******* ******* ******* ******* ******* ******* "

}

tty_yesyno_response=""
tty_yesyno_response_valid=0

function tty_yesyno () {


tty_yesyno_response=""
tty_yesyno_response_valid=0

# ########### # ############ ###########
while [  $tty_yesyno_response_valid -eq 0 ]; do
tty_yesyno_response_valid=0
tty_yesyno_response=""
# ###########
read -t 10 -p ">>>>>>>>> $1  ? (Y/n) Default is (Yes, timeout : 10sec) : "  tty_yesyno_response
# ###########

tty_yesyno_response=$( echo "$tty_yesyno_response" | tr "[:upper:]" "[:lower:]" )

if [ "$tty_yesyno_response" == "" ]; then
tty_yesyno_response="y"
/bin/echo " --- Using default answer ::(${tty_yesyno_response}) --- "
fi
# ###########
if [ "$tty_yesyno_response" == "y" ] || [ "$tty_yesyno_response" == "yes" ]; then
tty_yesyno_response="y"
tty_yesyno_response_valid=1
break
fi
# ###########
if [ "$tty_yesyno_response" == "n" ] || [ "$tty_yesyno_response" == "no" ]; then
tty_yesyno_response="n"
tty_yesyno_response_valid=1
break
fi

# ###########
/bin/echo "******* ******* ******* ******* ******* ******* ******* ******* "
/bin/echo "**** Please answer by (Y or n) Default is (Y) ..."
/bin/echo "******* ******* ******* ******* ******* ******* ******* ******* "

done

/bin/echo "******* ******* ******* ******* ******* ******* ******* ******* "
/bin/echo "******* ******* ******* ******* ******* ******* ******* ******* "

}

# ############# SIG Trap / EXIT



# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

exit_code="Unknow Reason"
function exit_witherror() {

tty_dialog "Trapped ERROR" "$1"

exit_code=$1
exit 1
}
function finish() {
# ## TODO, try to catch exit code ....

message_quit="Unexpectedly,"

if [ "$exit_code" == "Unknow Reason" ]; then
message_quit="Something went wrong,"
else
if [ "$exit_code" == "User interruption" ]; then
message_quit="User request,"

fi

fi
lastcmd
tty_dialog "Trapped Exit" " ${message_quit} (${exit_code})"
/bin/echo " ***** QUIT *****"
}


# ########## # ########### ########### ########### ##########
function send_exit ()
{
tyy_in=$(echo $SCRIPT_TTY | sed -e 's;/dev/tty;;g' )
tyy_out_ps_match=$( ps ax | grep -i "$tyy_in"  | grep -i "install" | grep -i ".sh" | grep -vi 'grep' | grep -vi 'exec')

tyy_out=$( echo "${tyy_out_ps_match[*]}" | awk '{ print $2 }' | uniq )
tyy_out_ps=$( echo "${tyy_out_ps_match[*]}" | awk '{ print $1 }' | uniq )
echo " "| tee >&2 >> $SCRIPT_TTY
echo "#### @@@@  #### @@@@  "   | tee >&2 >> $SCRIPT_TTY
echo "#### @@@@ Send Quit .... from ($tyy_in:"$( basename "$0"   )") in (up:${SCRIPT_TTY_UP} from super:$SCRIPT_TTY_SUPER)  to ($tyy_out):("$( echo "${tyy_out_ps[*]}" | tr "\\n" '; ' ) ") " | tee >&2 >> $SCRIPT_TTY
echo "#### @@@@  #### @@@@  "   | tee >&2 >> $SCRIPT_TTY
echo " "| tee >&2 >> $SCRIPT_TTY
echo "@@@@@@@@   @@@@@@@@   @@@@@@@@ " | tee >&2 >> $SCRIPT_TTY
echo "@@@@@@@@  Call Stack  @@@@@@@@ " | tee >&2 >> $SCRIPT_TTY
echo "@@@@@@@@   @@@@@@@@   @@@@@@@@ " | tee >&2 >> $SCRIPT_TTY
echo " "| tee >&2 >> $SCRIPT_TTY
echo " #0 - > ${SCRIPT_TTY} : ("$(whoami)")"| tee >&2 >> $SCRIPT_TTY
num=0
num_x=0
for l_stack in $( echo "${SCRIPT_TTY_STACK[*]}" | uniq ) ; do
let "num=num+1"
let "num_x=num*2"
v=$(printf "%-${num_x}s" "-")
l=$(printf "%-${num_x}s" " ")

echo " #${num} ${l// / }L${v// /-} > > ${l_stack}" | tee >&2 >> $SCRIPT_TTY
done
let "num=num+1"
let "num_x=num*2"
v=$(printf "%-${num_x}s" "-")
l=$(printf "%-${num_x}s" " ")

echo " #${num} ${l// / }L${v// /-} > > $0" | tee >&2 >> $SCRIPT_TTY
echo " "| tee >&2 >> $SCRIPT_TTY
echo "@@@@@@@@   @@@@@@@@   @@@@@@@@ " | tee >&2 >> $SCRIPT_TTY
echo "#### @@@@  #### @@@@  "   | tee >&2 >> $SCRIPT_TTY
kill -INT  $tyy_out_ps 2>/dev/null
kill -QUIT $tyy_out_ps 2>/dev/null

send_exit
}

