#!/usr/bin/env bash
# Collect the values behind every TODO in BoardConfig.mk / device.mk.
# Usage: tools/collect-device-info.sh [output_dir]
# Phone connected over adb with USB debugging on. Root is optional; steps that need it say so.
set -u

OUT="${1:-device-info}"
mkdir -p "$OUT"

if [ "$(adb get-state 2>/dev/null)" != "device" ]; then
    echo "No authorized adb device found. Connect the phone and accept the debugging prompt." >&2
    exit 1
fi

p() { adb shell getprop "$1" | tr -d '\r'; }
sh() { adb shell "$@" 2>&1 | tr -d '\r'; }

echo "[1/6] Properties"
adb shell getprop | tr -d '\r' > "$OUT/getprop_all.txt"
{
    for k in \
        ro.build.fingerprint ro.build.description ro.vendor.build.fingerprint \
        ro.product.first_api_level ro.build.version.sdk ro.build.version.release \
        ro.vendor.build.security_patch ro.build.version.security_patch \
        ro.build.ab_update ro.boot.slot_suffix ro.boot.dynamic_partitions \
        ro.virtual_ab.enabled ro.zygote ro.product.cpu.abilist \
        ro.hardware ro.board.platform ro.product.board ro.product.vendor.device \
        ro.vndk.version ro.treble.enabled ro.boot.verifiedbootstate ro.boot.avb_version \
        ro.boot.vbmeta.device_state ro.boot.flash.locked ro.sf.lcd_density ro.hwui.use_vulkan
    do
        printf '%s=%s\n' "$k" "$(p "$k")"
    done
} > "$OUT/key_props.txt"

echo "[2/6] Display, kernel command line, partitions"
sh wm density          > "$OUT/wm_density.txt"
sh cat /proc/cmdline   > "$OUT/cmdline.txt"
sh ls -l /dev/block/by-name > "$OUT/by-name.txt"
sh cat /proc/partitions > "$OUT/proc_partitions.txt"
sh cat /proc/mounts    > "$OUT/mounts.txt"

echo "[3/6] Dynamic partition layout (needs root for lpdump; fastboot getvar is the fallback)"
sh su -c "lpdump" > "$OUT/lpdump.txt" 2>&1 || true
if grep -qiE "not found|permission|inaccessible" "$OUT/lpdump.txt" 2>/dev/null; then
    echo "  lpdump unavailable without root. From fastbootd run:"
    echo "    fastboot getvar super-partition-name"
    echo "    fastboot getvar all   (look for partition-size:* and is-logical:*)"
fi

echo "[4/6] fstab and init files from the vendor image"
mkdir -p "$OUT/vendor_etc"
for f in $(adb shell ls /vendor/etc/fstab.* 2>/dev/null | tr -d '\r'); do
    adb pull "$f" "$OUT/vendor_etc/" >/dev/null 2>&1
done
adb pull /vendor/etc/vintf "$OUT/vintf" >/dev/null 2>&1 || echo "  could not pull /vendor/etc/vintf"
adb pull /vendor/build.prop "$OUT/vendor_build.prop" >/dev/null 2>&1 || true
adb pull /odm/etc/build.prop "$OUT/odm_build.prop" >/dev/null 2>&1 || true

echo "[5/6] Boot image (needs root; used to read header version, offsets and cmdline)"
if [ "$(sh su -c id | grep -c uid=0)" -gt 0 ]; then
    SLOT="$(p ro.boot.slot_suffix)"
    sh su -c "dd if=/dev/block/by-name/boot${SLOT} of=/sdcard/boot.img" >/dev/null
    adb pull /sdcard/boot.img "$OUT/boot.img" >/dev/null && adb shell rm /sdcard/boot.img
    echo "  saved $OUT/boot.img -> unpack with:  python3 unpack_bootimg.py --boot_img $OUT/boot.img --out $OUT/boot_unpacked"
else
    echo "  no root. Take boot.img from the stock firmware zip instead and unpack it the same way."
fi

echo "[6/6] Done. Files in $OUT/:"
ls -1 "$OUT"
echo
echo "Map results to BoardConfig.mk:"
echo "  ro.build.fingerprint / ro.build.description   -> lineage_X6815C.mk BuildFingerprint / BuildDesc"
echo "  ro.zygote                                      -> enable TARGET_2ND_ARCH only if zygote64_32"
echo "  ro.build.ab_update                             -> enable AB_OTA_UPDATER only if true"
echo "  ro.vendor.build.security_patch                 -> VENDOR_SECURITY_PATCH"
echo "  wm_density.txt                                 -> TARGET_SCREEN_DENSITY"
echo "  lpdump.txt / fastboot getvar                   -> BOARD_SUPER_PARTITION_SIZE and group sizes"
echo "  boot header / cmdline                          -> BOARD_BOOT_HEADER_VERSION, offsets, BOARD_KERNEL_CMDLINE"
echo "  vendor_etc/fstab.*                             -> replace rootdir/etc/fstab.mt6877"
echo "  vintf/                                         -> replace configs/vintf/*"
