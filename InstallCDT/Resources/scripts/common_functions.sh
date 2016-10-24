#!/bin/sh

# ########## # ########### ########### ########### ##########
# ##
# ##    Cocotron installer community updates
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
# ##    -- Cocotron community updates
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

tty_echo() {
	/bin/echo $@ >>  $SCRIPT_TTY
}
function tty_dialog() {
tty_echo " "
tty_echo "########### # ########### ########### ########### ###########"  
tty_echo "########### # ########### ########### ########### ###########"  
tty_echo "# ##    $1 ::                                  "  
tty_echo "# ##        -- $2                                     "  
tty_echo "########### # ########### ########### ########### ###########"  
tty_echo "########### # ########### ########### ########### ###########"  
tty_echo " "

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
    echo "#### @@@@ Receive Quit .... from ($tyy_in:"$( basename "$0"   )") in (up:${SCRIPT_TTY_UP-${DEFAULT}} from super:${SCRIPT_TTY_SUPER-${DEFAULT}})  to ($tyy_out):("$( echo "${tyy_out_ps[*]}" | tr "\\n" '; ' ) ") " | tee >&2 >> $SCRIPT_TTY
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
tty_echo " "
exit_witherror " Still Waiting ... Too Long, Come back when it's done "
fi

if [ $tty_awaitingpath_since_long -eq 0 ]; then

tty_echo " Still Waiting "
fi
done

tty_echo "******* ******* ******* ******* ******* ******* ******* ******* "
tty_echo "******* ******* ******* ******* ******* ******* ******* ******* "

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
tty_echo " --- Using default answer ::(${tty_yesyno_response}) --- "
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
tty_echo "******* ******* ******* ******* ******* ******* ******* ******* "
tty_echo "**** Please answer by (Y or n) Default is (Y) ..."
tty_echo "******* ******* ******* ******* ******* ******* ******* ******* "

done

tty_echo "******* ******* ******* ******* ******* ******* ******* ******* "
tty_echo "******* ******* ******* ******* ******* ******* ******* ******* "

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
tty_echo " ***** QUIT *****"
}


# ########## # ########### ########### ########### ##########
function send_exit ()
{
 #   echo " #### called :: "
 local SCRIPT_TTY_STACK_script=$( echo ${1-${DEFAULT}} || echo $0 )
 local SCRIPT_TTY_STACK_script_line=$( echo ${2-${DEFAULT}} || echo "--##--")
tyy_in=$(echo $SCRIPT_TTY | sed -e 's;/dev/tty;;g' )
tyy_out_ps_match=$( ps ax | grep -i "$tyy_in"  | grep -i "install" | grep -i ".sh" | grep -vi 'grep' | grep -vi 'exec')

tyy_out=$( echo "${tyy_out_ps_match[*]}" | awk '{ print $2 }' | uniq )
tyy_out_ps=$( echo "${tyy_out_ps_match[*]}" | awk '{ print $1 }' | uniq )
echo " "| tee >&2 >> $SCRIPT_TTY
echo "#### @@@@  #### @@@@  "   | tee >&2 >> $SCRIPT_TTY
echo "#### @@@@ Send Quit .... from ($tyy_in:"$( basename "$0"   )") in (up:${SCRIPT_TTY_UP-${DEFAULT}} from super:$SCRIPT_TTY_SUPER-${DEFAULT})  to ($tyy_out):("$( echo "${tyy_out_ps[*]}" | tr "\\n" '; ' ) ") " | tee >&2 >> $SCRIPT_TTY
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

echo " #${num} ${l// / }L${v// /-} > > ${SCRIPT_TTY_STACK_script} :: ${SCRIPT_TTY_STACK_script_line}" | tee >&2 >> $SCRIPT_TTY
echo " "| tee >&2 >> $SCRIPT_TTY
echo "@@@@@@@@   @@@@@@@@   @@@@@@@@ " | tee >&2 >> $SCRIPT_TTY
echo "#### @@@@  #### @@@@  "   | tee >&2 >> $SCRIPT_TTY
kill -INT  $tyy_out_ps 2>/dev/null
kill -QUIT $tyy_out_ps 2>/dev/null

 
}


source $( find $(dirname $0) -name common_declare.sh -type f -print )


# ########## # ########### ########### ########### ##########
# ########## # ########### ########### ########### ##########
