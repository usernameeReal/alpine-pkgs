#!/bin/sh
set -e
cd /workspace
if [ -z "$APKSIGN_PRIVATE_KEY" ]
then
echo "Private key missing."
exit 1
fi
if [ "$(id -u)" = "0" ]
then
echo "Installing stuff..."
apk add -U alpine-sdk
echo "Creating user..."
adduser -D notroot
addgroup notroot abuild
chmod -R 777 /workspace
echo "Dropping priviliges..."
exec su notroot -c "sh $0"
fi
echo "Setting up abuild..."
mkdir -p $HOME/.abuild
echo 'PACKAGER_PRIVKEY="/tmp/pkey"' > $HOME/.abuild/abuild.conf
echo "$APKSIGN_PRIVATE_KEY" > /tmp/pkey
cp pkey.pub /tmp/
for pkg in baz
do
echo "Building $pkg"
cd "$pkg"
abuild -r
cd ..
done
cp $HOME/packages/*/$(uname -m)/*.apk .
