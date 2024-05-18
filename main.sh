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
    choice=$(zenity --list --column=MENU "${Menu[@]}" --height 750 --title "Tubeloader")
    case "$choice" in
        "$menu1")
        link=$(zenity --entry --title "Tubeloader" --text "Enter download link:")
        ;;
        "$menu2")
        audio_or_video_menu=("Audio" "Video")
        audio_or_video=$(zenity --list --column=MENU "${audio_or_video_menu[@]}" --height 300 --title "Tubeloader" --text "Choose a format type")
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
