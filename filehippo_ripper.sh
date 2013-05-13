#!/bin/sh
# This script download all the latest software from filehippo.com
# by PrinceAMD

CURL=""
WGET=""

if [ -f "/etc/debian_version" ];
then
    CURL="/usr/bin/curl -s --connect-timeout 10"
    WGET="/usr/bin/wget -c --tries 3 --timeout 15"
else
    CURL="/opt/bin/curl -s --connect-timeout 10"
    WGET="/opt/bin/wget -c --tries 3 --timeout 15"
fi

FOLDER_LIST=""

_filehippo_get_folders()
{
    local run
    run=$($CURL http://filehippo.com/ |tr " " "\n" |tr "\"" "\n" |grep "/software/" |uniq |sed -e "s/\/software\///g"| sed -e "s/\///g"|sort |sed -e "s/^/\/software\//g"|sed -e "s/$/\//g" |tr "\n" " ")
    echo $run
}

_filehippo_create_folders()
{
    for folder in $FOLDER_LIST
    do
        if [ ! -d ".$folder" ];
        then
            mkdir -p ".$folder"
        fi
    done
}

_filehippo_get_contents()
{
    local soft=$1
    local run
    run=$($CURL http://filehippo.com$soft | tr " " "\n"|tr "\"" "\n" |grep download_ | uniq)
    echo $run
}

_filehippo_get_content_name()
{
    local cont=$1
    local run
    run=$($CURL http://filehippo.com$cont |grep title|head -1 |tr ">" "\n"|tr "<" "\n"|grep "Download"|sed -e "s/Download //g"|awk 'BEGIN { FS =" -" } ; { print $1 }'|sed -e "s/ /_/g")
    echo "$run.exe"
}

_filehippo_get_content_url_inner()
{
    local cont=$1
    local run
    run=$($CURL http://filehippo.com$cont |tr " " "\n"|tr "\"" "\n"|tr "=" "\n" |grep "download/file"|uniq)
    echo $run
}

_filehippo_get_content_url()
{
    local cont=$1
    local run
    run=$($CURL http://filehippo.com$cont |grep $cont|grep 'Latest Version'|tr ' ' '\n'|tr '\"' '\n'|grep download|uniq|head -1)
    echo $(_filehippo_get_content_url_inner $run)
}

_filehippo_download_software_file()
{
    local name=$1
    local link=$2
    local path=$3
    local run

    run=$($WGET -c http://filehippo.com$link -O $path$name)
    echo $run
}

_filehippo_download_software()
{
    for software in $FOLDER_LIST
    do
        local contents
        contents=$(_filehippo_get_contents $software)
        #echo "Software Type: .$software"

        for single_software in $contents
        do
            local download_link
            local download_name
            local download_folder
            local path

            download_folder=$(echo $single_software|sed -e "s/\/download_//g")
            path=".$software$download_folder"

            #echo "Software Path: $path"

            if [ ! -d "$path" ];
            then
                mkdir -p $path
            fi

            download_name="$(_filehippo_get_content_name $single_software)"
            download_link="$(_filehippo_get_content_url $single_software)"

            echo "Download Start::::: $path$download_name"
            _filehippo_download_software_file "$download_name" "$download_link" "$path"
            echo "Download Finish:::: $path$download_name"
            #echo $download_name
            #echo $download_link
        done
        #echo $contents

    done
}


FOLDER_LIST="$(_filehippo_get_folders)"
#echo $FOLDER_LIST

_filehippo_create_folders
_filehippo_download_software



