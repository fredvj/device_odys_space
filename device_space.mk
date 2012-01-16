$(call inherit-product, build/target/product/full.mk)
$(call inherit-product, build/target/product/languages_small.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_eu_supl.mk)

$(call inherit-product-if-exists, vendor/odys/space/space-vendor.mk)

DEVICE_PACKAGE_OVERLAYS += device/odys/space/overlay

# PRODUCT_PACKAGES += \
# 	Gallery \
# 	LiveWallpapers \
# 	LiveWallpapersPicker \
# 	VisualizationWallpapers \
# 	MagicSmokeWallpapers \
# 	SpareParts \
# 	Development \
# 	Term

# This is the list of libraries to include in the build
PRODUCT_PACKAGES += \
	sensors.space \
	lights.space \
	copybit.space \
	gralloc.space \
#	gps.space \
	libRS \
	librs_jni \
	libOmxCore \
	libOmxVidEnc


PRODUCT_PROPERTY_OVERRIDES += \
	rild.libpath=/system/lib/libril-qc-1.so \
	rild.libargs=-d /dev/smd0 \
	wifi.interface=wlan0 \
	wifi.supplicant_scan_interval=15 \
	ro.com.android.dataroaming=false \
	keyguard.no_require_sim=true \
	ro.ril.hsxpa=2 \
	ro.ril.gprsclass=10 \
#	ro.build.baseband_version=P729BB01 \
	ro.telephony.default_network=0 \
	ro.telephony.call_ring.multiple=false \
#	ro.sf.lcd_density=160 \
	ro.opengles.version=131072  \
	ro.compcache.default=0

# This would be the way to rotate the screen
# But the touchscreen would be missing

# PRODUCT_PROPERTY_OVERRIDES += \
# 	ro.sf.hwrotation=270


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
	frameworks/base/data/etc/android.hardware.telephony.gsm.xml:system/etc/permissions/android.hardware.telephony.gsm.xml \
	frameworks/base/data/etc/android.hardware.location.gps.xml:system/etc/permissions/android.hardware.location.gps.xml \
	frameworks/base/data/etc/android.hardware.wifi.xml:system/etc/permissions/android.hardware.wifi.xml \
	frameworks/base/data/etc/android.hardware.sensor.proximity.xml:system/etc/permissions/android.hardware.sensor.proximity.xml \
	frameworks/base/data/etc/android.hardware.sensor.light.xml:system/etc/permissions/android.hardware.sensor.light.xml \
	frameworks/base/data/etc/android.hardware.touchscreen.multitouch.xml:system/etc/permissions/android.hardware.touchscreen.multitouch.xml


# Boot logo

# PRODUCT_COPY_FILES += \
# 	device/odys/space/prebuilt/initlogo.rle:root/initlogo.rle

# Startup scripts
# If would like to name it init.space.rc, we would have to change the kernel parameter

PRODUCT_COPY_FILES += \
	device/odys/space/boot.space.rc:root/init.qcom.rc \
	device/odys/space/ueventd.space.rc:root/ueventd.qcom.rc

# Configuration files

PRODUCT_COPY_FILES += \
	device/odys/space/wpa_supplicant.conf:system/etc/wifi/wpa_supplicant.conf \
	device/odys/space/AudioFilter.csv:system/etc/AudioFilter.csv \
	device/odys/space/AutoVolumeControl.txt:system/etc/AutoVolumeControl.txt \
	device/odys/space/vold.fstab:system/etc/vold.fstab \
	device/odys/space/media_profiles.xml:system/etc/media_profiles.xml

# Proprietary files - BLOBS

PRODUCT_COPY_FILES += \
	device/odys/space/recovery/battery_charging:system/bin/battery_charging

# Reinject files extracted from old system

# Kernel modules

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/modules/libra_ftm.ko:system/lib/modules/libra_ftm.ko \
	vendor/odys/space/proprietary/modules/libra.ko:system/lib/modules/libra.ko \
	vendor/odys/space/proprietary/modules/librasdioif.ko:system/lib/modules/librasdioif.ko

# Hardware libraries

# copybit, gralloc and lights are not copied due to warnings

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/hw/copybit.msm7k.so:system/lib/hw/copybit.msm7k.so \
	vendor/odys/space/proprietary/hw/gralloc.msm7k.so:system/lib/hw/gralloc.msm7k.so \
	vendor/odys/space/proprietary/hw/lights.msm7k.so:system/lib/hw/lights.msm7k.so \
	vendor/odys/space/proprietary/hw/sensors.7x27.so:system/lib/hw/sensors.7x27.so


# Graphic hardware

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/egl/libGLESv1_CM_adreno200.so:system/lib/egl/libGLESv1_CM_adreno200.so \
	vendor/odys/space/proprietary/egl/libGLESv2_adreno200.so:system/lib/egl/libGLESv2_adreno200.so \
	vendor/odys/space/proprietary/egl/libEGL_adreno200.so:system/lib/egl/libEGL_adreno200.so \
	vendor/odys/space/proprietary/egl/libq3dtools_adreno200.so:system/lib/egl/libq3dtools_adreno200.so \
	vendor/odys/space/proprietary/libgsl.so:system/lib/libgsl.so


# Bluetooth helpers

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/hci_qcomm_init:system/bin/hci_qcomm_init

