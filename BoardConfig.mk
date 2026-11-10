#
# SPDX-License-Identifier: Apache-2.0
#
# Infinix ZERO 5G 2023 (X6815C) - MediaTek Dimensity 1080 (MT6877)
#
# Everything marked TODO must be filled in from the stock firmware / device.
# Run tools/collect-device-info.sh with the phone connected over adb to gather it.

DEVICE_PATH := device/infinix/X6815C

# ---------------------------------------------------------------- Architecture
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-2a-dotprod
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_CPU_VARIANT_RUNTIME := cortex-a55

# TODO: only enable if `adb shell getprop ro.zygote` returns zygote64_32.
# (Cortex-A78 big cores have no AArch32 in newer MTK stacks; most MT6877 builds are 64-bit only.)
#TARGET_2ND_ARCH := arm
#TARGET_2ND_ARCH_VARIANT := armv8-a
#TARGET_2ND_CPU_ABI := armeabi-v7a
#TARGET_2ND_CPU_ABI2 := armeabi
#TARGET_2ND_CPU_VARIANT := cortex-a55

# ------------------------------------------------------------------- Platform
TARGET_BOARD_PLATFORM := mt6877
TARGET_BOOTLOADER_BOARD_NAME := mt6877
TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true

# ---------------------------------------------------------------------- Kernel
# Use the stock kernel until Transsion kernel sources are available.
# Unpack the stock boot.img (unpack_bootimg.py) and read the values below.
BOARD_BOOT_HEADER_VERSION := 2         # TODO verify
BOARD_KERNEL_BASE := 0x40000000        # TODO verify
BOARD_KERNEL_PAGESIZE := 4096
BOARD_KERNEL_OFFSET := 0x00008000      # TODO verify
BOARD_RAMDISK_OFFSET := 0x11b00000     # TODO verify
BOARD_KERNEL_TAGS_OFFSET := 0x07c08000 # TODO verify
BOARD_DTB_OFFSET := 0x07c08000         # TODO verify
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2 # TODO copy from stock boot.img
BOARD_KERNEL_IMAGE_NAME := Image.gz
TARGET_KERNEL_ARCH := arm64
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
TARGET_PREBUILT_DTB := $(DEVICE_PATH)/prebuilt/dtb.img
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/dtbo.img
BOARD_INCLUDE_DTB_IN_BOOTIMG := true
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --dtb_offset $(BOARD_DTB_OFFSET)

# --------------------------------------------------------------------- A/B?
# TODO: check `adb shell getprop ro.build.ab_update`. Leave commented for non-A/B.
#AB_OTA_UPDATER := true
#AB_OTA_PARTITIONS := boot vendor_boot system system_ext product vendor odm vbmeta vbmeta_system vbmeta_vendor dtbo
TARGET_OTA_ASSERT_DEVICE := X6815C,Infinix-X6815C,x6815c_h777

# ---------------------------------------------------------------- Partitions
BOARD_FLASH_BLOCK_SIZE := 262144
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432   # TODO verify (lpdump / fastboot getvar)
BOARD_DTBOIMG_PARTITION_SIZE := 8388608      # TODO verify
BOARD_USERDATAIMAGE_PARTITION_SIZE := 0      # unused, userdata sized at flash
BOARD_USERDATAIMAGE_FILE_SYSTEM_TYPE := f2fs
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := true

# Dynamic partitions
BOARD_SUPER_PARTITION_SIZE := 9126805504     # TODO verify with: adb shell lpdump or fastboot getvar super-partition-size
BOARD_SUPER_PARTITION_GROUPS := infinix_dynamic_partitions
BOARD_INFINIX_DYNAMIC_PARTITIONS_PARTITION_LIST := system system_ext product vendor odm
BOARD_INFINIX_DYNAMIC_PARTITIONS_SIZE := 9122611200  # TODO must be <= super size minus overhead

BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_SYSTEM_EXTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_PRODUCTIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_ODMIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
TARGET_COPY_OUT_PRODUCT := product
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_ODM := odm

# Prebuilt vendor/odm while the tree is being brought up (see README)
# BUILD_WITHOUT_VENDOR is not used; vendor is extracted from stock via proprietary-files.txt.

# ------------------------------------------------------------------ Verified boot
# For development flash with disabled vbmeta. Flip to true once you have your own keys.
BOARD_AVB_ENABLE := false
#BOARD_AVB_MAKE_VBMETA_IMAGE_ARGS += --flags 3

# ---------------------------------------------------------------------- Recovery
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt6877
TARGET_RECOVERY_PIXEL_FORMAT := RGBX_8888
BOARD_HAS_LARGE_FILESYSTEM := true
BOARD_USES_RECOVERY_AS_BOOT := false  # TODO set true if device has no recovery partition (check stock layout)

# ------------------------------------------------------------------------ Security
VENDOR_SECURITY_PATCH := 2023-01-05   # TODO from ro.vendor.build.security_patch
BOARD_VNDK_VERSION := current

# HIDL / VINTF - extract from stock /vendor/etc/vintf
DEVICE_MANIFEST_FILE := $(DEVICE_PATH)/configs/vintf/manifest.xml
DEVICE_MATRIX_FILE := $(DEVICE_PATH)/configs/vintf/compatibility_matrix.xml
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := $(DEVICE_PATH)/configs/vintf/framework_compatibility_matrix.xml

# --------------------------------------------------------------------- Properties
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/configs/properties/system.prop
TARGET_VENDOR_PROP += $(DEVICE_PATH)/configs/properties/vendor.prop

# ---------------------------------------------------------------------- Connectivity
# MediaTek combo chip uses the WMT driver
BOARD_WLAN_DEVICE := MediaTek
WPA_SUPPLICANT_VERSION := VER_0_8_X
BOARD_WPA_SUPPLICANT_DRIVER := NL80211
BOARD_HOSTAPD_DRIVER := NL80211
WIFI_DRIVER_FW_PATH_PARAM := /dev/wmtWifi
WIFI_DRIVER_FW_PATH_STA := STA
WIFI_DRIVER_FW_PATH_AP := AP
WIFI_DRIVER_FW_PATH_P2P := P2P
WIFI_DRIVER_STATE_CTRL_PARAM := /dev/wmtWifi
WIFI_DRIVER_STATE_ON := 1
WIFI_DRIVER_STATE_OFF := 0
BOARD_HAVE_BLUETOOTH := true

# ------------------------------------------------------------------------ Graphics
TARGET_SCREEN_DENSITY := 440   # TODO verify: adb shell wm density
TARGET_USES_HWC2 := true
TARGET_USES_GRALLOC4 := true   # TODO verify against vendor gralloc version

# ------------------------------------------------------------------------ SELinux
# MTK vendor sepolicy ships in the vendor image; keep device policy minimal.
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private

# Build quirks common on MTK bring-up
BUILD_BROKEN_DUP_RULES := true
BUILD_BROKEN_ELF_PREBUILT_PRODUCT_COPY_FILES := true
BUILD_BROKEN_MISSING_REQUIRED_MODULES := true

# Inherit the proprietary files
include vendor/infinix/X6815C/BoardConfigVendor.mk
