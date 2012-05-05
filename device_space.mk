$(call inherit-product, build/target/product/full.mk)
$(call inherit-product, build/target/product/languages_small.mk)

# The gps config appropriate for this device
$(call inherit-product, device/common/gps/gps_eu_supl.mk)

$(call inherit-product-if-exists, vendor/odys/space/space-vendor.mk)

# Build the mock-ril
# $(call inherit-product, hardware/ril/mock-ril/Android.mk)

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
	libcamera \
	libaudio \
	libOmxCore \
	libRS \
	librs_jni \
	dexpreopt

DISABLE_DEXPREOPT := false


# A kernel seems like a good start

ifeq ($(TARGET_PREBUILT_KERNEL),)
	LOCAL_KERNEL := device/odys/space/prebuilt/kernel
else
	LOCAL_KERNEL := $(TARGET_PREBUILT_KERNEL)
endif


PRODUCT_COPY_FILES += \
    $(LOCAL_KERNEL):kernel

# Keyboard layouts don't hurt

PRODUCT_COPY_FILES += \
	device/odys/space/prebuilt/7k_ffa_keypad.kl:system/usr/keylayout/7k_ffa_keypad.kl \
	device/odys/space/prebuilt/7k_ffa_tp_keypad.kl:system/usr/keylayout/7k_ffa_tp_keypad.kl \
	device/odys/space/prebuilt/7k_handset.kl:system/usr/keylayout/7k_handset.kl \
	device/odys/space/prebuilt/7k_ffa_keypad.kcm.bin:system/usr/keychars/7k_ffa_keypad.kcm.bin \
	device/odys/space/prebuilt/ft5x0x_ts.idc:system/usr/idc/ft5x0x_ts.idc

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

# Qualcomm permission files & framework extensions ?

PRODUCT_COPY_FILE += \
	device/odys/space/config/com.qualcomm.location.vzw_library.xml:system/etc/permissions/com.qualcomm.location.vzw_library.xml \
	device/odys/space/config/qcnvitems.xml:system/etc/permissions/qcnvitems.xml \
	device/odys/space/config/qcrilhook.xml:system/etc/permissions/qcrilhook.xml \
	device/odys/space/config/com.qualcomm.location.vzw_library.jar:system/framework/com.qualcomm.location.vzw_library.jar \
	device/odys/space/config/qcnvitems.jar:system/framework/qcnvitems.jar \
	device/odys/space/config/qcrilhook.jar:system/framework/qcrilhook.jar


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
	device/odys/space/prebuilt/spn-conf.xml:system/etc/spn-conf.xml \
	device/odys/space/prebuilt/voicemail-conf.xml:system/etc/voicemail-conf.xml

# Startup scripts
# If would like to name it init.space.rc, we would have to change the kernel parameter

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
	device/odys/space/dhcpcd.conf:system/etc/dhcpcd/dhcpcd.conf \
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
	vendor/odys/space/proprietary/233/modules/libra_ftm.ko:system/lib/modules/libra_ftm.ko \
	vendor/odys/space/proprietary/233/modules/libra.ko:system/lib/modules/libra.ko \
	vendor/odys/space/proprietary/233/modules/librasdioif.ko:system/lib/modules/librasdioif.ko \
	device/odys/space/prebuilt/tun.ko:system/lib/modules/tun.ko \
	device/odys/space/prebuilt/slow-work.ko:system/lib/modules/slow-work.ko \
	device/odys/space/prebuilt/cifs.ko:system/lib/modules/cifs.ko

# Hardware libraries

# gralloc are copied from old ROM (the new one is using to much memory?)

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/233/hw/copybit.msm7k.so:system/lib/hw/copybit.msm7k.so \
	vendor/odys/space/proprietary/233/hw/gps.default.so:system/lib/hw/gps.default.so \
	vendor/odys/space/proprietary/233/hw/gralloc.msm7k.so:system/lib/hw/gralloc.msm7k.so \
	vendor/odys/space/proprietary/233/hw/lights.msm7k.so:system/lib/hw/lights.msm7k.so \
	vendor/odys/space/proprietary/233/hw/sensors.default.so:system/lib/hw/sensors.default.so

