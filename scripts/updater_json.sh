#!/bin/bash

set -e

function usage()
{
    echo "usage: updater_json.sh <out_dir>"
}

CUR_DIR="${PWD}"

if [[ $# != 1 ]]; then
    usage
    exit 255
fi

OUT_DIR="${1}"
if [[ ! -d "${OUT_DIR}" ]]; then
    echo "ERROR: given path - ${OUT_DIR} is not a directory, exitting!"
    exit 255
fi

echo "out dir: ${OUT_DIR}"
cd "${OUT_DIR}"

TARGET="$(basename "${OUT_DIR}")"
DATETIME="$(cat "${OUT_DIR}/../../../build_date.txt")"
FILENAME="$(basename $(ls -1 *.zip | grep "lineage-\|EvolutionX-"))"
FILESIZE="$(du -b "${OUT_DIR}/${FILENAME}" | awk '{print $1'})"
echo "Obtaining md5sum"
MD5="$(md5sum "${OUT_DIR}/${FILENAME}" | awk '{print $1'})"
echo "Obtaining sha256"
SHA256="$(sha256sum "${OUT_DIR}/${FILENAME}" | awk '{print $1'})"

echo "TARGET=${TARGET}"
echo "DATETIME=${DATETIME}"
echo "FILENAME=${FILENAME}"
echo "FILESIZE=${FILESIZE}"
echo "MD5=${MD5}"
echo "SHA256=${MD5}"

cd "${CUR_DIR}"

if grep -q "lineage" <<<${FILENAME} ; then
    # Lineage
    echo "Processing LineageOS JSON"

    LINEAGE_VER="21.0"
    LINEAGE_VER_PATH="${LINEAGE_VER/./_}"

    cat > updater.json << EOF
{
  "response": [
    {
      "datetime": ${DATETIME},
      "filename": "${FILENAME}",
      "id": "${MD5}",
      "romtype": "unofficial",
      "size": ${FILESIZE},
      "url": "http://obeny.obeny.net/android/lineageos/${LINEAGE_VER_PATH}/${TARGET}/${FILENAME}",
      "version": "${LINEAGE_VER}"
    }
  ]
}
EOF
elif grep -q "Evolution" <<<${FILENAME} ; then
    # EvolutionX
    echo "Processing EvolutionX JSON"

    EVOLUTIONX_VER="$(sed -e 's/\(.*-v\)\(9\..\)\(-.*\)/\2/g' <<<${FILENAME})"
    EVOLUTIONX_VER_PATH="9_x"

    FINGERPRINT="$(cat "${OUT_DIR}/build_fingerprint.txt")"
    OEM="$(cut -f 1 -d '/' <<<${FINGERPRINT})"
    DEVICE="$(cut -f 2 -d '/' <<<${FINGERPRINT})"
    BUILDTYPE="$(cat "${OUT_DIR}/system/build.prop" | grep ro.build.type | cut -d "=" -f 2)"

    cat > updater.json << EOF
{
  "response": [
    {
      "maintainer": "obeny",
      "oem": "${OEM}",
      "device": "${DEVICE}",

      "filename": "${FILENAME}",
      "download": "http://obeny.obeny.net/android/evolution_x/${EVOLUTIONX_VER_PATH}/${TARGET}/${FILENAME}",
      "timestamp": ${DATETIME},
      "md5": "${MD5}",
      "sha256": "${SHA256}",
      "size": ${FILESIZE},
      "version": "${EVOLUTIONX_VER}",

      "buildtype": "${BUILDTYPE}",
      "firmware": "",

      "forum": "",
      "paypal": "",
      "telegram": "",
      "github": ""
    }
  ]
}
EOF
else
    # Invalid
    echo "Unable to detect OS type!"
    exit 1
fi

echo "DONE!"
