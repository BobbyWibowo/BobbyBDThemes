#!/usr/bin/env bash

ASSETS_ROOT=assets
REMOTE_VER=full
REMOTE_URL="https://blog.fiery.me/BobbyBDThemes"
BUILD_DIR=build
COPY_VER=full
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
  TARGET="$BUILD_DIR/bobby-$DIRECTORY.theme.css"

  # empty target
  [ $quiet -eq 0 ] && echo "Emptying $TARGET..."
  [ -f $TARGET ] && truncate -s 0 $TARGET || touch $TARGET

  # concatenate target with assets
  cd "$ASSETS_ROOT/$DIRECTORY"
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

  [ $quiet -eq 0 ] && echo "OK."
done

if [ $remote -eq 1 ]; then
  REMOTE_DIR="$ASSETS_ROOT/remote"

  [ $quiet -eq 0 ] && echo "Building \"remote\"..."
  TARGET="$BUILD_DIR/bobby-remote.theme.css"

  # empty target
  [ $quiet -eq 0 ] && echo "Emptying $TARGET..."
  [ -f $TARGET ] && truncate -s 0 $TARGET || touch $TARGET

  # append with meta tag
  META="$REMOTE_DIR/00-meta.css"
  [ $quiet -eq 0 ] && echo "Concatenating $META..."
  cat $META >> $TARGET
  printf "\n" >> $TARGET

  [ $quiet -eq 0 ] && echo "Concatenating asset names from \"$REMOTE_VER\"..."
  cd "$ASSETS_ROOT/$REMOTE_VER"
  for FILE in *
  do
    if [ "$FILE" != "00-meta.css" ] && [[ "$FILE" =~ ^.*\.css$ ]]; then
      printf "@import url($REMOTE_URL/assets/$REMOTE_VER/$FILE);\n" >> "$TARGET"
    fi
  done

  [ $quiet -eq 0 ] && echo "OK."
fi

cd "$DIR"
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
