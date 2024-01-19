#!/bin/sh

while :; do
    pandoc --reference-location=block -s -t revealjs -o http-workshop.html http-workshop.md
    inotifywait http-workshop.md
done
