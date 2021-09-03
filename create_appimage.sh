#!/bin/sh

# Create Application Directory
mkdir -p AppDir

# Create AppRun file(required by AppImage)
echo '#!/bin/sh

cd "$(dirname "$0")"
exec ./subillmanager' > AppDir/AppRun
sudo chmod +x AppDir/AppRun

# Copy all build files to AppDir
cp -r build/linux/x64/release/bundle/* AppDir

## Add Application metadata
# Copy app icon
sudo mkdir -p AppDir/usr/share/icons/hicolor/256x256/apps/
cp assets/subillmanager.png AppDir/subillmanager.png
sudo cp AppDir/subillmanager.png AppDir/usr/share/icons/hicolor/256x256/apps/subillmanager.png

sudo mkdir -p AppDir/usr/share/applications

# Either copy .desktop file content from file or with echo command
# cp assets/subillmanager.desktop AppDir/subillmanager.desktop

echo '[Desktop Entry]
Version=1.0
Type=Application
Name=SUbillManager
Icon=subillmanager
Exec=subillmanager %u
StartupWMClass=subillmanager
Categories=Utility;' > AppDir/subillmanager.desktop

# Also copy the same .desktop file to usr folder
sudo cp AppDir/subillmanager.desktop AppDir/usr/share/applications/subillmanager.desktop

## Start build
test ! -e appimagetool-x86_64.AppImage && curl -L https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage -o appimagetool-x86_64.AppImage
sudo chmod +x appimagetool-x86_64.AppImage
ARCH=x86_64 ./appimagetool-x86_64.AppImage AppDir/ subillmanager-x86_64.AppImage
