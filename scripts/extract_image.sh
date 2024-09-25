#!/bin/bash

if [[ $# != 1 ]]; then
    echo "usage: extract_image.sh <package.zip>"
    exit 1
fi

IMG_FILE=$(basename "$1")
IMG_DIR=$(basename -s .zip "${IMG_FILE}")

echo "image file: ${IMG_FILE}"
mkdir -p "$IMG_DIR"
cd ${IMG_DIR} || exit 1
unzip "../${IMG_FILE}"

ota_extractor --payload payload.bin

mkdir system
sudo mount -o ro system.img system/
sudo mount -o ro vendor.img system/vendor/
sudo mount -o ro odm.img system/odm/
sudo mount -o ro product.img system/product/
sudo mount -o ro system_ext.img system/system_ext/
sudo mount -o ro my_product.img system/my_product/

mkdir dump
sudo cp -av system/* dump/

echo "DONE!"
