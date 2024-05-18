#!/bin/bash

init_vars()
{
    link=""
    format=""
    audio_or_video="Video"
    directory="./videos"
    max_resolution=""
    quality=0
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
    fi
}

get_format()
{
    echo "lol"
}

get_path()
{
    echo "lol"
}

get_resolution()
{
    echo "lol"
}

get_quality()
{
    echo "lol"
}

download()
{
    echo "lol"
}

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
        ;;
        "$menu5")
        ;;
        "$menu6")
        ;;
        "$menu7")
        ;;
        "$menu8")
        clear
        exit 0
        ;;
    esac

done
