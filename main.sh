#!/bin/bash
# Author           : Mateusz Rzęsa ( email )
# Created On       : 13.05.2024
# Last Modified By : Imie Nazwisko ( email )
# Last Modified On : 19.05.2024 
# Version          : 2024.05.19
#
# Description      : A simple bash script for downloading Youtube videos
#                    and/or audio files with some customizations. Reliant
#                    on yt-dlp, therefore most of the credit should go to
#                    the creators and contributors of that project.
# Dependencies     : yt-dlp, FFmpeg, zenity
#
# Licensed under GPL (see /usr/share/common-licenses/GPL for more details
# or contact # the Free Software Foundation for a copy)
VERSION="2024.05.19"
AUTHOR="Mateusz Rzęsa"

#Displays information about the version
display_version()
{
    echo "Tubeloader"
    echo "Version: $VERSION"
    echo "Author: $AUTHOR"
}

#Displays information about the author
display_help()
{
    display_version
    echo "-h for help"
    echo "-v for version"
    echo "Script simplifies the downloading of youtube videos from a given youtube link."
    echo "Select \"Link\" to paste a youtube link."
    echo "Select \"Type\" to choose between downloading audio or video file"
    echo "Select \"Format\" to choose your preferred file format (if available)"
    echo "Select \"Path do download\" to choose a directory you want the files to be downloaded to"
    echo "Select \"Max resolution\" to pick your preferred resolution. The script will download the best available resolution not greater then the one chosen by you"
    echo "Select \"Download\" to download the pasted youtube link"
    echo "Select \"Quit\" or click cancel to exit the script"
}

#Check for the instalation of zenity
is_zenity_installed()
{
    test=$(zenity --version)
    if [[ -z $test ]]; then
    echo "This script requires zenity to run properly, please install zenity"
    exit 1
    fi
}

#Check for the installation of yt-dlp, and download and update it if unavailable
is_yt_dlp_installed()
{
    if ! type "yt-dlp" > /dev/null ; then
    sudo add-apt-repository ppa:tomtomtom/yt-dlp    # Add ppa repo to apt
    sudo apt update                                 # Update package list
    sudo apt install yt-dlp                         # Install yt-dlp
    fi

}

#Create variables for the script and assign them default values
init_vars()
{
    link=""
    format="mp4"
    audio_or_video="Video"
    directory="./videos"
    max_resolution="720"
    quality=5
}

#Function to get link from the user, will loop until the link is valid or cancel button is clicked
get_link()
{
    while true; do
        link=$(zenity --entry --title "Tubeloader" --width 840 --text "Enter download link:")
        if [[ $link == "https://www.youtube.com"* ]]; then
        break;
        elif [[ -z "$link" ]]; then
        link=""
        break;
        echo ""
        else
        zenity --error --text "Please enter a youtube link" --title "Tubeloader"
        link=""
        fi
    done
}

#Function to get the type from the menu (an audio file or video file), will assign a default format upon change of type
get_type()
{
    temp=$audio_or_video
    audio_or_video_menu=("Audio" "Video")
    audio_or_video=$(zenity --list --column=Select "${audio_or_video_menu[@]}" --height 300 --title "Tubeloader" --text "Choose a format type")
    if [[ -z $audio_or_video ]]; then
    audio_or_video=$temp
    elif [[ $audio_or_video == "Audio" ]]; then
    format="mp3"
    elif [[ $audio_or_video == "Video" ]]; then
    format="mp4"
    fi
}

#Function to get the format of a file from a menu
get_format()
{
    temp=$format
    if [[ $audio_or_video == "Video" ]]; then
    format_options=("mp4" "mov" "webm" "flv")
    else
    format_options=("wav" "flac" "opus" "mp3" "ogg")
    fi
    format=$(zenity --list --column=Select "${format_options[@]}" --width 840 --height 500 --title "Tubeloader")
    if [[ -z $format ]]; then
    format=$temp
    fi
}

#Function to get the download directory, uses zenity for selection
get_path()
{
    temp=$directory
    directory=$(zenity --file-selection --title "Select a directory" --directory)
    if [[ -z $directory ]]; then
    directory=$temp
    fi
}

#Function to get a max resolution from a menu
get_resolution()
{
    temp=$max_resolution
    resolution_options=("144" "240" "360" "480" "720" "1080" "1440")
    max_resolution=$(zenity --list --column=Select "${resolution_options[@]}" --height 500 --title "Tubeloader")
    if [[ -z $max_resolution ]]; then
    max_resolution=$temp
    fi

}

#Function to select quality from a slider
get_quality()
{
    temp=$quality
    quality=$(zenity --scale --text "Choose audio quality (0 for best, 10 for worst)" --min-value 0 --max-value 10 --value 5)
    if [[ -z $quality ]]; then
    quality=$temp
    fi
}

#Final function to download, creates a function link
download()
{
    command=""
    if [[ $link == "" ]]; then
    zenity --error --title "Tubeloader" --text "Please enter a valid download link"
    return
    fi
    if [[ $link == *"&list"* ]] || [[ $link == *"playlist"* ]]; then
    zenity --question --text "The link appears to be a playlist link, do you want to download the whole playlist?"
        if [[  $? == 1 ]]; then
        command+=" --no-playlist"
        fi
    fi
    if [[ $audio_or_video == "Audio" ]]; then
    command+=" -x --audio-format $format"
    else
    command+=" -f $format -S res:$max_resolution"
    fi
    out=$(yt-dlp $link -q --no-warnings $command --audio-quality $quality --windows-filenames --no-keep-video -P $directory 2>&1)
    if [[ $out == "" ]]; then
    out="Download successful"
    fi
    zenity --info --title "Tubeloader" --text="$out"
}



##########################################################
######Script execution begins from this point onward######
##########################################################

while getopts ":hv" opt; do
    case ${opt} in
        h )
            display_help
            exit 0
            ;;
        v )
            display_version
            exit 0
            ;;
        \? )
            echo "Unknown option. -h for help"
            exit 1
            ;;
    esac
done
is_zenity_installed
is_yt_dlp_installed

init_vars


while true; do
    menu1="Current link: $link"
    menu2="Type: $audio_or_video"
    menu3="Format $format"
    menu4="Path to download: $directory"
    menu5="Max resolution: $max_resolution"
    menu6="Quality: $quality"
    menu7="Download"
    menu8="Quit"

    Menu=("$menu1" "$menu2" "$menu3" "$menu4" "$menu5" "$menu6" "$menu7" "$menu8")
    choice=$(zenity --list --column=MENU "${Menu[@]}" --width 840 --height 500 --title "Tubeloader")

    if [[ -z $choice ]]; then
    exit 0
    fi

    case "$choice" in
        "$menu1")
        get_link
        ;;
        "$menu2")
        get_type
        ;;
        "$menu3")
        get_format
        ;;
        "$menu4")
        get_path
        ;;
        "$menu5")
        get_resolution
        ;;
        "$menu6")
        get_quality
        ;;
        "$menu7")
        download
        ;;
        "$menu8")
        exit 0
        ;;
    esac

done
