#!/bin/bash
#
# SPDX-License-Identifier: Apache-2.0
#
# Generates vendor/infinix/X6815C/{Android.bp,Android.mk,X6815C-vendor.mk,BoardConfigVendor.mk}
# from proprietary-files.txt. Run by extract-files.sh, or on its own after editing the list.

set -e

DEVICE=X6815C
VENDOR=infinix
INITIAL_COPYRIGHT_YEAR=2026

MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "${MY_DIR}" ]]; then MY_DIR="${PWD}"; fi

ANDROID_ROOT="${MY_DIR}/../../.."

HELPER="${ANDROID_ROOT}/tools/extract-utils/extract_utils.sh"
if [ ! -f "${HELPER}" ]; then
    echo "Unable to find helper script at ${HELPER}" >&2
    exit 1
fi
source "${HELPER}"

setup_vendor "${DEVICE}" "${VENDOR}" "${ANDROID_ROOT}"

write_headers

write_makefiles "${MY_DIR}/proprietary-files.txt" true

write_footers
