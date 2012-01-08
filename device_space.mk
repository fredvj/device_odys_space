# $(call inherit-product, $(SRC_TARGET_DIR)/product/languages_full.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_eu_supl.mk)

$(call inherit-product-if-exists, vendor/odys/space/space-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/odys/space/overlay


ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := device/odys/space/prebuilt/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif

PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

# Boot logo

PRODUCT_COPY_FILE += \
	device/odys/space/prebuilt/initlogo.rle:root/initlogo.rle

# Configuration files

PRODUCT_COPY_FILES += \
	device/odys/space/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf 

# $(call inherit-product, build/target/product/full.mk)
$(call inherit-product, build/target/product/small_base.mk)
$(call inherit-product, build/target/product/languages_small.mk)

PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := odys_space
PRODUCT_DEVICE := space
PRODUCT_MODEL := Odys Space
PRODUCT_BRAND := ACTION
PRODUCT_MANUFACTURER := ACTION