# Graphic hardware

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/233/egl/libGLESv1_CM_adreno200.so:system/lib/egl/libGLESv1_CM_adreno200.so \
	vendor/odys/space/proprietary/233/egl/libGLESv2_adreno200.so:system/lib/egl/libGLESv2_adreno200.so \
	vendor/odys/space/proprietary/233/egl/libEGL_adreno200.so:system/lib/egl/libEGL_adreno200.so \
	vendor/odys/space/proprietary/233/egl/libq3dtools_adreno200.so:system/lib/egl/libq3dtools_adreno200.so \
	vendor/odys/space/proprietary/233/libgsl.so:system/lib/libgsl.so


# Bluetooth helpers

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/233/hci_qcomm_init:system/bin/hci_qcomm_init \
	device/odys/space/init.bt.sh:system/etc/init.bt.sh \
	device/odys/space/bluetooth.addr:system/etc/bluetooth/bluetooth.addr

# Radio and associated libraries

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/233/libcm.so:system/lib/libcm.so \
	vendor/odys/space/proprietary/233/libdsm.so:system/lib/libdsm.so \
	vendor/odys/space/proprietary/233/libdss.so:system/lib/libdss.so \
	vendor/odys/space/proprietary/233/libgsdi_exp.so:system/lib/libgsdi_exp.so \
	vendor/odys/space/proprietary/233/libgstk_exp.so:system/lib/libgstk_exp.so \
	vendor/odys/space/proprietary/233/libmmgsdilib.so:system/lib/libmmgsdilib.so \
	vendor/odys/space/proprietary/233/libnv.so:system/lib/libnv.so \
	vendor/odys/space/proprietary/233/liboem_rapi.so:system/lib/liboem_rapi.so \
	vendor/odys/space/proprietary/233/liboncrpc.so:system/lib/liboncrpc.so \
	vendor/odys/space/proprietary/233/libqmi.so:system/lib/libqmi.so \
	vendor/odys/space/proprietary/233/libqueue.so:system/lib/libqueue.so \
	vendor/odys/space/proprietary/233/libril-qc-1.so:system/lib/libril-qc-1.so \
	vendor/odys/space/proprietary/233/libril-qcril-hook-oem.so:system/lib/libril-qcril-hook-oem.so \
	vendor/odys/space/proprietary/233/libwms.so:system/lib/libwms.so \
	vendor/odys/space/proprietary/233/libwmsts.so:system/lib/libwmsts.so \
	vendor/odys/space/proprietary/233/libsnd.so:system/lib/libsnd.so \
	vendor/odys/space/proprietary/233/libdiag.so:system/lib/libdiag.so \
	vendor/odys/space/proprietary/233/libauth.so:system/lib/libauth.so \
	vendor/odys/space/proprietary/233/libpbmlib.so:system/lib/libpbmlib.so \
	vendor/odys/space/proprietary/233/libdsutils.so:system/lib/libdsutils.so \
	vendor/odys/space/proprietary/233/libidl.so:system/lib/libidl.so \
	vendor/odys/space/proprietary/233/libril-qc-qmi-1.so:system/lib/libril-qc-qmi-1.so


# 	vendor/odys/space/proprietary/233/libdsutils.so:system/lib/libdsutils.so \
# 	vendor/odys/space/proprietary/233/libnetmgr.so:system/lib/libnetmgr.so


# Camera control and encoding libraries

# Build environment (obj)

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/233/libgps.so:obj/lib/libgps.so

# Target

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/233/libgps.so:system/lib/libgps.so \
	vendor/odys/space/proprietary/233/liboemcamera.so:system/lib/liboemcamera.so \
	vendor/odys/space/proprietary/233/libmmjpeg.so:system/lib/libmmjpeg.so \
	vendor/odys/space/proprietary/233/libmmipl.so:system/lib/libmmipl.so

