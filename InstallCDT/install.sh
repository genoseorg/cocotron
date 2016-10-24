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
# ##
# ##    Modified 10-oct-2016 by Genose.org (Sebastien Ray. Cotillard)
# ##
# ##    Change Log :
# ##
# ##		- Loves "# ## " sequence
# ##		- Hates so much, but when it cant be, Loves "long shell sentences " when don t know alternative
# ##        - Script Cosmetics
# ##        - More Screen & Script Cosmetics ...
# ##        - Lots and Lots More Screen & Script Cosmetics ...
# ##        - Lots and Lots More GUI Friendly ...
# ##
# ##        - Separated logs in 3 parts (User Screen progress, Error log, Install log)
# ##
# ##        - Zip / Tar / GZ, platform dependant uniformisation / standardisation
# ##
# ##    - Curl and Download Improvements (see ressources/scripts/downloadIfNeeded.sh)
# ## 	- Curl based Version checker for download updates ( Http and Ftp thru http )
# ##
# ##     - Remove Deprecated :
# ##       ---- > > Google Url updates to Git
# ##       ---- > > Url updates to Git / SourceForge
# ##
# ##    - GUI Friendly (MACOS X / Linux)
# ##      ---- > > use of gnome-terminal / xterm / konsole / Terminal.app to follow script progress thru 2 more window with args : Error log, Install log
# ##
# ##    - ADDED More Pipes to Log files and Install.sh Screen's Pipe == > > ${SCRIPT_TTY}
# ##    - ADDED More Graphical Pipe and Trap Ctrl-c / Exit  and send status to ${SCRIPT_TTY}
# ##
# ##    MacOS Contributions
# ##        - Fix for Sed RE error: illegal byte sequence on Mac OS X
# ##        -- > > Sed error when compile so fix it with printenv specific 2 commands ( export LC_CTYPE=C ; export LANG=C )
# ##
# ##        - Fix Zip / Tar / GZ, sometime don't extract
# ##        ---- > >  so use MacOSX's "Archive Utility.app" instead
# ##
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

source $( find $(dirname $0) -name common_functions.sh -type f -print )

#Copyright (c) 2006 Christopher J. W. Lloyd
#
#Permission is hereby granted, free of charge, to any person obtaining a copy of this
#software and associated documentation files (the "Software"), to deal in the Software
#without restriction, including without limitation the rights to use, copy, modify,
#merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
#permit persons to whom the Software is furnished to do so, subject to the following
#conditions:
#
#The above copyright notice and this permission notice shall be included in all copies
#or substantial portions of the Software.
#
#THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED,
#INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR
#PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
#LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
#TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
#OR OTHER DEALINGS IN THE SOFTWARE.
#
# Inspired by the build-cross.sh script by Sam Lantinga, et al
# Usage: install.sh <platform> <architecture> <productCrossPorting_Target_default_compiler> <productCrossPorting_Target_default_compiler-version> <osVersion>"
# Windows i386, Linux i386, Solaris sparc


# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

if [ "${SYSTEM_HOST}" = "Darwin" ]; then
	
/bin/echo "**** On Darwin System, some compilation and binaries send error ;; we make terminal SED Bytecode error more Friendly :: export LC_CTYPE=C ; export LANG=C"
    export LC_CTYPE=C ; export LANG=C
fi

# ########
# ########

SYSTEM_HOST_IDEGUI_RECOMMENDED=""
SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_name=""
SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_use=""
SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_major=""
SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_url=""

if [ "${SYSTEM_HOST}" = "Darwin" ]; then
	
	SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_name="Xcode"
	case $SYSTEM_HOST_VERSION in
		10.11) SYSTEM_HOST_VERSION_NAME="EL_Captain" ;
		# ## Xcode 8.0 is released at the that time (20-oct-2016)
		SYSTEM_HOST_IDEGUI_RECOMMENDED=("7.2.1" "8.0")
		;;
		10.10) SYSTEM_HOST_VERSION_NAME="Yosemite";
		SYSTEM_HOST_IDEGUI_RECOMMENDED=("7.2.1" "6.4")
		;;
		10.9) SYSTEM_HOST_VERSION_NAME="Mavericks" ;
		SYSTEM_HOST_IDEGUI_RECOMMENDED=("6.4" "5.1.1")
		;;
		10.8) SYSTEM_HOST_VERSION_NAME="Moutain_Lion" ;
		SYSTEM_HOST_IDEGUI_RECOMMENDED=("5.1.1" "4.6.3")
		;;
		10.7) SYSTEM_HOST_VERSION_NAME="Lion" ;
		SYSTEM_HOST_IDEGUI_RECOMMENDED=("4.6.3")
		;;
		10.6) SYSTEM_HOST_VERSION_NAME="Snow_Leopard" ;
		SYSTEM_HOST_IDEGUI_RECOMMENDED=("3.2.6")
		;;
		10.5) SYSTEM_HOST_VERSION_NAME="Leopard" ;
		SYSTEM_HOST_IDEGUI_RECOMMENDED=("3.2.6")
		;;
		10.4) SYSTEM_HOST_VERSION_NAME="Tiger";
		SYSTEM_HOST_IDEGUI_RECOMMENDED=("2.5")
		;;
		*)  SYSTEM_HOST_VERSION_NAME="MacOSX_Unsupported" ;;
	esac
		SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_use=$(echo ${SYSTEM_HOST_IDEGUI_RECOMMENDED[0]})
		SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_major=$( echo ${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION}  | tr "." " " | awk '{ print  $1"."$2 }' )
		# ## up-to-date 20-oct-2016
		SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_url="http://adcdownload.apple.com/Developer_Tools/Xcode_${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION}/${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_name}_${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION}.dmg"
