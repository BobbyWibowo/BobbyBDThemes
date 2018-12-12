#!/usr/bin/env bash

DIRECTORY=assets/*

echo "Watching $DIRECTORY directory..."

# inotifywait has a --monitor flag, but it doesn't work properly on my end, so we do a while-loop instead
while inotifywait -qe modify $DIRECTORY
do ./build.sh -cq
done