# Media libraries

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/233/libOmxAacDec.so:system/lib/libOmxAacDec.so \
	vendor/odys/space/proprietary/233/libOmxAacEnc.so:system/lib/libOmxAacEnc.so \
	vendor/odys/space/proprietary/233/libOmxAdpcmDec.so:system/lib/libOmxAdpcmDec.so \
	vendor/odys/space/proprietary/233/libOmxAmrDec.so:system/lib/libOmxAmrDec.so \
	vendor/odys/space/proprietary/233/libOmxAmrEnc.so:system/lib/libOmxAmrEnc.so \
	vendor/odys/space/proprietary/233/libOmxAmrRtpDec.so:system/lib/libOmxAmrRtpDec.so \
	vendor/odys/space/proprietary/233/libOmxAmrwbDec.so:system/lib/libOmxAmrwbDec.so \
	vendor/odys/space/proprietary/233/libOmxEvrcEnc.so:system/lib/libOmxEvrcEnc.so \
	vendor/odys/space/proprietary/233/libOmxH264Dec.so:system/lib/libOmxH264Dec.so \
	vendor/odys/space/proprietary/233/libOmxMp3Dec.so:system/lib/libOmxMp3Dec.so \
	vendor/odys/space/proprietary/233/libOmxMpeg4Dec.so:system/lib/libOmxMpeg4Dec.so \
	vendor/odys/space/proprietary/233/libOmxQcelp13Enc.so:system/lib/libOmxQcelp13Enc.so \
	vendor/odys/space/proprietary/233/libOmxVidEnc.so:system/lib/libOmxVidEnc.so \
	vendor/odys/space/proprietary/233/libOmxWmaDec.so:system/lib/libOmxWmaDec.so \
	vendor/odys/space/proprietary/233/libOmxWmvDec.so:system/lib/libOmxWmvDec.so \
	vendor/odys/space/proprietary/233/libmm-adspsvc.so:system/lib/libmm-adspsvc.so


# Firmware

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/233/prebuilt/yamato_pm4.fw:system/etc/firmware/yamato_pm4.fw \
	vendor/odys/space/proprietary/233/prebuilt/yamato_pfp.fw:system/etc/firmware/yamato_pfp.fw \
	vendor/odys/space/proprietary/233/prebuilt/cfg.dat:system/etc/firmware/wlan/cfg.dat \
	vendor/odys/space/proprietary/233/prebuilt/qcom_wapi_fw.bin:system/etc/firmware/wlan/qcom_wapi_fw.bin \
	vendor/odys/space/proprietary/233/prebuilt/qcom_fw.bin:system/etc/firmware/wlan/qcom_fw.bin \
	vendor/odys/space/proprietary/233/prebuilt/qcom_wlan_nv.bin:system/etc/firmware/wlan/qcom_wlan_nv.bin \
	device/odys/space/qcom_cfg.ini:system/etc/firmware/wlan/qcom_cfg.ini

# HostAPd configuration files
# has to end up in /data/hostapd - who is copying ?

PRODUCT_COPY_FILES += \
	device/odys/space/qcom_cfg.ini:system/etc/wifi/qcom_cfg.ini \
	device/odys/space/hostapd.conf:system/etc/wifi/softap/hostapd.conf

# Service and additional init script

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/233/etc/init.qcom.coex.sh:system/etc/init.qcom.coex.sh \
	vendor/odys/space/proprietary/233/etc/init.qcom.post_boot.sh:system/etc/init.qcom.post_boot.sh \
	vendor/odys/space/proprietary/233/etc/init.qcom.sdio.sh:system/etc/init.qcom.sdio.sh \
	vendor/odys/space/proprietary/233/etc/init.qcom.wifi.sh:system/etc/init.qcom.wifi.sh

# And last but not least a couple of prebuilt binaries

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/233/prebuilt/battery_charging:system/bin/battery_charging \
	vendor/odys/space/proprietary/233/prebuilt/qmuxd:system/bin/qmuxd \
	vendor/odys/space/proprietary/233/prebuilt/btwlancoex:system/bin/btwlancoex \
	vendor/odys/space/proprietary/233/prebuilt/wifiwritemac:system/bin/wifiwritemac \
	vendor/odys/space/proprietary/233/prebuilt/port-bridge:system/bin/port-bridge \
	vendor/odys/space/proprietary/233/prebuilt/netmgrd:system/bin/netmgrd \
	vendor/odys/space/proprietary/233/prebuilt/hostapd:system/bin/hostapd \
	vendor/odys/space/proprietary/233/prebuilt/hostapd_cli:system/bin/hostapd_cli


PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := odys_space
PRODUCT_DEVICE := space
PRODUCT_MODEL := Odys Space
PRODUCT_BRAND := ACTION
PRODUCT_MANUFACTURER := ACTION

# Generate descriptive build.id
DISPLAY_BUILD_NUMBER := true
