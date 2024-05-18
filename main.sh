#!/bin/bash


test=$(yt-dlp aodijasdoi -q)
if [ -z "$test" ]; then
echo "success"
else
echo "failure"
fi