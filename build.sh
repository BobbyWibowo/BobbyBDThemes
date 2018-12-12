#!/usr/bin/env bash

META=meta.css
ASSETS_DIR=assets
BUILD_DIR=build
COPY_VER=full
COPY_TO=~/.config/BetterDiscord/themes

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

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

META="$DIR/$META"
ASSETS_DIR="$DIR/$ASSETS_DIR"
BUILD_DIR="$DIR/$BUILD_DIR"

cd $ASSETS_DIR
for DIRECTORY in *
do
  # skip files
  [ -f $DIRECTORY ] && break

  [ $quiet -eq 0 ] && echo "Building \"$DIRECTORY\"..."
  TARGET="$BUILD_DIR/bobby-$DIRECTORY.theme.css"

  # empty target
  [ $quiet -eq 0 ] && echo "Emptying $TARGET..."
  [ -f $TARGET ] && truncate -s 0 $TARGET || touch $TARGET

  # append with meta tag
  [ $quiet -eq 0 ] && echo "Concatenating $META..."
  cat $META >> $TARGET
  printf "\n" >> $TARGET

  # concatenate target with assets
  cd "$ASSETS_DIR/$DIRECTORY"
  for FILE in *
  do
    [ $quiet -eq 0 ] && echo "Concatenating $FILE..."
    printf "/** --- $FILE --- **/\n\n" >> "$TARGET"
    cat "$FILE" >> "$TARGET"
    printf "\n" >> "$TARGET"
  done

  # remove extra white space
  [ $quiet -eq 0 ] && echo "Cleaning up..."
  sed -i "$d" "$TARGET"

  [ $quiet -eq 0 ] && echo "OK."
done

cd ..
# copy build to target directory
if [ $copy -eq 1 ]; then
  FILE="$BUILD_DIR/bobby-$COPY_VER.theme.css"
  if [ -f "$FILE" ]; then
    cp -f "$FILE" "$COPY_TO"
    [ $quiet -eq 0 ] && echo "Copied \"$COPY_VER\" to $COPY_TO."
  else
    echo "ERROR: Could not copy, \"$COPY_VER\" does not exist."
  fi
fi
