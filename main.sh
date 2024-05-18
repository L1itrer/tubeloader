#!/bin/bash

init_vars()
{
    link=""
    format="mp4"
    audio_or_video="Video"
    directory="./videos"
    max_resolution=""
    quality=5
}

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

get_type()
{
    temp=$audio_or_video
    audio_or_video_menu=("Audio" "Video")
    audio_or_video=$(zenity --list --column=MENU "${audio_or_video_menu[@]}" --height 300 --title "Tubeloader" --text "Choose a format type")
    if [[ -z $audio_or_video ]]; then
    audio_or_video=$temp
    elif [[ $audio_or_video == "Audio" ]]; then
    format="mp3"
    elif [[ $audio_or_video == "Video" ]]; then
    format="mp4"
    fi
}

get_format()
{
    temp=$format
    if [[ $audio_or_video == "Video" ]]; then
    format_options=("mp4" "mov" "webm" "flv")
    else
    format_options=("wav" "flac" "opus" "mp3" "ogg")
    fi
    format=$(zenity --list --column=MENU "${format_options[@]}" --width 840 --height 500 --title "Tubeloader")
    if [[ -z $format ]]; then
    format=$temp
    fi
}

get_path()
{
    temp=$directory
    directory=$(zenity --file-selection --title "Select a directory" --directory)
    if [[ -z $directory ]]; then
    directory=$temp
    fi
}

get_resolution()
{
    echo "lol"
}

get_quality()
{
    temp=$quality
    quality=$(zenity --scale --text "Choose audio quality (0 for best, 10 for worst)" --min-value 0 --max-value 10 --value 5)
    if [[ -z $quality ]]; then
    quality=$temp
    fi
}

download()
{
    echo "lol"
}

init_vars
test=$(yt-dlp --version)
if [[ -z $test ]]; then
echo "This script requires yt-dlp to run properly"
exit 1
else
yt-dlp -U
fi

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
    clear
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
        ;;
        "$menu4")
        get_path
        ;;
        "$menu5")
        ;;
        "$menu6")
        get_quality
        ;;
        "$menu7")
        ;;
        "$menu8")
        clear
        exit 0
        ;;
    esac

done
