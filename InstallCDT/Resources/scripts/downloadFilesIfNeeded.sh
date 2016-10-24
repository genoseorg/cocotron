#/bin/sh
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



productCrossPorting_downloadFolder=$1
declare -a listOfFiles

# ## $( echo "/tmp/"$( basename $0 | tr "." "\ " | awk '{print $1}' ) )
# ## tldp.org/HOWTO/Bash-Prompt-HOWTO/x721.html
SCRIPT_TTY=$( (ps ax | grep -i "install.sh" || ps ax | grep -vi "install.sh" | grep -vi "$0" | grep -i "install" | grep -i ".sh"  | grep -vi "log" || ps ax | grep $$) | awk '{ print "/dev/tty" $2 }' | uniq )
SCRIPT_TTY_STACK=$( ( ps ax  | grep -vi "$0" | grep -i "install" | grep -i ".sh"  | grep -vi "log" || ps ax | grep $$) | awk '{ print "/dev/tty" $6 }'  )
SCRIPT_TTY_SUPER=$( basename $( echo "${SCRIPT_TTY_STACK[*]}" | tail -n1 )  )
SCRIPT_TTY_UP=$( basename $( echo "${SCRIPT_TTY_STACK[*]}" | head -n1 )  )
mkdir -p $productCrossPorting_downloadFolder

VERSION_FILE=""
 source $(dirname $0)/common_functions.sh
# ########## # ########### ########### ########### ##########

listOfFiles_valid=1
listOfFiles_valid_httpcode=0

# ########## # ########### ########### ########### ##########
 
