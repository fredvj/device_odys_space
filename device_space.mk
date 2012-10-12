$(call inherit-product, build/target/product/full.mk)
$(call inherit-product, build/target/product/languages_small.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_eu_supl.mk)

$(call inherit-product-if-exists, vendor/odys/space/space-vendor-blobs.mk)

DEVICE_PACKAGE_OVERLAYS += device/odys/space/overlay

PRODUCT_PACKAGES += \
	Gallery \
	LiveWallpapers \
	LiveWallpapersPicker \
	SpareParts \
	Development \
	Term

# This is the list of libraries to include in the build
# Sensors are ours
# Lights coming from hardware/msm7k/liblights

PRODUCT_PACKAGES += \
	sensors.msm7k \
	lights.msm7k \
	copybit.7x27 \
	gralloc.7x27 \
	gps.msm7k \
	libcamera \
	libaudio \
	libOmxCore \
	libOmxVidEnc \
	libRS \
	librs_jni \
	dexpreopt \
	rzscontrol \
	screencap

DISABLE_DEXPREOPT := false

# Recovery tools

PRODUCT_PACKAGES += \
	flash_image \
	dump_image \
	erase_image \
	make_ext4fs \
	e2fsck

# A kernel seems like a good start

ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := device/odys/space/prebuilt/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif


PRODUCT_COPY_FILES += \
	$(LOCAL_KERNEL):kernel

# Install device features

PRODUCT_COPY_FILES += \
	packages/wallpapers/LivePicker/android.software.live_wallpaper.xml:/system/etc/permissions/android.software.live_wallpaper.xml \
	frameworks/base/data/etc/handheld_core_hardware.xml:system/etc/permissions/handheld_core_hardware.xml \
	frameworks/base/data/etc/android.hardware.camera.autofocus.xml:system/etc/permissions/android.hardware.camera.autofocus.xml \
	frameworks/base/data/etc/android.hardware.telephony.cdma.xml:system/etc/permissions/android.hardware.telephony.cdma.xml \
	frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
	frameworks/base/data/etc/android.software.sip.voip.xml:system/etc/permissions/android.software.sip.voip.xml \
	frameworks/base/data/etc/android.hardware.location.xml:system/etc/permissions/android.hardware.location.xml \
	frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
	frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	frameworks/base/data/etc/android.hardware.sensor.accelerometer.xml:system/etc/permissions/android.hardware.sensor.accelerometer.xml \
	frameworks/base/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml \
	frameworks/base/data/etc/android.hardware.touchscreen.multitouch.distinct.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.distinct.xml \
	frameworks/base/data/etc/android.hardware.usb.accessory.xml:system/etc/permissions/android.hardware.usb.accessory.xml

# Boot logo

PRODUCT_COPY_FILES += \
	device/odys/space/prebuilt/initlogo.rle:root/initlogo.rle

# APNS / SPN
#
# It looks like Cyanogen has more power - apns-conf.xml gets overwritten by
# development/data/etc/apns-conf.xml
#
# Start here and edit:
# vendor/cyanogen/prebuilt/etc/apns-conf.xml
# copy to:
# development/data/etc/apns-conf.xml
#
# Do not edit here (would result in duplicate entries):
# frameworks/base/core/res/res/xml/apns.xml

PRODUCT_COPY_FILES += \
	device/odys/space/prebuilt/apns-conf.xml:system/etc/apns-conf.xml \
	device/odys/space/prebuilt/spn-conf.xml:system/etc/spn-conf.xml

# Startup scripts
# If we would like to name it init.space.rc, we would have to change the kernel parameter

# Damned. init honors the kernel command line. ueventd does not.
# This lets it fall back to ask util.c for get_hardware_name.
# This in turn will parse /proc/cpuinfo - on our platform:
# Hardware	: QCT MSM7x27 FFA
# If I get it right, get_hardware_name(...) := "qct"

PRODUCT_COPY_FILES += \
	device/odys/space/boot.space.rc:root/init.qcom.rc \
	device/odys/space/ueventd.space.rc:root/ueventd.qct.rc

# Configuration files

PRODUCT_COPY_FILES += \
	device/odys/space/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
	device/odys/space/configuration/dhcpcd.conf:system/etc/dhcpcd/dhcpcd.conf \
	device/odys/space/configuration/AudioFilter.csv:system/etc/AudioFilter.csv \
	device/odys/space/configuration/AutoVolumeControl.txt:system/etc/AutoVolumeControl.txt \
	device/odys/space/vold.fstab:system/etc/vold.fstab \
	device/odys/space/media_profiles.xml:system/etc/media_profiles.xml \
	device/odys/space/init.bt.sh:system/etc/init.bt.sh \
	device/odys/space/configuration/bluetooth.addr:system/etc/bluetooth/bluetooth.addr

# Additional kernel modules

PRODUCT_COPY_FILES += \
	device/odys/space/prebuilt/tun.ko:system/lib/modules/tun.ko \
	device/odys/space/prebuilt/slow-work.ko:system/lib/modules/slow-work.ko \
	device/odys/space/prebuilt/cifs.ko:system/lib/modules/cifs.ko


PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := odys_space
PRODUCT_DEVICE := space
PRODUCT_MODEL := Odys Space
PRODUCT_BRAND := ACTION
PRODUCT_MANUFACTURER := ACTION

# Generate descriptive build.id
DISPLAY_BUILD_NUMBER := true
