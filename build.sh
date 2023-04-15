#!/bin/sh
set -e
cd /workspace
if [ -z "$APKSIGN_PRIVATE_KEY" ]
then
echo "Private key missing."
exit 1
fi
apk add -U alpine-sdk
if [ "$(id -u)" = "0" ]
then
adduser -D notroot
addgroup notroot abuild
exec su notroot -c "sh $0"
fi
mkdir -p $HOME/.abuild
echo 'PACKAGER_PRIVKEY="/tmp/pkey"' > $HOME/.abuild/abuild.conf
echo "$APKSIGN_PRIVATE_KEY" > /tmp/pkey
for pkg in baz
do
cd $pkg
abuild -r
cd ..
cp $HOME/packages/*.apk ..
