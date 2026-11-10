#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/infinix/X6815C

# Dynamic partitions / virtual A/B (adjust if the device is non-A/B)
PRODUCT_USE_DYNAMIC_PARTITIONS := true
PRODUCT_BUILD_SUPER_PARTITION := false
# PRODUCT_VIRTUAL_AB_OTA := true  # TODO only if stock uses virtual A/B

# Shipping API level of the stock vendor (Android 12 = 31). TODO verify:
#   adb shell getprop ro.product.first_api_level
PRODUCT_SHIPPING_API_LEVEL := 31

# Soong namespaces
PRODUCT_SOONG_NAMESPACES += \
    $(DEVICE_PATH) \
    hardware/mediatek

# Overlays
DEVICE_PACKAGE_OVERLAYS += $(DEVICE_PATH)/overlay

# Boot control / health / power (AOSP defaults; replace with stock MTK HALs as they are extracted)
PRODUCT_PACKAGES += \
    android.hardware.health@2.1-impl \
    android.hardware.health@2.1-service \
    android.hardware.power-service.example \
    android.hardware.usb@1.0-service
# TODO: keymaster/gatekeeper/boot HAL come from the stock vendor image. Add the module
# names only after extract-files has produced them, e.g.:
#   android.hardware.keymaster@4.1-service.mediatek

# Audio / bluetooth / camera / gnss / sensors / radio: provided by stock vendor blobs.
# Add their init rc / HIDL service names here after running extract-files.

# Permissions (copy from stock /vendor/etc/permissions as needed)
PRODUCT_COPY_FILES += \
    frameworks/native/data/etc/android.hardware.wifi.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.xml \
    frameworks/native/data/etc/android.hardware.wifi.direct.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.wifi.direct.xml \
    frameworks/native/data/etc/android.hardware.bluetooth.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth.xml \
    frameworks/native/data/etc/android.hardware.bluetooth_le.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.bluetooth_le.xml \
    frameworks/native/data/etc/android.hardware.telephony.ims.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.telephony.ims.xml \
    frameworks/native/data/etc/android.hardware.fingerprint.xml:$(TARGET_COPY_OUT_VENDOR)/etc/permissions/android.hardware.fingerprint.xml

# Rootdir (fstab; copied straight to vendor, no separate module needed)
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/fstab.mt6877:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mt6877

# Display
PRODUCT_AAPT_CONFIG := normal
PRODUCT_AAPT_PREF_CONFIG := xxhdpi
