# device_infinix_X6815C

Starter device tree for the **Infinix ZERO 5G 2023 (X6815C)**: MediaTek Dimensity 1080 (MT6877), codename `x6815c_h777`, shipped on Android 12.

This is a **bring-up skeleton**, not a finished tree. It is built around the generic MT6877 layout and the stock vendor image. Every value marked `TODO` must be confirmed from your own device or stock firmware before the build will boot.

## What is here

| Path | Purpose |
|---|---|
| `AndroidProducts.mk`, `lineage_X6815C.mk` | Lunch target and product definition |
| `BoardConfig.mk`, `device.mk` | Platform, kernel, partitions, AVB, Wi-Fi/BT, HAL packages |
| `rootdir/etc/fstab.mt6877` | Typical MT6877 fstab. Replace with the stock one |
| `configs/vintf/*` | **Placeholders.** Replace with stock `/vendor/etc/vintf/*` |
| `configs/properties/*` | Empty property files, ready for overrides |
| `proprietary-files.txt` | Blob list. Intentionally empty, see the file for how to generate it |
| `extract-files.sh`, `setup-makefiles.sh` | LineageOS extract_utils style blob extraction and vendor makefile generation |
| `tools/collect-device-info.sh` | Pulls the values behind every `TODO` over adb |
| `prebuilt/` | Put stock `kernel`, `dtb.img`, `dtbo.img` here (see below) |

## Bring-up order

1. Run `tools/collect-device-info.sh` with the phone connected. Fill in the `TODO`s in `BoardConfig.mk`, `device.mk` and `lineage_X6815C.mk` from `device-info/`.
2. Unpack the stock `boot.img` (`unpack_bootimg.py`). Copy the kernel to `prebuilt/kernel`, the DTB to `prebuilt/dtb.img`, and the stock `dtbo.img` to `prebuilt/dtbo.img`. Copy the header version, offsets and cmdline into `BoardConfig.mk`.
3. Replace `rootdir/etc/fstab.mt6877` and `configs/vintf/*` with the stock files.
4. Build `proprietary-files.txt` from your stock vendor image, then run `./extract-files.sh` from the stock dump or the phone.
5. Place the tree at `device/infinix/X6815C` in the ROM source, then:
   ```
   source build/envsetup.sh
   lunch lineage_X6815C-userdebug
   mka bacon        # or the ROM's own target
   ```
6. Flash with AVB disabled. Keep `nvram`, `nvdata` and `protect*` backed up first.

## Other ROMs (PixelOS, Pixel Experience, crDroid)

Copy `lineage_X6815C.mk` to `<rom>_X6815C.mk`, swap the `vendor/lineage/config/...` inherit for that ROM's equivalent, change `PRODUCT_NAME`, and update `AndroidProducts.mk`. The board and device files stay the same.

## Known limits

- No kernel sources are included. The tree uses the stock prebuilt kernel, so kernel-side features (and an SELinux policy that matches the vendor) are whatever stock provides.
- The vendor image is stock Android 12. A newer ROM may need vendor HAL shims or patches (camera, radio/IMS and fingerprint are the usual trouble spots).
- A full ROM build needs a Linux machine with roughly 300 GB free disk and 32 GB RAM or more.
