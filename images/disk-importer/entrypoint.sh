#!/bin/bash

[ -z "$URL" ] && { echo "URL not specified"; exit 1; }
[ -z "INSTALL_TO" ] && { echo "INSTALL_TO not specified"; exit 1; }
set -e

echo "Downloading $URL"
curl $CURL_OPTS -o /tmp/disk $URL

echo "Converting to RAW and installing to $INSTALL_TO"
qemu-img convert -O raw /tmp/disk $INSTALL_TO
