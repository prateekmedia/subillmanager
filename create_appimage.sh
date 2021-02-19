#!/usr/bin/env bash
set -e
# flutter build linux
mkdir -p SUbillManager.AppDir/usr/bin
cp -r build/linux/*/release/bundle/* SUbillManager.AppDir/usr/bin
echo "MANUAL TODO (Once):"
echo "- Copy AppRun from https://github.com/AppImage/AppImageKit releases into SUbillManager.AppDir/"
echo "- Locate libunixdomainsocket.so on your PC and put it in SUbillManager.AppDir/usr/bin/lib/"
echo "Press enter to continue"
head -n1 > /dev/null
strip SUbillManager.AppDir/usr/bin/lib/libapp.so SUbillManager.AppDir/usr/bin/lib/libflutter_linux_gtk.so SUbillManager.AppDir/usr/bin/lib/libunixdomainsocket.so SUbillManager.AppDir/usr/bin/su_bill_manager
~/Downloads/appimagetool-x86_64.AppImage SUbillManager.AppDir/