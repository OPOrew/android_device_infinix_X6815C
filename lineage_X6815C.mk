#
# SPDX-License-Identifier: Apache-2.0
#
# Product makefile. To build a different ROM (PixelOS, Pixel Experience, crDroid...),
# copy this file to <rom>_X6815C.mk, change the vendor config inherit below, update
# AndroidProducts.mk, and change PRODUCT_NAME to match.

# Inherit from those products. Most specific first.
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit_only.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

# Inherit some common Lineage stuff (swap for your ROM's equivalent)
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

# Inherit from the device makefile
$(call inherit-product, device/infinix/X6815C/device.mk)

PRODUCT_NAME := lineage_X6815C
PRODUCT_DEVICE := X6815C
PRODUCT_MANUFACTURER := INFINIX
PRODUCT_BRAND := Infinix
PRODUCT_MODEL := Infinix ZERO 5G 2023

PRODUCT_GMS_CLIENTID_BASE := android-transsion

# TODO: replace with the stock fingerprint from the device:
#   adb shell getprop ro.build.fingerprint
PRODUCT_BUILD_PROP_OVERRIDES += \
    BuildDesc="TODO" \
    BuildFingerprint="TODO"

$(call inherit-product, vendor/infinix/X6815C/X6815C-vendor.mk)
