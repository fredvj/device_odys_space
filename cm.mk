# First, set the baseband technology
$(call inherit-product, vendor/cm/config/gsm.mk)

# Inherit some common cyanogenmod stuff.
$(call inherit-product, vendor/cm/config/common_mini_phone.mk)
# $(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/odys/space/full_space.mk)

# Include Qualcomm open source features
$(call inherit-product, vendor/qcom/opensource/omx/mm-core/Android.mk)
$(call inherit-product, vendor/qcom/opensource/omx/mm-video/Android.mk)

#
# Setup device specific product configuration.
#
PRODUCT_NAME := cm_space

# Release name
PRODUCT_RELEASE_NAME := OdysSpace
PRODUCT_VERSION_DEVICE_SPECIFIC := I700T

# Versioning
-include vendor/cm/config/common_versions.mk

PRODUCT_DEVICE := space

