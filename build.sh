#!/usr/bin/env bash

ASSETS_ROOT=assets
REMOTE_URL="https://blog.fiery.me/BobbyBDThemes"
BUILD_DIR=build
PREFIX="Bobby-"
COPY_TO=~/.config/BetterDiscord/themes

# for EnhancedDiscord (with -e option)
ED_BUILD_FROM=(
  nox
  nox-ed
)
ED_BUILD_NAME="nox.ed.css"
ED_COPY_TO=~/.config/EnhancedDiscord/plugins

# options
copy=0
enhanceddiscord=0
remote=0
quiet=0

while getopts 'cerq' flag; do
  case "${flag}" in
    c) copy=1 ;;
    e) enhanceddiscord=1 ;;
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
for DIRECTORY in ${ASSETS_ROOT}/*/
do
  DIRECTORY="${DIRECTORY%/}"
  DIRECTORY="${DIRECTORY##*/}"

  # skip regular files
  [ -f $DIRECTORY ] && break
  [[ "$DIRECTORY" =~ ^_.*$ ]] && break

  [ $quiet -eq 0 ] && echo "Building \"$DIRECTORY\"..."
  TARGET="$BUILD_DIR/$PREFIX$DIRECTORY.css"
  TARGET_BD="$BUILD_DIR/$PREFIX$DIRECTORY.theme.css"
  TARGET_REMOTE="$BUILD_DIR/$PREFIX$DIRECTORY.remote.theme.css"

  # empty target
  [ $quiet -eq 0 ] && echo "Emptying $PREFIX$DIRECTORY.css..."
  [ -f $TARGET ] && truncate -s 0 $TARGET || touch $TARGET

  # concatenate target with assets
  for FILE in $ASSETS_ROOT/$DIRECTORY/files/*
  do
    if [[ "$FILE" =~ ^.*\.css$ ]]; then
      [ $quiet -eq 0 ] && echo "Concatenating ${FILE##*/}..."
      printf "/** --- ${FILE##*/} --- **/\n\n" >> "$TARGET"
      cat "$FILE" >> "$TARGET"
      printf "\n" >> "$TARGET"
    fi
  done

  # remove extra newline
  [ $quiet -eq 0 ] && echo "Cleaning up..."
  sed -i "$ d" "$TARGET"


  if [ -f $ASSETS_ROOT/$DIRECTORY/meta.css ]; then
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

    # make remote bd theme
    if [ $remote -eq 1 ]; then
      [ $quiet -eq 0 ] && echo "Making remote theme..."
      [ -f $TARGET_REMOTE ] && truncate -s 0 $TARGET_REMOTE || touch $TARGET_REMOTE
      cat "$ASSETS_ROOT/$DIRECTORY/meta-remote.css" >> "$TARGET_REMOTE"
      printf "\n@import url($REMOTE_URL/build/$PREFIX$DIRECTORY.css);\n" >> "$TARGET_REMOTE"
    fi
  fi

  [ $quiet -eq 0 ] && echo "OK."
done

if [ $enhanceddiscord -eq 1 ]; then
  BUILD_NAME="$PREFIX$ED_BUILD_NAME"
  TARGET="$BUILD_DIR/$BUILD_NAME"

  [ $quiet -eq 0 ] && echo "Making ED theme..."

  cat build-ed-template.css > "$BUILD_DIR/$BUILD_NAME"

  for FILE in "${ED_BUILD_FROM[@]}"
  do
    [ $quiet -eq 0 ] && echo "Inserting \"$FILE\"..."
    REPLACEMENT=$(<"build/$PREFIX$FILE.css")
    STRING="\/\*\* INSERT: $FILE \*\*\/"
    while IFS= read -r line; do
      echo "${line/$STRING/$REPLACEMENT}" >> "$TARGET.tmp"
    done < "$TARGET"
    mv -f "$TARGET.tmp" "$TARGET"
  done

  if [ $copy -eq 1 ]; then
    cp -f "$TARGET" "$ED_COPY_TO"
    [ $quiet -eq 0 ] && echo "Copied $BUILD_NAME.theme.css to $ED_COPY_TO."
  fi

  [ $quiet -eq 0 ] && echo "OK."
fi
