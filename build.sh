#!/usr/bin/env bash

ASSETS_ROOT=assets
REMOTE_URL="https://blog.fiery.me/BobbyBDThemes"
BUILD_DIR=build
PREFIX="Bobby-"
COPY_TO=~/.config/BetterDiscord/themes

# options
copy=0
remote=0
quiet=0

while getopts 'crq' flag; do
  case "${flag}" in
    c) copy=1 ;;
    r) remote=1 ;;
    q) quiet=1 ;;
    *) break ;;
  esac
done

# extend path
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"
ASSETS_ROOT="$DIR/$ASSETS_ROOT"
BUILD_DIR="$DIR/$BUILD_DIR"

# we loop through all directories to allow multiple versions support
cd $ASSETS_ROOT
for DIRECTORY in *
do
  # skip regular files and "remote" directory
  [ -f $DIRECTORY ] && break
  [ "$DIRECTORY" = "remote" ] && break

  [ $quiet -eq 0 ] && echo "Building \"$DIRECTORY\"..."
  TARGET="$BUILD_DIR/$PREFIX$DIRECTORY.css"
  TARGET_BD="$BUILD_DIR/$PREFIX$DIRECTORY.theme.css"
  TARGET_REMOTE="$BUILD_DIR/$PREFIX$DIRECTORY.remote.theme.css"

  # empty target
  [ $quiet -eq 0 ] && echo "Emptying $PREFIX$DIRECTORY.css..."
  [ -f $TARGET ] && truncate -s 0 $TARGET || touch $TARGET

  # concatenate target with assets
  cd "$ASSETS_ROOT/$DIRECTORY/files"
  for FILE in *
  do
    if [[ "$FILE" =~ ^.*\.css$ ]]; then
      [ $quiet -eq 0 ] && echo "Concatenating $FILE..."
      [ "$FILE" != "00-meta.css" ] && printf "/** --- $FILE --- **/\n\n" >> "$TARGET"
      cat "$FILE" >> "$TARGET"
      printf "\n" >> "$TARGET"
    fi
  done

  # remove extra white space
  [ $quiet -eq 0 ] && echo "Cleaning up..."
  sed -i "$d" "$TARGET"

  # make bd theme
  [ $quiet -eq 0 ] && echo "Making BD theme..."
  [ -f $TARGET_BD ] && truncate -s 0 $TARGET_BD || touch $TARGET_BD
  cat "$ASSETS_ROOT/$DIRECTORY/meta.css" >> "$TARGET_BD"
  printf "\n" >> "$TARGET_BD"
  cat "$TARGET" >> "$TARGET_BD"

  # copy bd theme
  if [ $copy -eq 1 ]; then
    cp -f "$TARGET_BD" "$COPY_TO"
    [ $quiet -eq 0 ] && echo "Copied $PREFIX$DIRECTORY.theme.css to $COPY_TO."
  fi

  # make remote theme
  if [ $remote -eq 1 ]; then
    [ $quiet -eq 0 ] && echo "Making remote theme..."
    [ -f $TARGET_REMOTE ] && truncate -s 0 $TARGET_REMOTE || touch $TARGET_REMOTE
    cat "$ASSETS_ROOT/$DIRECTORY/meta-remote.css" >> "$TARGET_REMOTE"
    printf "\n@import url($REMOTE_URL/build/$PREFIX$DIRECTORY.css);\n" >> "$TARGET_REMOTE"
  fi

  [ $quiet -eq 0 ] && echo "OK."
done
