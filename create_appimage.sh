#!/bin/sh

sudo chmod +x appimagetool-x86_64.AppImage
cp -r build/linux/x64/release/bundle/* AppDir
mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps/
cp assets/subillmanager.png AppDir/usr/share/icons/hicolor/256x256/apps/
cp assets/subillmanager.png AppDir/subillmanager.png
mkdir -p AppDir/usr/share/applications
cp assets/subillmanager.desktop AppDir/usr/share/applications/subillmanager.desktop
cp assets/subillmanager.desktop AppDir/subillmanager.desktop
sudo chmod +x appimagetool-x86_64.AppImage
ARCH=x86_64 ./appimagetool-x86_64.AppImage AppDir/ subillmanager-x86_64.AppImage