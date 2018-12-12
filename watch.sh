#!/usr/bin/env bash

DIRECTORY=assets/*

echo "Watching $DIRECTORY directory..."

# inotifywait has a --monitor flag, but it doesn't work properly on my end, so we do a while-loop instead
while inotifywait -rqe modify $DIRECTORY
do ./build.sh -q $@
done
