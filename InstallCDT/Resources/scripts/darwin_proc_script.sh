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



# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
# ## Xcode specific

InstalledSoftware_path_Mac_xcodebuild=$(which xcodebuild)
InstalledSoftware_path_Mac_xcode_select=$(which xcode-selects && echo "-p" || echo "/bin/echo ./")

InstalledSoftware_path_Mac_xcode=$( dirname $(ls -d  $( ${InstalledSoftware_path_Mac_xcode_select} 2>$SCRIPT_TTY)  2>$SCRIPT_TTY ) )
InstalledSoftware_path_Mac_xcode_version=$(

( test -x "${InstalledSoftware_path_Mac_xcode}" && test "${#InstalledSoftware_path_Mac_xcode}" -gt 5 ) && { /usr/libexec/PlistBuddy -c "Print CFBundleShortVersionString" $InstalledSoftware_path_Mac_xcode/version.plist  2>/dev/null ; } || {
/bin/echo "";
}
)

if [ ${#InstalledSoftware_path_Mac_xcode} -lt 5 ]; then
    tty_dialog "You MUST Install Apple XCode to continue ..." " see recommended for ${SYSTEM_HOST_VERSION_NAME}:${SYSTEM_HOST_VERSION} :: ${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_url}  :: (${InstalledSoftware_path_Mac_xcode})"
	if [ "${SYSTEM_HOST}" == "Darwin" ]; then
		tty_yesyno " Would you like to visit ${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_url} "
			xcode_openurl=${tty_yesyno_response}
			xcode_openurl_valid=${tty_yesyno_response_valid}
		   # ########### # ############ ###########
	   if [ "${xcode_openurl}" == "y" ]; then
		   /bin/echo "Open Browser with ${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_url}"
		   # ## sleep 3
		   # ## can't download it without AUTH, so open the URL in browser
		   # ## open "${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_url}"
		   
		   tty_waitforpath "which xcode-select"
	   else
		   tty_dialog "${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_name} not installed " "see recommended ${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_url}"
	   fi
	fi
	exit_witherror "${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_name} not installed for ${SYSTEM_HOST_VERSION_NAME}:${SYSTEM_HOST_VERSION}" 
fi

/bin/echo "#### Installed ${SYSTEM_HOST_IDEGUI_RECOMMENDED_VERSION_name} : (${InstalledSoftware_path_Mac_xcode_version}) : ${InstalledSoftware_path_Mac_xcode}"

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

if [ -w /Library/Application\ Support/Developer/Shared/Xcode/Specifications ]; then
	/bin/echo "####  >>>> Permissions properly set up, continuing install."
else
	/bin/echo "####  >>>> For this script to complete successfully, the directory /Library/Application Support/Develper/Shared/Xcode/Specifications must be writeable by you, and we've detected that it isn't.  "
	exit 1
fi

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

# ## macos specific
# ## macport url
macPortRelease=$( curl https://www.macports.org/index.php 2>/dev/null | grep -i 'release'  | grep -i 'install' | tr ":" "\n" |  grep -i "</p" | tr "<" "\n"   | grep -m 1 -E  "[[:digit:]|[:alpha:]|\.]*" )
macPortRelease=${macPortRelease//[[:blank:]]/}
 # 2016 Model
macPortRelease_MySystemReleaseShouldBe="${macPortRelease}-${SYSTEM_HOST_VERSION}-${SYSTEM_HOST_VERSION_NAME}.pkg"

macPortRelease_alt_package=$( curl https://www.macports.org/install.php 2>/dev/null | grep -i ".pkg" | tr '"' "\n" | grep -i "http" | grep -i ".pkg" | sort | uniq )
# 2016 Model
macPortRelease_URL="https://distfiles.macports.org/MacPorts/MacPorts-${macPortRelease_MySystemReleaseShouldBe}"
#but we forth, that be better to auto conclude the path
macPortRelease_avail=$( echo ${macPortRelease_alt_package[*]} | grep -i "${macPortRelease_MySystemReleaseShouldBe}" >/dev/null  && echo "Yes" || echo "No"  )

# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

InstalledSoftware_path_Mac_macport=$(which port )
InstalledSoftware_path_Mac_macport_version=$( ( test ${#InstalledSoftware_path_Mac_macport} -gt 5 ) &&
{  ${InstalledSoftware_path_Mac_macport} version | awk '{ print  $2 }' ; } || { echo "None"; } )

if [ ${#InstalledSoftware_path_Mac_macport} -gt 5 ]; then
/bin/echo
else
    InstalledSoftware_path_Mac_macport_version="No"
    InstalledSoftware_path_Mac_macport="see http://macports.org"
fi
/bin/echo "#### Installed MacPort Release .... ($InstalledSoftware_path_Mac_macport_version) : $InstalledSoftware_path_Mac_macport "


# ##########
# ##########

/bin/echo "#### Current MacPort Release .... ($macPortRelease)"

# ##########
# ##########

if [ "${macPortRelease_avail}" == "Yes" ]; then
    macPortRelease_avail="Yes"
else
    macPortRelease_avail="No"
	macPortRelease_URL="see http://macports.org "
fi


/bin/echo "#### MacPort Avail for this System .... (${macPortRelease_avail}) : ${macPortRelease_URL}"

# ##########
# ##########


if [ "${macPortRelease_avail}" == "No" ]; then
		
		tty_echo ""
		tty_echo "# ########## # ########## # ########## # ########## # ##########"
		tty_echo " #### No MacPorts for ${SYSTEM_HOST_VERSION_NAME}:${SYSTEM_HOST_VERSION}"
		tty_echo "# ########## # ########## # ########## # ########## # ##########"
		for m_port in ${macPortRelease_alt_package[*]} ; do
			tty_echo " #### >>>> MacPorts : ${m_port}"
		done
		tty_echo ""
		tty_echo "# ########## # ########## # ########## # ########## # ########## # ##########"
		
	else
		if [ "${InstalledSoftware_path_Mac_macport_version}" == "No" ]; then
			tty_yesyno " Would you like to visit ${macPortRelease_URL} "
				macport_openurl=${tty_yesyno_response}
				macport_openurl_valid=${tty_yesyno_response_valid}
			   # ########### # ############ ###########
		   if [ "${macport_openurl}" == "y" ]; then
			   /bin/echo "Open Browser with ${macPortRelease_URL}"
			   sleep 3
			   # ## can't really download it without some AUTH, so open the URL in browser
			   open "${macPortRelease_URL}"
			   
			   
		   else
			   exit_witherror "MacPort not installed (${macport_openurl})" "see recommended ${macPortRelease_URL}"
		   fi
			# ## exit_witherror "MacPort not installed for ${SYSTEM_HOST_VERSION_NAME}:${SYSTEM_HOST_VERSION}"
		else
			echo " NO need to fetch Macports ${InstalledSoftware_path_Mac_macport_version}"
		fi
fi
# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########

if [ $InstalledSoftware_path_GUI__dialog_required -eq 1 ]; then
	/bin/echo " >>>>>> Alternatively you required Xdialog Gui ... Please install this software "
	 
	if [ "${#InstalledSoftware_path_GUI__x11Window}" -lt 5]; then
		sleep 3
		# ## can't really download it without some AUTH, so open the URL in browser
		/bin/echo " >>>>>> Please install this software X11 :  ${InstalledSoftware_path_GUI__x11Window_url} "
		open "${InstalledSoftware_path_GUI__x11Window_url}"
		
		tty_waitforpath "which xquartz"
	fi
	if [ "${#InstalledSoftware_path_GUI__xdialog}" -lt 5]; then
		sleep 3
		/bin/echo " >>>>>> Please install this software Xdialog :  ${InstalledSoftware_path_GUI__xdialog_url} "
		tty_yesyno " Would you like use MacPort to install Xdialog "
		use_macport_install=${tty_yesyno_response}
		use_macport_install_valid=${tty_yesyno_response_valid}
		  # ########### # ############ ###########
		if [ "${use_macport_install}" == "y" ]; then
		   
		   tty_waitforpath "which port"
		   InstalledSoftware_path_Mac_macport=$(which port)
		   
			/bin/echo ">>>> If MacPort cant install Xdialog .... assume to do it manualy with dependencies: ( ${InstalledSoftware_path_GUI__xdialog_url} ) "
		  
		  
			if [ $(whoami) == "root" ]; then
				/bin/echo ">>>> call MacPort .... : ( you are root !! ) "
				
				$( /bin/echo "${InstalledSoftware_path_Mac_macport}  info xdialog ") | grep -i "Dependencies"
				
				$( /bin/echo "${InstalledSoftware_path_Mac_macport}  install xdialog ")
				echo " ::: (" $? ")"
			else
				/bin/echo ">>>> use command : (assuming you are sudo / or root) "
				/bin/echo $InstalledSoftware_path_Mac_macport " install xdialog "
			fi
			
			tty_waitforpath "which xdialog"
			sleep 3
		  
# ## can't really download it without some AUTH, so open the URL in browser
		else
			sleep 3
		   open "${InstalledSoftware_path_GUI__xdialog_url}"
	   fi
   fi
	 exit_witherror "##### Re-run $0  once you ready to  begin installation ..."
fi