else
    echo "***** Not a MacOS Host System"
	winsubstem=$( echo "${SYSTEM_HOST}"  | grep -i "win" || echo "--NO--" )
	if [ "${winsubstem}" == "--NO--" ]; then
		echo " ##### Windows Bash user .... "
		echo " #### Should visit : https://sourceforge.net/projects/xming/ "
	fi
fi

# ##  ((sw_vers 2>/dev/null | grep -i "ProductVersion" ) ||  ( uname -r | awk '{ print  "/."$1 }' ))  | tr "." " " | awk '{ print  $2"."$3 }'

trap finish EXIT
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

function int_user() {
exit_code="User interruption"

tty_dialog "SIGINT caught :: ${exit_code}" "Installation Exit  :: press enter to quit "

exit 1
}

trap int_user SIGINT
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
/bin/echo "########### # ########### ########### ########### ###########"
/bin/echo "########### # ########### ########### ########### ###########"
/bin/echo "# ##                                                     ## #"
/bin/echo "# ##     Welcome to The Cocotron's InstallCDT script     ## #"
/bin/echo "# ##                                                     ## #"
/bin/echo "# ##     Running on ($SCRIPT_TTY):($SYSTEM_HOST : $SYSTEM_HOST_VERSION : $SYSTEM_HOST_VERSION_NAME)      ## #"
/bin/echo "# ##                                                     ## #"
/bin/echo "########### # ########### ########### ########### ###########"
/bin/echo "########### # ########### ########### ########### ###########"
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
 
# ## determining full path of this script
realpathx "$0"
realp=$realpathx_return

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

INSTALL_SCRIPT_DIR=$(dirname $realp )
INSTALL_SCRIPT_LOG=$INSTALL_SCRIPT_DIR/install_log.log
INSTALL_SCRIPT_LOG_ERR=$INSTALL_SCRIPT_DIR/install_log.err.log

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

/bin/echo "#### Installl Script : " $INSTALL_SCRIPT_DIR
cd $INSTALL_SCRIPT_DIR

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

installResources=`pwd`/Resources

if [ ! -d "$installResources" ];then
tty_dialog "Unable to locate Resources directory at "$installResources
 exit 1
fi

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

mkdir /tmp/install_$$
rm -R /tmp/install_*

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
touch $INSTALL_SCRIPT_LOG
touch $INSTALL_SCRIPT_LOG_ERR
# ## in case of previous attempt ...
/bin/echo "" >$INSTALL_SCRIPT_LOG  && echo "" >$INSTALL_SCRIPT_LOG_ERR

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
/bin/echo "******* ******* ******* ******* ******* ******* ******* ******* "
/bin/echo "******* ******* ******* ******* ******* ******* ******* ******* "
/bin/echo "    You can follow (in real time) all speechy operation thru Logs file's "
/bin/echo "-- Install verbose logs : ${INSTALL_SCRIPT_LOG}"
/bin/echo "-- Errors / Warnings logs : ${INSTALL_SCRIPT_LOG_ERR}"
/bin/echo "******* ******* ******* ******* ******* ******* ******* ******* "
/bin/echo "******* ******* ******* ******* ******* ******* ******* ******* "

/bin/echo "######## So let see if you do the do ..."


# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
InstalledSoftware_path_Mac_open=$(which open)
InstalledSoftware_path_Mac_terminal=$( ls -d /Applications/Utilities/Terminal.app 2>$SCRIPT_TTY )

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

# ## linux specific
InstalledSoftware_path_linux_xterm=$(which xterm)
InstalledSoftware_path_linux_gnome_terminal=$(which gnome-terminal)
InstalledSoftware_path_linux_konsole=$(which konsole)
InstalledSoftware_path_linux__terminal=$(which terminal)

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

