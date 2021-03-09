#!/bin/sh
test -f FVM-Installer.dmg && rm FVM-Installer.dmg
create-dmg \
  --volname "FVM Installer" \
  --volicon "fvm_installer_icon.icns" \
  --window-pos 200 120 \
  --window-size 800 529 \
  --icon-size 130 \
  --text-size 14 \
  --icon "Companion.app" 260 250 \
  --hide-extension "Companion.app" \
  --app-drop-link 540 250 \
  --hdiutil-quiet \
  "fvm.dmg" \
  "Release/"