function doCheckHTTPFile ()
{
    # ## reset value
    listOfFiles_valid=1
    
    local listOfFiles_local=( $* )
    # ## echo "######## Got Check HTTP :: "$listOfFiles_local
    for locationOfFile in $listOfFiles_local
    do
        local nameOfFile=`basename $locationOfFile`
        
         echo "${locationOfFile}" | grep -i "google"  &&  echo "#### Warning :: Google Hosting May Fails ... ($locationOfFile)" || echo "#### Checking HTTP : ${nameOfFile}" | tee >&2 >> $SCRIPT_TTY
        listOfFiles_valid_httpcode=$(curl -A "Mozilla/4.0" --write-out %{http_code} --silent --output /tmp/curl_test --cookie xurl_cookie --location $locationOfFile || echo 0 )
        let ' listOfFiles_valid_httpcode = listOfFiles_valid_httpcode+0'
    
        # ########## # ##########
        # ########## # ##########
        
        if [   ${listOfFiles_valid_httpcode} -lt 100 ] ; then
            listOfFiles_valid=0
            /bin/echo "###### >>>> SERVER ERROR :: Http Status (${listOfFiles_valid_httpcode}) "$locationOfFile" ..." | tee >&2 >> $SCRIPT_TTY
        elif  [   ${listOfFiles_valid_httpcode} -eq 404 ] || [   ${listOfFiles_valid_httpcode} -lt 200 ] ; then
            listOfFiles_valid=0
            /bin/echo "###### >>>> ERROR :: Http Status (${listOfFiles_valid_httpcode}) "$locationOfFile" ..." | tee >&2 >> $SCRIPT_TTY
        elif [   ${listOfFiles_valid_httpcode} -eq 307 ] || [   ${listOfFiles_valid_httpcode} -lt 200 ] ; then
            listOfFiles_valid=(2)
            /bin/echo "###### >>>> ERROR :: Moved :: But we should be able to follow that Link :: Http Status (${listOfFiles_valid_httpcode}) "$locationOfFile" ..." | tee >&2 >> $SCRIPT_TTY
            cat /tmp/curl_test
        elif  [   ${listOfFiles_valid_httpcode} -gt 500 ];then
            listOfFiles_valid=(0)
            /bin/echo "###### >>>> ERROR 500 :: Http Status (${listOfFiles_valid_httpcode}) "$locationOfFile" ..." | tee >&2 >> $SCRIPT_TTY
        else
            /bin/echo "###### >>>> Http Status (${listOfFiles_valid_httpcode}) "$locationOfFile" ..." | tee >&2 >> $SCRIPT_TTY
        fi
        # ## don't DDOS / Spam the server
        sleep 1
    
    done

    
}
checkVersion_file_valid="**"
function doCheckVersion ()
{
    
     # ##  listOfFiles=( $( echo ${listOfFiles[*]} | tr ' ' "\n" ) )
    curl_text="" 
    checkVersion_local="$1"
      echo "------ version start :: "${checkVersion_local}
    checkVersion_file_valid="--"
    
    checkVersion_Major=$( echo "$checkVersion_local" | tr ":" "\ " | tr "-" "\ " | awk '{ print $1 }')
        
    # # ver like 1.2.3 to parts 1 2 3
    checkVersion_Major_Prior=$( echo "$checkVersion_local" | tr ":" "\ " | tr "-" "\ " | awk '{ print $1 }' | tr "." "\ " | awk '{ print $1 }' )
    checkVersion_Major_Prior_sec=$( echo "$checkVersion_local" | tr ":" "\ " | tr "-" "\ " | awk '{ print $1 }' | tr "." "\ " | awk '{ print $2 }' )
    checkVersion_Major_Prior_sec_rev=$( echo "$checkVersion_local" | tr ":" "\ " | tr "-" "\ " | awk '{ print $1 }' | tr "." "\ " | awk '{ print $3 }' )
    
    
    checkVersion_MinorArch=$( echo "$checkVersion_local" | tr ":" "\ " | tr "-" "\ " | awk '{ print $2 }'  )
    
    checkVersion_local=$( echo "$checkVersion_local" | sed -e "s;:;;g")
    
    urlHosting_local="$2"
    urlHosting=$( dirname "${urlHosting_local}" )
    urlHosting_origin=${urlHosting}
    urlHosting_file=$( basename "${urlHosting_local}" | sed  -e "s;xxx;${checkVersion_local};g"  )
    
    urlHosting_file_base=$(  basename "${urlHosting_local}" | tr "xxx" "\ " | tr "-" "\ " | awk '{ print $1 }')
    
        # ########## # ##########
        # ########## # ##########
     urlHosting_origin="${urlHosting}/${urlHosting_file}"
     checkVersion_file_valid="${urlHosting}/${urlHosting_file}"
    echo ""
    doCheckHTTPFile "${urlHosting}/${urlHosting_file}"
    
        # ########## # ##########
        # ########## # ##########
        
    echo "# ########## # ########## # ########## # ########## # ##########"
     if [ $listOfFiles_valid -eq 0 ]; then
         echo ""
 
	echo "# ########## # ########## # ########## # ########## # ##########"
         echo "#### Error : can t check version for : ${urlHosting_file}"
         echo ""
 
	echo "# ########## # ########## # ########## # ########## # ##########"
         
     else
       
        # ########## # ##########
        # ########## # ##########
                                                                                                                                         # ## | tr " " "\\n " | tail -n1
       
        # ########## # ##########
        # ########## # ##########
        
        if [ $listOfFiles_valid -eq 2 ]; then
            echo "# ########## # ########## # ########## # ########## # ##########"
            echo "# ########## # ########## # ########## # ########## # ##########"
            echo "# ########## # ########## # ########## # ########## # ##########"
            echo "# ########## # ########## # ########## # ########## # ##########"
            echo " #### >>>> Something Moved .... !!! Please Report This !!!!"
            echo " #### >>>> Something Moved .... !!! Please Report This !!!!"
            echo " #### >>>> Something Moved .... !!! Please Report This !!!!"
            echo " #### >>>> Something Moved .... !!! Please Report This !!!!"
            echo "# ########## # ########## # ########## # ########## # ##########"
            echo "# ########## # ########## # ########## # ########## # ##########"
            echo "# ########## # ########## # ########## # ########## # ##########"
            echo "# ########## # ########## # ########## # ########## # ##########"
              urlHosting=$( curl -A "Mozilla/4.0"   "${urlHosting}/"  2>/dev/null | grep -i "${urlHosting_file_base}" | tr '"' "\n" | grep -i "http://" | grep -i "${urlHosting_file_base}" | uniq | head -n1 )
        else
                   #check sourceforge
            doCheckHTTPFile "${urlHosting}/files/" >/dev/null
            process_ass_sfnet=$listOfFiles_valid
            if [ ${process_ass_sfnet} -eq 1 ]; then
                 urlHosting="${urlHosting}/files/"
               else
                 echo "...."
            fi
           # ##  curl_text=$( curl -A "Mozilla/4.0" --cookie nada --location "${urlHosting}"  2>/dev/null | grep -i "${urlHosting_file_base}"  )
            # ## | tr " " "\\n " | tail -n1
           
        fi
        # ########## # ##########
        # ########## # ##########
        echo "# ########## # ########## # ########## # ########## # ##########"
        echo "## >>>>> Check newer version than (${checkVersion_Major})  arch/release (${checkVersion_MinorArch}) for file :: ${urlHosting_file}"
        echo "## >>>>> Hosted on : "  $urlHosting
        echo ""
	echo "# ########## # ########## # ########## # ########## # ##########"
         # ## curl -A "Mozilla/4.0" "${urlHosting}/" >/tmp/curl_test.txt 2>/dev/null
         curl -A "Mozilla/4.0" --cookie nada --location "${urlHosting}" >/tmp/curl_test.txt  2>/dev/null | grep -i "${urlHosting_file_base}" 
        #  >/tmp/curl_test.txt
        
        # ########## # ##########
        # ########## # ##########
        
        detect_cookie_js=$(  (cat /tmp/curl_test.txt | grep -i "href=" || cat /tmp/curl_test.txt  ) | tr ';' "\n"  | grep -i 'cookie' >/dev/null && echo "Yes" || echo "No" )
         
        # ########## # ##########
        # ########## # ##########
        
         echo " got cookie :: (${detect_cookie_js}) "
         echo "" > /tmp/curl_test.txt 
        if [ "${#detect_cookie_js}" -gt 5 ]; then
            # ## echo "FreedomCookie=true;"> /tmp/xurl_cookie.txt
            # ## echo "path=/;" >> /tmp/xurl_cookie.txt
            # ## echo "expires="$( date -v+1d )';' >> /tmp/xurl_cookie.txt
            # ##
            echo ".... back with a cookie ...."
            curl --cookie xurl_cookie --location "${urlHosting}/" >/tmp/curl_test.txt  2>/dev/null 
            detect_cookie_js=1 
        else
             curl -A "Mozilla/4.0" "${urlHosting}/" >/tmp/curl_test.txt 2>/dev/null
        fi
        
        # ########## # ##########
        # ########## # ##########
        
         curl_text=$( cat /tmp/curl_test.txt | tr '; ' ";\\n" | tr "\>\<" "\>\n\<" | grep -i "href=" | grep -i "${urlHosting_file_base}"   || cat /tmp/curl_test.txt | tr ';' ";\\n" | tr "\>\<" "\>\n\<" | grep -i "${urlHosting_file_base}" || echo "Frak format" )
                  echo "@@@@ curl_text:: ${curl_text}"
         
         send_exit
         # ## | grep -i "${urlHosting_file_base}"
         sfnet_listing=$( echo $curl_text | tr ' ' "\n" | tr '"' "\n" | grep -i "${urlHosting_file_base}\/files" || echo $curl_text | tr ' ' "\n" | tr '"' "\n" | grep -i "\/files\/${urlHosting_file_base}" || echo "--No--" )
         echo $curl_text | tr ' ' "\n" | tr '"' "\n" | grep -i "\/files\/${urlHosting_file_base}"
         # ##
         echo "@@@@ sfnet_listing:: ${sfnet_listing}"
         
         sfnet_listing_sub=$( echo $curl_text | tr ' ' "\n" | tr '"' "\n" | grep -i "${urlHosting_file_base}\/files\/" &&  true  || echo $curl_text | tr ' ' "\n" | tr '"' "\n" | grep -i "files\/${urlHosting_file_base}\/" &&  true || echo "--No--" )
                    # ## echo "sfnet_listing_sub:: ${sfnet_listing_sub}"
                    # ## echo " origin " ${urlHosting_origin} ":: new :: "${sfnet_listing_sub}
                    
        if [  "${sfnet_listing}" == "--No--" ]; then
            echo " nope "
        else
            sfnet_listing_sub=$( echo $sfnet_listing_sub"?source=navbar"  | tr ' ' "\n" | head -n1 && true  || echo $sfnet_listing_sub )
            # ## sfnet_listing_sub=$(  echo "$sfnet_listing_sub/${urlHosting_file_base}/"} | sed -e "s;://;####;g" | sed -e "s;//;/;g" | sed -e "s;####;://;g" )
            # ##
            
            urlHosting=${sfnet_listing_sub}
            
            curl --cookie xurl_cookie --location "${urlHosting}" >/tmp/curl_test.txt  2>/dev/null
            sfnet_listing_sub=$( cat /tmp/curl_test.txt | tr '; ' ";\\n" | tr "\>\<" "\>\n\<" | grep -i "href=" | tr '"' "\\n" | grep -vi "stats" | grep -vi "component"  | grep -i "${urlHosting_file_base}\/files\/${urlHosting_file_base}" | head -n1 || echo "Frakin format" )
            urlHosting=$( echo ${urlHosting} | sed -e "s;/projects/${urlHosting_file_base}/files/;${sfnet_listing_sub};g" )
            # ##
            echo " origin " ${urlHosting_origin} ":: new :: "${sfnet_listing_sub}
        fi
        
        # ########## # ##########
        # ########## # ##########
         

                if [  "${sfnet_listing}" == "--No--" ]; then
                    echo ">>>>>> ##### Unknow listing type ######## <<<<<<< "
                    
                    doCheckHTTPFile "${urlHosting}/download/"
                    # ## echo " Http says : ${listOfFiles_valid_httpcode} "
                    if [ ${listOfFiles_valid} -gt 0 ]; then
                        
                        echo "###### Website unknow ... let's try to find out ... !!"
                        
                        urlHosting="${urlHosting}/download/"
                        echo " follow up : ${urlHosting}" 
                        curl --cookie xurl_cookie --location "${urlHosting}" >/tmp/curl_test.txt  2>/dev/null
                        
                       curl_text=$( cat /tmp/curl_test.txt | tr '; ' ";\\n" | tr "\>\<" "\>\n\<" | grep -i "href=" | tr '"' "\\n" | tr '>' "\\n" | tr '<' "\\n" | grep -i "urlHosting_file_base" | sort | uniq || echo "Frakin format" )
                       
                       
                       version_avail=(${curl_text[@]})
                       # ##echo "versions .... ${version_avail}"
                    fi
                    
                else
                    echo " >>>>> youhou :: Sf.net like ...."
                    # echo "listings :: "${sfnet_listing}
                    curl_text="Sf.net like"
                     if [  "${sfnet_listing_sub}" == "--No--" ]; then
                         echo "############### >>>>>>>>>>>>>>>> Nope all"
                         echo " ::::: ${listOfFiles_valid_httpcode} ;;; ${sfnet_listing_sub}"
                        send_exit 1 
                     else 
                       #echo "Frak that s SF.net like " ${sfnet_listing_sub[@]}
                        
                       # ## $( echo $urlHosting | sed -e "s;/projects/${urlHosting_file_base}\/files\/;${sfnet_listing_sub};g" )
                       # ## echo " origin " ${urlHosting_origin} ":: new :: "${sfnet_listing_sub}
                       # # #cat /tmp/mind_lift.txt
                        
                        checkVersion_file_valid=$(echo $urlHosting_origin} | tr ' ' "\\n" | sed -e "s;/${urlHosting_file_base}/${urlHosting_file};${sfnet_listing_sub}/${checkVersion_Major}/${urlHosting_file};g"  )
                        # ## fraking bash 3.2
                        cat /tmp/mind_lift.txt | tr ' ' "\\n" | sed -e "s;/${urlHosting_file_base}/${urlHosting_file};${sfnet_listing_sub}/${checkVersion_Major}/${urlHosting_file};g"  > /tmp/mind_lift_out.txt
                        cat /tmp/mind_lift_out.txt  > /tmp/mind_lift.txt
                        
                        checkVersion_file_valid=$( cat /tmp/mind_lift.txt | tail -n1  )
                    
                    # ##send_exit
                        echo " follow up : ${urlHosting}" 
                        curl --cookie xurl_cookie --location "${urlHosting}" >/tmp/curl_test.txt  2>/dev/null
                        
                       curl_text=$( cat /tmp/curl_test.txt | tr '; ' ";\\n" | tr "\>\<" "\>\n\<" | grep -i "href=" | tr '"' "\\n" | grep -vi "stats" | grep -i "${urlHosting_file_base}\/files" || echo "Frakin format" )
                       
                       version_avail=(${curl_text[@]})
                   fi
                fi
                                             # ## | tr " " "\\n " | tail -n1
        
       
        version_avail=( $( cat /tmp/curl_test.txt | tr '; ' ";\\n" | tr "\>\<" "\>\n\<" | grep -i "href=" | tr '"' "\\n" | grep -vi "stats" | grep -i "${urlHosting_file_base}\/files"   || cat /tmp/curl_test.txt | tr ' ' "\\n" | grep -i "${checkVersion_MinorArch}"  | grep -i "${urlHosting_file_base}"   || cat /tmp/curl_test.txt | tr ' ' "\\n" | grep -i "${checkVersion_MinorArch}"    || echo "ERROR" )  )
        
        version_avail=( $( echo ${version_avail[@]} | tr ' ' "\\n" | sort | uniq ) )
        
        version_avail=( $( echo ${version_avail[@]} | tr ' ' "\\n"  | grep -i "${checkVersion_Major_Prior}.${checkVersion_Major_Prior_sec}" && echo ${version_avail[@]} | grep -i "${checkVersion_Major_Prior}"   || echo ${version_avail[@]} | sort | uniq || echo "Frak" ))
        version_avail=( $( echo ${version_avail[@]} | tr ' ' "\\n"  | sort | uniq ))
        
        version_avail_branch=( $( echo ${version_avail[@]} | tr ' ' "\\n" |  sed -e "s;${sfnet_listing_sub};;g" | tr ' ' "\\n" | tr '-' "\\n" | grep -vi "${urlHosting_file_base}" | grep -vi "documentation" | sort | uniq  | tr "/" "\ " | tr "." "\ " | awk '{ print $1"."$2 }'  || echo "Unknow Branch format ....") )
 
        version_avail_branch=( $( echo ${version_avail_branch[@]} | tr ' ' "\\n" | sort | uniq ) )
 
        version_avail_c=${version_avail[*]}
        version_avail=(" ")
        # ## echo "..... particularity ...."
        # ## echo ${version_avail_c[*]} | tr '(' "\ " | tr ')' "\ "| tr '"' "\ " | tr '>' "\ " | tr '<' "\ "  | tr ' ' "\\n"  | grep -i "${urlHosting_file_base}" | sort | grep -i "${m_port_branchs}" | uniq 
        # ## extrem particularity .... Website and so on ...
        for m_port_branchs in ${version_avail_branch[*]} ; do
            version_avail=( $( echo ${version_avail_c[*]} | tr '(' "\ " | tr ')' "\ "| tr '"' "\ " | tr '>' "\ " | tr '<' "\ "  | tr ' ' "\\n"  | grep -i "${urlHosting_file_base}" | sort | grep -i "${m_port_branchs}" | uniq  &&  echo " "${version_avail[*]} | tr ' ' "\\n") )
            # ## echo ".....  ***** step ....(${version_avail[*]})"
        done
         # ## echo ".....  ***** particularity ....(${version_avail[*]})"
        
        
        echo " All Versions says for (${urlHosting_file_base}):: ("${#version_avail[@]}")"
        echo " All Branch for (${urlHosting_file_base}):: ("${#version_avail_branch[@]}") : ("${version_avail_branch[@]}")"
        aff_checkVersion_MinorArch="[xxx-noarch-xxx]"
        if [ "${#checkVersion_MinorArch}" -lt 1 ]; then
                aff_checkVersion_MinorArch="${aff_checkVersion_MinorArch} -- >> ${checkVersion_Major}"
            else
                whicharch=$(echo "${checkVersion_MinorArch}" | grep -i "win32" || echo "${checkVersion_MinorArch}" | grep -i "win" || echo "${checkVersion_MinorArch}" | grep -i "darwin" || echo "${checkVersion_MinorArch}" | grep -i "mac" || echo "${checkVersion_MinorArch}" | grep -i "arch" || echo "[xxx-noarch-xxx]" )
                aff_checkVersion_MinorArch="[${whicharch}] ${checkVersion_MinorArch} : [Release] ${checkVersion_Major_Prior}.${checkVersion_Major_Prior_sec} :: rev ${checkVersion_Major_Prior_sec_rev}"
        fi
        
         echo  "----"${version_avail_branch[*]} | grep -vi "${checkVersion_Major_Prior}.${checkVersion_Major_Prior_sec}"
         
        echo ""
	echo "# ########## # ########## # ########## # ########## # ##########"
        echo " Avaible Version of :: (${urlHosting_file_base}) for arch/release (${aff_checkVersion_MinorArch}) "
	echo "# ########## # ########## # ########## # ########## # ##########"
        echo ""
        for m_port_branchs in ${version_avail_branch[*]} ; do
            echo "# ########## # ########## # ########## # ########## # ##########"
            echo "####          Release Branch :: ${m_port_branchs} <<<<<<<< #####"
            m_port_branchs_release=( $( echo ${version_avail[*]} | tr ' ' "\\n" | grep -i "${m_port_branchs}\.") )
            
            for m_port in  ${m_port_branchs_release[*]} ; do
                    echo " #### ++++++ Version : ${m_port}"
            done
        done
        echo ""
	echo "# ########## # ########## # ########## # ########## # ##########"
        echo ""

    fi
      
}

echo "" > /tmp/mind_lift.txt
shift # past downloaddir argument
numberOfArgument=$#
 
while [[ 0 -lt $# ]]
do
key="$1"
 
shift
case $key in
 
    -c|--check)
        # ## should be : -c "http" or "http" -c
       # ## however problematic : "http" -c "http" ;; nope
       # ## however problematic : "http" -c "http" "http" ;; nope
        key="$1"
        # ## version can contain full version X.X.X or version platform X.X.X-Cpu64;; in that case Minor and Major MUST be separated by ":" or "-"
        checkVersion="${key}"
        shift
        if [ ${#checkUrl} -gt 5 ]; then 
             echo $checkUrl >> /tmp/mind_lift.txt
            checkUrl=""
        fi
    ;;
    *)
            # unknown option
            unknowOpt=$( echo $key | grep -i "http:" || echo $key | grep -i "https:" || echo $key | grep -i "http:" || echo $key | grep -i "ftp:" )
            if [ ${#unknowOpt} -lt 5 ]; then
                echo "Unknow option or protocol :: ($key) "
                echo ".... abort .... "
               send_exit 1
            fi
            # ## from previous pass 
            if [ ${#checkUrl} -gt 5 ]; then
                echo $checkUrl >> /tmp/mind_lift.txt
                checkUrl=""
            fi
            
            checkUrl="${unknowOpt}"
            # ## pass to next arg
            #if [ ${#checkVersion} -lt 1 ] && [ $# -gt 1 ] ; then
            #    echo " ... continue"
            #    continue
            #fi
            # checkUrl=""
            # checkVersion=""
            unknowOpt=""
    ;;
esac
 
 # ########
  
    if [ ${#checkVersion} -gt 1 ] && [ ${#checkUrl} -gt 5 ] ; then
        
        checkVersionMajor=$( echo "${checkVersion}" | tr ":" "\ " | tr "-" "\ " | awk '{ print $1 }')
        checkVersionMinor=$( echo "${checkVersion}" | tr ":" "\ " | tr "-" "\ " | awk '{ print $2 }')
        checkVersion=$( echo "${checkVersion}" | sed  -e "s;:;;g" )
        checkUrl=$( echo "${checkUrl}" | sed  -e "s;${checkVersion};xxx;g" )
        # ## echo "Get url :: "$checkUrl
         echo $checkUrl >> /tmp/mind_lift.txt
         
        
        doCheckVersion "${checkVersionMajor}:${checkVersionMinor}" "${checkUrl}"  
        # ## use only ":" for rebuild version number

        cat /tmp/mind_lift.txt | tr ' ' "\\n"  | sed -e "s;$checkUrl;${checkVersion_file_valid};g" > /tmp/mind_lift_out.txt
        cat /tmp/mind_lift_out.txt > /tmp/mind_lift.txt
        checkUrl=$checkVersion_file_valid
        # ## echo "Received :: "$checkUrl
       
       
         # ##  so we transform url and save it
        # checkUrl=$( echo "${checkUrl}" | sed  -e "s;xxx;${checkVersion};g" ) 
         # echo $checkUrl >> /tmp/mind_lift.txt
        
 # ## echo "********"${listOfFiles[*]}
        checkUrl=""
        checkVersion=""
    fi
    
 # ########

    if [ ${#checkUrl} -gt 5 ] && [ $# -lt 1 ] ; then
         echo $checkUrl >> /tmp/mind_lift.txt
        checkUrl=""
    fi


done
cat /tmp/mind_lift.txt | tr ' ' "\\n"  | sed -e "s;://;####;g" | sed -e "s;//;/;g" | sed -e "s;####;://;g" > /tmp/mind_lift_out.txt
cat /tmp/mind_lift_out.txt > /tmp/mind_lift.txt
listOfFiles=( $( cat /tmp/mind_lift.txt ) )
# ## cat /tmp/mind_lift.txt
echo "check finish:: " ${listOfFiles[*]}
 
        doCheckHTTPFile     $( echo ${listOfFiles[*]} )
# ########## # ########### ########### ########### ##########

if [ $listOfFiles_valid -eq 0 ]; then
        /bin/echo  " #### ERROR :: Please check and report a mispell (HTTP 404) for URL some URL " | tee >&2 >> $SCRIPT_TTY
       send_exit 1
fi

# ########## # ########### ########### ########### ##########

for locationOfFile in $listOfFiles
do
    nameOfFile=`basename $locationOfFile`

 if [ -f $productCrossPorting_downloadFolder/$nameOfFile ];then
    /bin/echo "No download needed for "$productCrossPorting_downloadFolder/$nameOfFile | tee >&2 >> $SCRIPT_TTY
 else
    /bin/echo "Downloading "$locationOfFile" ..." | tee >&2 >> $SCRIPT_TTY
    curl -A "Mozilla/4.0"  -f -L -# $locationOfFile -o $productCrossPorting_downloadFolder/$nameOfFile;
    curl_result=$?
    # /bin/echo "curl result = " $curl_result

    if [ $curl_result -eq 0 ]; then
        /bin/echo " Download complete : ${nameOfFile}" | tee >&2 >> $SCRIPT_TTY
    else
        /bin/echo " #### ERROR :: (HTTP 404) :: $locationOfFile"
        /bin/echo  " #### ERROR :: Please check and report a mispell (HTTP 404) for URL : $locationOfFile" | tee >&2 >> $SCRIPT_TTY
       send_exit 1
    fi
 fi
done

# ########## # ########### ########### ########### ##########