InstalledSoftware_path_terminal=$(
( test -x "${InstalledSoftware_path_linux_gnome_terminal}" ) && { echo "${InstalledSoftware_path_linux_gnome_terminal} -e "; } || {
( test -x "${InstalledSoftware_path_linux_konsole}" ) && { echo "${InstalledSoftware_path_linux_konsole} -e "; } || {
( test -x "${InstalledSoftware_path_linux_terminal}" ) && { echo "${InstalledSoftware_path_linux_terminal} -e "; } || {
( test -x "${InstalledSoftware_path_Mac_terminal}" ) && { echo "${InstalledSoftware_path_Mac_open} -a ${InstalledSoftware_path_Mac_terminal}"; } || {
( test -x "${InstalledSoftware_path_linux_xterm}" ) && { echo "${InstalledSoftware_path_linux_xterm} -e "; } || {

/bin/echo "";
}
}
}
}
}

)

/bin/echo "#### Terminal :: ${InstalledSoftware_path_terminal}"

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

os_showLiveLogs=""
os_showLiveLogs_valid=0

if [ "${#InstalledSoftware_path_terminal}" -gt 5 ]; then
        
        /bin/echo "---- Would you Following installation with Live Logs ... "

        tty_yesyno " Open Logs over Terminal Window ... "
        
        os_showLiveLogs=${tty_yesyno_response}
        os_showLiveLogs_valid=${tty_yesyno_response_valid}
        # ###########

        # ########### # ############ ###########
    if [ "${os_showLiveLogs}" == "y" ]; then
        # ###########
        tty_dialog "--" " >>>> Determining if Logs are Opens or Not ..." 
        os_showLiveLogs_open=( $( ps waux | grep -i 'tail -f' | grep -i 'install_log' | awk '{ print "\  \"" $13 "\"\ "; }' ) )
        os_showLiveLogs_open_pid=( $( ps waux | grep -i 'tail -f' | grep -i 'install_log' | awk '{ print "\  " $2 "\ "; }' ) )
 

        os_showLiveLogs_open_cnt=${#os_showLiveLogs_open[@]}
        # ###########
        if [ ${os_showLiveLogs_open_cnt} -gt 0 ]; then
            /bin/echo " >>>> Skipping :: some logs stills Opens ... (${os_showLiveLogs_open[@]})"
            /bin/echo " >>>> PIDs (${os_showLiveLogs_open_pid[@]})"

        else
        # ###########
            /bin/echo " >>>> Opening Logs ..."

            # ## DARWIN Specific first
            # ## can be adapted to Linux with GNU Screen or TYY/PTS shell

            touch $INSTALL_SCRIPT_DIR/show_install_log.sh && chmod 755 $INSTALL_SCRIPT_DIR/show_install_log.sh
            /bin/echo '#!/bin/sh

source $( find $(dirname $0) -name common_functions.sh -type f -print )
' > $INSTALL_SCRIPT_DIR/show_install_log.sh
            /bin/echo "tail -f ${INSTALL_SCRIPT_LOG}" >> $INSTALL_SCRIPT_DIR/show_install_log.sh

            touch $INSTALL_SCRIPT_DIR/show_install_log_err.sh && chmod 755 $INSTALL_SCRIPT_DIR/show_install_log_err.sh
            /bin/echo '#!/bin/sh

source $( find $(dirname $0) -name common_functions.sh -type f -print )
' > $INSTALL_SCRIPT_DIR/show_install_log_err.sh
            /bin/echo "tail -f ${INSTALL_SCRIPT_LOG_ERR}" >> $INSTALL_SCRIPT_DIR/show_install_log_err.sh

            ${InstalledSoftware_path_terminal} $INSTALL_SCRIPT_DIR/show_install_log.sh &
            ${InstalledSoftware_path_terminal} $INSTALL_SCRIPT_DIR/show_install_log_err.sh &
        fi
        # ###########
    else
            /bin/echo " #### NO Assisted Live logs ..."
    fi
        # ###########
else
    /bin/echo " #### Assisted Live logs not implemented for Platform (${SYSTEM_HOST}) ..."
    os_showLiveLogs="n"
fi

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

if [ "${os_showLiveLogs}" == "-" ] || [ "${os_showLiveLogs}" == "n" ]; then

tty_dialog "LiveLogs" " You Still can follow (in real time) all speechy operation thru Logs file's "

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

/bin/echo "## Install verbose in :"
/bin/echo " "
/bin/echo "tail -f $INSTALL_SCRIPT_LOG"
/bin/echo " "
/bin/echo "******* ******* ******* ******* ******* ******* ******* ******* "
/bin/echo "## Errors and Warnings in :"
/bin/echo " "
/bin/echo "tail -f $INSTALL_SCRIPT_LOG_ERR"
/bin/echo " "
/bin/echo "******* ******* ******* ******* ******* ******* ******* ******* "

fi

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

# ## macos / linux specific

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
InstalledSoftware_path_GUI__dialog_required=0
InstalledSoftware_path_GUI__dialog_use=0

InstalledSoftware_path_GUI__x11Window_url="https://dl.bintray.com/xquartz/downloads/XQuartz-2.7.9.dmg"
# ## /opt/X11/bin/xquartz
InstalledSoftware_path_GUI__x11Window=$( which xquartz )

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

# manual Xdialog install url
InstalledSoftware_path_GUI__xdialog_url="http://xdialog.free.fr/Xdialog-2.3.1.orig.tar.gz"

InstalledSoftware_path_GUI__xdialog=$( which xdialog  )
InstalledSoftware_path_GUI__dialog=$( which dialog  )

InstalledSoftware_path_GUI_dialog=$( ( test -x "${InstalledSoftware_path_GUI__xdialog}" ) && { echo ""${InstalledSoftware_path_GUI__xdialog}; } || {
( test -x "${InstalledSoftware_path_GUI__dialog}" ) && { echo ""${InstalledSoftware_path_GUI__dialog};
} || {
	echo "No";
}
}
 )



if [ ${#InstalledSoftware_path_GUI_dialog} -lt 5 ]; then
    tty_dialog "You MUST Install Xdialog GUI to continue ..." " see recommended for ${SYSTEM_HOST_VERSION_NAME}:${SYSTEM_HOST_VERSION}  )"
	if [ ${SYSTEM_HOST_TYPE} -eq 1 ]; then
		tty_yesyno " Would you like to Install it anyway  "
			xdialog_openurl=${tty_yesyno_response}
			xdialog_openurl_valid=${tty_yesyno_response_valid}
		   # ########### # ############ ###########
	   if [ "${xdialog_openurl}" == "y" ]; then
		   /bin/echo "Open Browser with xdialog_openurl"
		   # ## sleep 3
		   # ## can't download it without AUTH, so open the URL in browser
		  # ##  tty_waitforpath "which xdialog"
		  InstalledSoftware_path_GUI__dialog_required=1
		  InstalledSoftware_path_GUI_dialog="Required"
	   else
		   tty_dialog "Xdialog GUI  not installed " "see recommended ${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_url}"
	   fi
	fi
	 else
		 
		tty_yesyno " Would you like to use Xdialog GUI for interactions  "
			xdialog_openurl=${tty_yesyno_response}
			xdialog_openurl_valid=${tty_yesyno_response_valid}
		   # ########### # ############ ###########
	   if [ "${xdialog_openurl}" == "y" ]; then
		# ## /bin/echo "Open Browser with xdialog_openurl"
		   # ## sleep 3
		   # ## can't download it without AUTH, so open the URL in browser
		  # ##  tty_waitforpath "which xdialog"
		  InstalledSoftware_path_GUI__dialog_required=0
		  InstalledSoftware_path_GUI__dialog_use=1
		else
			InstalledSoftware_path_GUI_dialog="No"
	   fi	 
		 
fi
 
/bin/echo "##### dialog :: $InstalledSoftware_path_GUI_dialog"

install_proc_script=$(  echo ""$(dirname $0)"/Resources/scripts/darwin_proc_scipt.sh" )

if [ -x "${install_proc_script}" ] && [ -f  "${install_proc_script}" ] ; then
    . $(dirname $0)/Resources/scripts/darwin_proc_scipt.sh
else
    echo " ######## Warning : incomplete Install.sh support for : ${SYSTEM_HOST} "
fi
 

# ## set eu :: Darwin problematic
set -eu

if [ $productCrossPorting_Target_default = "Windows" ];then
	if [ $productCrossPorting_Target_default_arch = "i386" ];then
		compilerTarget=i386-pc-mingw32msvc$osVersion
		compilerConfigureFlags=""
	else
		tty_echo "Unsupported architecture $productCrossPorting_Target_default_arch on $productCrossPorting_Target_default"
	exit 1
	fi
elif [ $productCrossPorting_Target_default = "Linux" ];then
	if [ $productCrossPorting_Target_default_arch = "i386" ];then
		compilerTarget=i386-ubuntu-linux$osVersion
		compilerConfigureFlags="--enable-version-specific-runtime-libs --enable-shared --enable-threads=posix --disable-checking --disable-libunwind-exceptions --with-system-zlib --enable-__cxa_atexit"
	elif [ $productCrossPorting_Target_default_arch = "arm" ];then
		compilerTarget=arm-none-linux-gnueabi$osVersion
		compilerConfigureFlags="--enable-version-specific-runtime-libs --enable-shared --enable-threads=posix --disable-checking --disable-libunwind-exceptions --with-system-zlib --enable-__cxa_atexit"
	elif [ $productCrossPorting_Target_default_arch = "ppc" ];then
   	 	compilerTarget=powerpc-unknown-linux$osVersion
    		compilerConfigureFlags="--enable-version-specific-runtime-libs --enable-shared --enable-threads=posix --disable-checking --disable-libunwind-exceptions --with-system-zlib --enable-__cxa_atexit"
	elif [ $productCrossPorting_Target_default_arch = "x86_64" ];then
		compilerTarget=x86_64-pc-linux$osVersion
		compilerConfigureFlags="--enable-version-specific-runtime-libs --enable-shared --enable-threads=posix --disable-checking --disable-libunwind-exceptions --with-system-zlib --enable-__cxa_atexit"
		binutilsConfigureFlags="--enable-64-bit-bfd"
	else
		/bin/echo "Unsupported architecture $productCrossPorting_Target_default_arch on $productCrossPorting_Target_default"
		exit 1
	fi
elif [ $productCrossPorting_Target_default = "FreeBSD" ];then
	if [ $productCrossPorting_Target_default_arch = "i386" ];then
		compilerTarget=i386-pc-freebsd$osVersion
		compilerConfigureFlags="--enable-version-specific-runtime-libs --enable-shared --enable-threads=posix --disable-checking --disable-libunwind-exceptions --with-system-zlib --enable-__cxa_atexit"
	elif [ $productCrossPorting_Target_default_arch = "x86_64" ];then
		compilerTarget=x86_64-pc-freebsd$osVersion
		compilerConfigureFlags="--enable-version-specific-runtime-libs --enable-shared --enable-threads=posix --disable-checking --disable-libunwind-exceptions --with-system-zlib --enable-__cxa_atexit"
		binutilsConfigureFlags="--enable-64-bit-bfd"
	else
		/bin/echo "Unsupported architecture $productCrossPorting_Target_default_arch on $productCrossPorting_Target_default"
		exit 1
	fi
elif [ $productCrossPorting_Target_default = "Solaris" ];then
	if [ $productCrossPorting_Target_default_arch = "sparc" ];then
		compilerTarget=sparc-sun-solaris$osVersion
		compilerConfigureFlags="--enable-version-specific-runtime-libs --enable-shared --enable-threads=posix --disable-checking --disable-libunwind-exceptions --with-system-zlib --enable-__cxa_atexit"
	else
		tty_echo "Unsupported architecture $productCrossPorting_Target_default_arch on $productCrossPorting_Target_default"
		exit 1
	 fi
elif [ $productCrossPorting_Target_default = "Darwin" ];then
	if [ $productCrossPorting_Target_default_arch = "i386" ];then
		compilerTarget=i386-unknown-darwin$osVersion
		compilerConfigureFlags="--enable-version-specific-runtime-libs --enable-shared --enable-threads=posix --disable-checking --disable-libunwind-exceptions --with-system-zlib --enable-__cxa_atexit"
	else
		tty_echo "Unsupported architecture $productCrossPorting_Target_default_arch on $productCrossPorting_Target_default"
		exit 1
	 fi

else
	tty_echo "Unsupported platform $productCrossPorting_Target_default"
	exit 1
fi

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

scriptResources="$installResources/scripts"
toolResources="$installResources/tools"

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

productCrossPorting_Folder=$installFolder/$productName/$productVersion

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

productCrossPorting_downloadFolder=$productCrossPorting_Folder/Downloads
sourceFolder=$productCrossPorting_Folder/Source
interfaceFolder=$productCrossPorting_Folder/PlatformInterfaces/$compilerTarget
buildFolder=$productCrossPorting_Folder/build/$productCrossPorting_Target_default/$productCrossPorting_Target_default_arch
resultFolder=$productCrossPorting_Folder/$productCrossPorting_Target_default/$productCrossPorting_Target_default_arch/$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version
toolFolder=$productCrossPorting_Folder/bin

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

PATH="$resultFolder/bin:$PATH"

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########


downloadCompilerIfNeeded(){
###
/bin/echo "Downloading productCrossPorting_Target_default_compiler (if needed) ..."

# ## ${url_Download_GPL3}/binutils-$binutilsVersion.tar.gz 
	$scriptResources/downloadFilesIfNeeded.sh $productCrossPorting_downloadFolder "${url_Download_GPL3}/${productCrossPorting_Target_default_compiler}-${productCrossPorting_Target_default_compiler_version}${productCrossPorting_Target_default_compiler_version_Date}.tar.bz2 \
	https://ftp.gnu.org/gnu/gmp/gmp-$gmpVersion.tar.bz2 https://ftp.gnu.org/gnu/binutils/binutils-$binutilsVersion.tar.bz2 ${url_Download_GPL3}/mpfr-$mpfrVersion.tar.bz2"
	$scriptResources/unarchiveFiles.sh $productCrossPorting_downloadFolder $sourceFolder "$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version$productCrossPorting_Target_default_compiler_version_Date binutils-$binutilsVersion gmp-$gmpVersion mpfr-$mpfrVersion"
}

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########


createWindowsInterfaceIfNeeded(){
	"$scriptResources/downloadFilesIfNeeded.sh" $productCrossPorting_downloadFolder "${url_Download_GPL3}/mingwrt-$mingwRuntimeVersion-mingw32-dev.tar.gz ${url_Download_GPL3}/w32api-$mingwAPIVersion-mingw32-dev.tar.gz"

	"$scriptResources/unarchiveFiles.sh" $productCrossPorting_downloadFolder $interfaceFolder "mingwrt-$mingwRuntimeVersion-mingw32-dev w32api-$mingwAPIVersion-mingw32-dev"
}

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########


createLinuxInterfaceIfNeeded(){
# Interface is created before script execution, see doc.s
/bin/echo "Done."
}

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########


createFreeBSDInterfaceIfNeeded(){
# Interface is created before script execution, see doc.s
tty_echo "Done."
}

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########


createSolarisInterfaceIfNeeded(){
# Interface is created before script execution, see doc.s
tty_echo "Done."
}

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

createDarwinInterfaceIfNeeded(){
# Interface is created before script execution, see doc.s
tty_echo "Done."
}

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

copyPlatformInterface(){
	if [ ! -d $interfaceFolder ];then
		exit_witherror "Interface (headers, libraries, etc.) not present at "$interfaceFolder", exiting"
		# ## exit 1
	else
		mkdir -p $resultFolder/$compilerTarget
		(cd $interfaceFolder;bsdtar -cf - *) | (cd $resultFolder/$compilerTarget;bsdtar -xf -)
	fi
}

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

configureAndInstall_binutils() {
	tty_echo "Configuring, building and installing binutils "$binutilsVersion
	rm -rf $buildFolder/binutils-$binutilsVersion
	mkdir -p $buildFolder/binutils-$binutilsVersion
	pushd $buildFolder/binutils-$binutilsVersion

	CFLAGS="-m${productCrossPorting_Target_default_arch_wordSize} -Wformat=0 -Wno-error -Wno-error=unused-value" $sourceFolder/binutils-$binutilsVersion/configure --prefix="$resultFolder" --target=$compilerTarget $binutilsConfigureFlags
	make
	make install
	popd
}

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

configureAndInstall_gmpAndMpfr() {
	tty_echo "Configuring and building and installing gmp "$gmpVersion
	rm -rf $buildFolder/gmp-$gmpVersion
	mkdir -p $buildFolder/gmp-$gmpVersion
	pushd $buildFolder/gmp-$gmpVersion

	ABI=${productCrossPorting_Target_default_arch_wordSize} $sourceFolder/gmp-$gmpVersion/configure --prefix="$resultFolder"
	make
	make install

	popd
	
    tty_echo "Configuring and building mpfr "$mpfrVersion
	rm -rf $buildFolder/mpfr-$mpfrVersion
	mkdir -p $buildFolder/mpfr-$mpfrVersion
	pushd $buildFolder/mpfr-$mpfrVersion

	$sourceFolder/mpfr-$mpfrVersion/configure --prefix="$resultFolder" --with-gmp-build=$buildFolder/gmp-$gmpVersion
	make
	make install

	popd
}

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

configureAndInstall_compiler() {
	tty_echo "Configuring, building and installing $productCrossPorting_Target_default_compiler "$productCrossPorting_Target_default_compiler_version

if [ "$productCrossPorting_Target_default_compiler" = "gcc" ]; then	
# ##  rm -rf $buildFolder/$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version
	mkdir -p $buildFolder/$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version
	pushd $buildFolder/$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version
# make clean
	CFLAGS="-m${productCrossPorting_Target_default_arch_wordSize}" $sourceFolder/$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version/configure -v --prefix="$resultFolder" --target=$compilerTarget \
		--with-gnu-as --with-gnu-ld --with-headers=$resultFolder/$compilerTarget/include \
		--without-newlib --disable-multilib --disable-libssp --disable-nls --enable-languages="$enableLanguages" \
		--with-gmp=$buildFolder/gmp-$gmpVersion --enable-decimal-float --with-mpfr=$resultFolder --enable-checking=release \
		--enable-objc-gc \
		$compilerConfigureFlags
	echo "MAKEINFO = :" >> Makefile
	make 
	make install
	popd

elif [ "$productCrossPorting_Target_default_compiler" = "llvm-clang" ]; then	
	if [ ! -e "$productCrossPorting_Folder/$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version/bin/clang" ]; then
		rm -rf $productCrossPorting_Folder/build/$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version
		mkdir -p $productCrossPorting_Folder/build/$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version
		pushd $productCrossPorting_Folder/build/$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version
make clean
		$sourceFolder/$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version/configure --enable-optimized --prefix="$productCrossPorting_Folder/$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version"
		make 
		make install
		popd
	else
		tty_echo "productCrossPorting_Target_default_compiler $productCrossPorting_Target_default_compiler already exists"
	fi
else
	tty_echo "Unknown productCrossPorting_Target_default_compiler $productCrossPorting_Target_default_compiler"
	exit 1
fi

}

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

stripBinaries() {
	tty_echo -n "Stripping binaries ..."
	for x in `find $resultFolder/bin -type f -print`
	do
		strip $x
	done
	for x in `find $resultFolder/$compilerTarget/bin/ -type f -print`
	do
		strip $x
	done
    if [ "$productCrossPorting_Target_default_compiler" = "gcc" ]; then
	    for x in `find $resultFolder/libexec/$productCrossPorting_Target_default_compiler/$compilerTarget/$productCrossPorting_Target_default_compiler_version -type f -print`
	    do
		    strip $x
	    done
	fi
	tty_echo "done."
}
	
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

	tty_yesyno " ##### >>>>>> Install productCrossPorting_Target_default_compiler section ... "
	
	install_compiler_section_response=${tty_yesyno_response}
	install_compiler_section_response_valid=${tty_yesyno_response_valid}
	
if [ ${install_compiler_section_response} == "y" ]; then 
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	tty_echo "COCOTRON  :: Platform Interface  :: May Build interface for : $productCrossPorting_Target_default"
	
	"create"$productCrossPorting_Target_default"InterfaceIfNeeded" 1>>$INSTALL_SCRIPT_LOG  2>>$INSTALL_SCRIPT_LOG_ERR
	tty_echo "COCOTRON  :: Platform Interface  :: completed"
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	tty_echo "COCOTRON  :: Download Pre-requis"
	downloadCompilerIfNeeded 1>>$INSTALL_SCRIPT_LOG  2>>$INSTALL_SCRIPT_LOG_ERR
	tty_echo "COCOTRON  :: Download Pre-requis :: completed"
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	tty_echo "COCOTRON  :: Platform Interface  :: Copying the platform interface.  This could take a while.."
	if [ $productCrossPorting_Target_default != "Darwin" ]; then
		copyPlatformInterface 1>>$INSTALL_SCRIPT_LOG  2>>$INSTALL_SCRIPT_LOG_ERR
	fi
	tty_echo "COCOTRON  :: Platform Interface  :: completed"
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	tty_echo "COCOTRON  :: Tools :: Build and install.  This could take a while.."
	
	tty_echo "COCOTRON  :: Tools  :: binutils ..."
	configureAndInstall_binutils 1>>$INSTALL_SCRIPT_LOG  2>>$INSTALL_SCRIPT_LOG_ERR
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	tty_echo "COCOTRON  :: Tools  :: gmpAndMpfr ..."
	configureAndInstall_gmpAndMpfr 1>>$INSTALL_SCRIPT_LOG  2>>$INSTALL_SCRIPT_LOG_ERR
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	tty_echo "COCOTRON  :: Tools  :: complete"
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	tty_echo "COCOTRON  :: COMPILER  :: Build and install.  This could take a while.."
	
	configureAndInstall_compiler 1>>$INSTALL_SCRIPT_LOG  2>>$INSTALL_SCRIPT_LOG_ERR
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	tty_echo "COCOTRON  :: COMPILER  :: Make strip bin ..."
	
	stripBinaries 1>>$INSTALL_SCRIPT_LOG  2>>$INSTALL_SCRIPT_LOG_ERR
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	tty_echo "COCOTRON  :: COMPILER  :: completed"
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	tty_echo "COCOTRON  :: SPECS  :: Creating specifications ..."
	
	"$scriptResources/createSpecifications.sh" $productCrossPorting_Target_default $productCrossPorting_Target_default_arch $productName $productVersion $compilerTarget "$installResources/Specifications"  $productCrossPorting_Target_default_compiler $productCrossPorting_Target_default_compiler_version
	
	tty_echo "COCOTRON  :: SPECS  :: completed"
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	
	tty_echo "COCOTRON  :: Building tools ..."
	mkdir -p $toolFolder
	cc "$toolResources/retargetBundle.m" -framework Foundation -o $toolFolder/retargetBundle
	/bin/echo "done."
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	if [ "$productCrossPorting_Target_default_compiler" = "gcc" ]; then
		(cd $resultFolder/..;ln -fs $productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version g++-$productCrossPorting_Target_default_compiler_version)
	elif [ "$productCrossPorting_Target_default_compiler" = "llvm-clang" ]; then	
		(cd $resultFolder/..;ln -fs $productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version llvm-clang++-$productCrossPorting_Target_default_compiler_version)
	else
		/bin/echo "Unknown productCrossPorting_Target_default_compiler $productCrossPorting_Target_default_compiler"
		exit 1
	fi
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	if [ "$productCrossPorting_Target_default_compiler" = "llvm-clang" ]; then
	# you need to install also gcc because -ccc-gcc-name is required for cross compiling with clang (this is required for choosing the right assembler 'as' tool. 
	# there is no flag for referencing only this tool :-(
	/bin/echo -n "Creating clang script for architecture $productCrossPorting_Target_default_arch ...in " $installFolder/$productName/$productVersion/$productCrossPorting_Target_default/$productCrossPorting_Target_default_arch/llvm-clang-$productCrossPorting_Target_default_compiler_version/bin/$compilerTarget-llvm-clang
	
	/bin/echo '#!/bin/sh

source $( find $(dirname $0) -name common_functions.sh -type f -print )
' > $installFolder/$productName/$productVersion/$productCrossPorting_Target_default/$productCrossPorting_Target_default_arch/llvm-clang-$productCrossPorting_Target_default_compiler_version/bin/$compilerTarget-llvm-clang
	
	/bin/echo "$productCrossPorting_Folder/$productCrossPorting_Target_default_compiler-$productCrossPorting_Target_default_compiler_version/bin/clang -fcocotron-runtime -ccc-host-triple $compilerTarget -ccc-gcc-name $installFolder/$productName/$productVersion/$productCrossPorting_Target_default/$productCrossPorting_Target_default_arch/gcc-$productCrossPorting_Target_default_compiler_version/bin/$compilerTarget-gcc \
	-I$installFolder/$productName/$productVersion/$productCrossPorting_Target_default/$productCrossPorting_Target_default_arch/llvm-clang-$productCrossPorting_Target_default_compiler_version/$compilerTarget/include \"\$@\"" >> $installFolder/$productName/$productVersion/$productCrossPorting_Target_default/$productCrossPorting_Target_default_arch/llvm-clang-$productCrossPorting_Target_default_compiler_version/bin/$compilerTarget-llvm-clang
	chmod +x $installFolder/$productName/$productVersion/$productCrossPorting_Target_default/$productCrossPorting_Target_default_arch/llvm-clang-$productCrossPorting_Target_default_compiler_version/bin/$compilerTarget-llvm-clang
	/bin/echo "done."
	fi
	
	# ########## # ########### ########### ########### ##########
	# ########## # ########### ########### ########### ##########
	
	/bin/echo
else
	tty_echo "#### >>>> skipping productCrossPorting_Target_default_compiler Section ...."
fi
tty_echo "COCOTRON  :: Libraries :: Install other script ..."

ls $INSTALL_SCRIPT_DIR/*_*.sh | sort

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
other_script=($(ls $INSTALL_SCRIPT_DIR/install_*.sh | sort ))
for  cur_script in  ${other_script[*]} ; do
	tty_echo ">>>> Build : ${cur_script} "
	${cur_script} 1>>$INSTALL_SCRIPT_LOG  2>>$INSTALL_SCRIPT_LOG_ERR
	history | tail -n2
	exit
done
tty_echo "COCOTRON  :: Libraries :: completed"

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

tty_echo "COCOTRON  :: Cleaning "

rm -Rv /tmp/install_*

tty_echo "COCOTRON  :: Cleaning :: completed"

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

tty_echo "COCOTRON  :: Thanks ;)"
/bin/echo -n "..."

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########


# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

# patch for mingmw

#/bin/bash
# ## export `printenv`
# gccnew=$( echo  $@ | sed -e "s;-mmacosx-version-min=10.4;;g" | sed -e "s;-mmacosx-version-min=10.11;;g" | sed -e "s;MacOSX10.11.sdk;MacOSX10.4u.sdk;g" | sed -e "s;-o ;-o;g" | sed -e "s;-Xlinker /;-Xlinker/;g" | sed -e "s;-framework ;-framework;g"  )
# ## gccnew=$( echo "$0.origin $gccnew" )
# clear
# $0.origin $gccnew
# exit $?



