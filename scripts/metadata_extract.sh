#!/bin/bash

if [[ $# != 1 ]]; then
    echo "usage: metadata_extract.sh <unpacked_zip_dir>"
    exit 1
fi

SYSTEM_DIR="${1}"
if [[ ! -e "${SYSTEM_DIR}" ]]; then
    echo "System directory doesn't exist: ${SYSTEM_DIR}"
    exit 1
fi

META_FILE=$(find "${SYSTEM_DIR}/META-INF" -type f -name "metadata" 2>/dev/null)
if [[ -z ${META_FILE} ]]; then
    echo "No metadata file"
    exit 1
fi

echo "metadata file found: ${META_FILE}"
cat ${META_FILE}
