#!/bin/bash

cd $(dirname "${0}")

source ../_common.sh

rm -fr /opt/java/netbeans

download https://dlcdn.apache.org/netbeans/netbeans/15/netbeans-15-bin.zip

unzip data/netbeans-15-bin.zip -d /opt

echo "[Desktop Entry]" > /usr/share/applications/netbeans.desktop
echo "Exec=\"/opt/netbeans/bin/netbeans\" %f" >> /usr/share/applications/netbeans.desktop
echo "Icon=/opt/netbeans/nb/netbeans.png" >> /usr/share/applications/netbeans.desktop
echo "Name=NetBeans" >> /usr/share/applications/netbeans.desktop
echo "Terminal=false" >> /usr/share/applications/netbeans.desktop
echo "Type=Application" >> /usr/share/applications/netbeans.desktop