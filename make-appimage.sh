#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q mission-center | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export ICON=/usr/share/icons/hicolor/scalable/apps/io.missioncenter.MissionCenter.svg
export DESKTOP=/usr/share/applications/io.missioncenter.MissionCenter.desktop

# Deploy dependencies
quick-sharun /usr/bin/missioncenter*

echo 'MC_RESOURCE_DIR=${SHARUN_DIR}/share/missioncenter' >> ./AppDir/.env
echo 'MC_MAGPIE_HW_DB=${SHARUN_DIR}/share/hw.db'         >> ./AppDir/.env

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the app normally quits before that time
# then skip this or check if some flag can be passed that makes it stay open
quick-sharun --test ./dist/*.AppImage
