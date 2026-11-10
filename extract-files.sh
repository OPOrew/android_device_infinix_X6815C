#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0
#
# Pull the blobs listed in proprietary-files.txt from the phone (adb) or from a mounted
# stock dump, into vendor/infinix/X6815C. Written against the common LineageOS
# extract_utils layout; if your ROM source ships a newer extract_utils API, copy that
# ROM's device template script and keep only DEVICE/VENDOR from this one.
#
# Usage: ./extract-files.sh [-n|--no-cleanup] [-k|--kang] [-s|--section NAME] [adb | /path/to/dump]

set -e

DEVICE=X6815C
VENDOR=infinix

MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}" >&2
    exit 1
fi
source "${HELPER}"

CLEAN_VENDOR=true
KANG=
SECTION=
SRC=

while [ "${1}" != "" ]; do
    case "${1}" in
        -n | --no-cleanup) CLEAN_VENDOR=false ;;
        -k | --kang) KANG="--kang" ;;
        -s | --section) shift; SECTION="${1}"; CLEAN_VENDOR=false ;;
        *) SRC="${1}" ;;
    esac
    shift
done

if [ -z "${SRC}" ]; then
    SRC="adb"
fi

setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}" false "${CLEAN_VENDOR}"

extract "${MY_DIR}/proprietary-files.txt" "${SRC}" ${KANG} --section "${SECTION}"

"${MY_DIR}/setup-makefiles.sh"
