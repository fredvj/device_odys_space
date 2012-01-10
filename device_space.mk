$(call inherit-product, build/target/product/small_base.mk)
$(call inherit-product, build/target/product/languages_small.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_eu_supl.mk)

$(call inherit-product-if-exists, vendor/odys/space/space-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/odys/space/overlay

PRODUCT_PACKAGES += \
    Gallery

# This is the list of libraries to include in the build
PRODUCT_PACKAGES += \
    sensors.space \
    lights.space \
    copybit.space \
    gralloc.space \
    gps.space \
    libcamera \
    libRS \
    librs_jni \
    hwprops \
    libOmxCore

TINY_TOOLBOX:=true

ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := device/odys/space/prebuilt/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

# Boot logo

PRODUCT_COPY_FILES += \
	device/odys/space/prebuilt/initlogo.rle:root/initlogo.rle

# Startup scripts

PRODUCT_COPY_FILES += \
	device/odys/space/boot.space.rc:root/init.space.rc

# Configuration files

PRODUCT_COPY_FILES += \
	device/odys/space/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf 

# Proprietary files - BLOBS

PRODUCT_COPY_FILES += \
	device/odys/space/recovery/battery_charging:system/bin/battery_charging

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := odys_space
PRODUCT_DEVICE := space
PRODUCT_MODEL := Odys Space
PRODUCT_BRAND := ACTION
PRODUCT_MANUFACTURER := ACTION
