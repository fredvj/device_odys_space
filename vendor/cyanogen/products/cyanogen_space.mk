# Inherit AOSP device configuration for blade.
$(call inherit-product, device/odys/space/device_space.mk)

# Inherit some common cyanogenmod stuff.
$(call inherit-product, vendor/cyanogen/products/common_full.mk)

# Include GSM stuff
$(call inherit-product, vendor/cyanogen/products/gsm.mk)

#
# Setup device specific product configuration.
#
PRODUCT_NAME := cyanogen_space
PRODUCT_BRAND := odys
PRODUCT_DEVICE := space
PRODUCT_MODEL := Space
PRODUCT_MANUFACTURER := Odys
PRODUCT_BUILD_PROP_OVERRIDES += PRODUCT_NAME=space BUILD_ID=0815 BUILD_FINGERPRINT=space:2.3.7/0815/release-keys PRIVATE_BUILD_DESC="Add desc. here"

# Release name and versioning
PRODUCT_RELEASE_NAME := Space
PRODUCT_VERSION_DEVICE_SPECIFIC :=
-include vendor/cyanogen/products/common_versions.mk

#
# Copy legend specific prebuilt files
#
PRODUCT_COPY_FILES +=  \
    vendor/cyanogen/prebuilt/hdpi/media/bootanimation.zip:system/media/bootanimation.zip