# Radio and associated libraries

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/libcm.so:system/lib/libcm.so \
	vendor/odys/space/proprietary/libdsm.so:system/lib/libdsm.so \
	vendor/odys/space/proprietary/libdss.so:system/lib/libdss.so \
	vendor/odys/space/proprietary/libgsdi_exp.so:system/lib/libgsdi_exp.so \
	vendor/odys/space/proprietary/libgstk_exp.so:system/lib/libgstk_exp.so \
	vendor/odys/space/proprietary/libmmgsdilib.so:system/lib/libmmgsdilib.so \
	vendor/odys/space/proprietary/libnv.so:system/lib/libnv.so \
	vendor/odys/space/proprietary/liboem_rapi.so:system/lib/liboem_rapi.so \
	vendor/odys/space/proprietary/liboncrpc.so:system/lib/liboncrpc.so \
	vendor/odys/space/proprietary/libqmi.so:system/lib/libqmi.so \
	vendor/odys/space/proprietary/libqueue.so:system/lib/libqueue.so \
	vendor/odys/space/proprietary/libril-qc-1.so:system/lib/libril-qc-1.so \
	vendor/odys/space/proprietary/libwms.so:system/lib/libwms.so \
	vendor/odys/space/proprietary/libwmsts.so:system/lib/libwmsts.so \
	vendor/odys/space/proprietary/libsnd.so:system/lib/libsnd.so \
	vendor/odys/space/proprietary/libdiag.so:system/lib/libdiag.so

# Camera control and encoding libraries

# PRODUCT_COPY_FILES += \
# 	vendor/odys/space/proprietary/liboemcamera.so:system/lib/liboemcamera.so

#	vendor/odys/space/proprietary/libcamera_client.so:system/lib/libcamera_client.so \
#	vendor/odys/space/proprietary/libcameraservice.so:system/lib/libcameraservice.so \
# 	vendor/odys/space/proprietary/libmmjpeg.so:system/lib/libmmjpeg.so

# Media libraries

# PRODUCT_COPY_FILES += \
# 	vendor/odys/space/proprietary/libmm-adspsvc.so:system/lib/libmm-adspsvc.so \
# 	vendor/odys/space/proprietary/libOmxH264Dec.so:system/lib/libOmxH264Dec.so \
# 	vendor/odys/space/proprietary/libOmxMpeg4Dec.so:system/lib/libOmxMpeg4Dec.so \
# 	vendor/odys/space/proprietary/libOmxVidEnc.so:system/lib/libOmxVidEnc.so

# GPS library

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/libgps.so:system/lib/libgps.so


# Firmware

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/prebuilt/yamato_pm4.fw:system/etc/firmware/yamato_pm4.fw \
	vendor/odys/space/proprietary/prebuilt/yamato_pfp.fw:system/etc/firmware/yamato_pfp.fw \
	vendor/odys/space/proprietary/prebuilt/cfg.dat:system/etc/firmware/wlan/cfg.dat \
	vendor/odys/space/proprietary/prebuilt/qcom_wapi_fw.bin:system/etc/firmware/wlan/qcom_wapi_fw.bin \
	vendor/odys/space/proprietary/prebuilt/qcom_fw.bin:system/etc/firmware/wlan/qcom_fw.bin \
	vendor/odys/space/proprietary/prebuilt/qcom_wlan_nv.bin:system/etc/firmware/wlan/qcom_wlan_nv.bin \
	vendor/odys/space/proprietary/prebuilt/qcom_cfg.ini:system/etc/firmware/wlan/qcom_cfg.ini

# HostAPd configuration files

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/prebuilt/qcom_cfg.ini:data/hostapd/qcom_cfg.ini \
	vendor/odys/space/proprietary/prebuilt/hostapd.conf:data/hostapd/hostapd.conf

# Service and additional init script

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/etc/init.qcom.bt.sh:system/etc/init.qcom.bt.sh \
	vendor/odys/space/proprietary/etc/init.qcom.coex.sh:system/etc/init.qcom.coex.sh \
	vendor/odys/space/proprietary/etc/init.qcom.fm.sh:system/etc/init.qcom.fm.sh \
	vendor/odys/space/proprietary/etc/init.qcom.post_boot.sh:system/etc/init.qcom.post_boot.sh \
	vendor/odys/space/proprietary/etc/init.qcom.sdio.sh:system/etc/init.qcom.sdio.sh \
	vendor/odys/space/proprietary/etc/init.qcom.wifi.sh:system/etc/init.qcom.wifi.sh

# And last but not least a couple of prebuilt binaries

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/prebuilt/battery_charging:system/bin/battery_charging \
	vendor/odys/space/proprietary/prebuilt/qmuxd:system/bin/qmuxd \
	vendor/odys/space/proprietary/prebuilt/btwlancoex:system/bin/btwlancoex \
	vendor/odys/space/proprietary/prebuilt/wifiwritemac:system/bin/wifiwritemac \
	vendor/odys/space/proprietary/prebuilt/port-bridge:system/bin/port-bridge \
	vendor/odys/space/proprietary/prebuilt/CKPD-daemon:system/bin/CKPD-daemon \
	vendor/odys/space/proprietary/prebuilt/hostapd:system/bin/hostapd \
	vendor/odys/space/proprietary/prebuilt/fm_qsoc_patches:system/bin/fm_qsoc_patches \
	vendor/odys/space/proprietary/prebuilt/wiperiface:system/bin/wiperiface \
	vendor/odys/space/proprietary/prebuilt/rmt_storage:system/bin/rmt_storage \
	vendor/odys/space/proprietary/prebuilt/netmgrd:system/bin/netmgrd \
	vendor/odys/space/proprietary/prebuilt/wpa_supplicant:system/bin/wpa_supplicant


PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := odys_space
PRODUCT_DEVICE := space
PRODUCT_MODEL := Odys Space
PRODUCT_BRAND := ACTION
PRODUCT_MANUFACTURER := ACTION

# Generate descriptive build.id
DISPLAY_BUILD_NUMBER := true
