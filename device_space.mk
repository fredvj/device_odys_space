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
PRODUCT_PACKAGES += \
	sensors.space \
	lights.space \
	copybit.space \
	gralloc.space \
	gps.space \
	libRS \
	librs_jni \
	libOmxCore \
	libOmxVidEnc \
	dexpreopt

DISABLE_DEXPREOPT := false

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

# Keyboard layouts don't hurt

# PRODUCT_COPY_FILES += \
# 	device/odys/space/prebuilt/7k_ffa_keypad.kl:system/usr/keylayout/7k_ffa_keypad.kl \
# 	device/odys/space/prebuilt/7k_ffa_tp_keypad.kl:system/usr/keylayout/7k_ffa_tp_keypad.kl \
# 	device/odys/space/prebuilt/7k_handset.kl:system/usr/keylayout/7k_handset.kl \
# 	device/odys/space/prebuilt/AVRCP.kl:system/usr/keylayout/AVRCP.kl \
# 	device/odys/space/prebuilt/qwerty.kl:system/usr/keylayout/qwerty.kl \
# 	device/odys/space/prebuilt/7k_ffa_keypad.kcm.bin:system/usr/keychars/7k_ffa_keypad.kcm.bin \
# 	device/odys/space/prebuilt/qwerty2.kcm.bin:system/usr/keychars/qwerty2.kcm.bin \
# 	device/odys/space/prebuilt/qwerty.kcm.bin:system/usr/keychars/qwerty.kcm.bin

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

# APNS

PRODUCT_COPY_FILES += \
	device/odys/space/prebuilt/apns-conf.xml:system/etc/apns-conf.xml

# Startup scripts
# If would like to name it init.space.rc, we would have to change the kernel parameter

# Ouch. init honors the kernel command line. ueventd does not.
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
	device/odys/space/vold.fstab:system/etc/vold.fstab

# 	device/odys/space/media_profiles.xml:system/etc/media_profiles.xml

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
	vendor/odys/space/proprietary/libdll.so:system/lib/libdll.so \
	vendor/odys/space/proprietary/libgsdi_exp.so:system/lib/libgsdi_exp.so \
	vendor/odys/space/proprietary/libgstk_exp.so:system/lib/libgstk_exp.so \
	vendor/odys/space/proprietary/libmmgsdilib.so:system/lib/libmmgsdilib.so \
	vendor/odys/space/proprietary/libnv.so:system/lib/libnv.so \
	vendor/odys/space/proprietary/liboem_rapi.so:system/lib/liboem_rapi.so \
	vendor/odys/space/proprietary/liboncrpc.so:system/lib/liboncrpc.so \
	vendor/odys/space/proprietary/libqmi.so:system/lib/libqmi.so \
	vendor/odys/space/proprietary/libqueue.so:system/lib/libqueue.so \
	vendor/odys/space/proprietary/libril-qc-1.so:system/lib/libril-qc-1.so \
	vendor/odys/space/proprietary/libril-qcril-hook-oem.so:system/lib/libril-qcril-hook-oem.so \
	vendor/odys/space/proprietary/libwms.so:system/lib/libwms.so \
	vendor/odys/space/proprietary/libwmsts.so:system/lib/libwmsts.so \
	vendor/odys/space/proprietary/libsnd.so:system/lib/libsnd.so \
	vendor/odys/space/proprietary/libdiag.so:system/lib/libdiag.so \
	vendor/odys/space/proprietary/libauth.so:system/lib/libauth.so \
	vendor/odys/space/proprietary/libpbmlib.so:system/lib/libpbmlib.so \
	vendor/odys/space/proprietary/libdsutils.so:system/lib/libdsutils.so \
	vendor/odys/space/proprietary/libnetmgr.so:system/lib/libnetmgr.so

# PRODUCT_COPY_FILES += \
#         vendor/odys/space/proprietary/libdsm.so:system/lib/libdsm.so \
#         vendor/odys/space/proprietary/liboncrpc.so:system/lib/liboncrpc.so \
#         vendor/odys/space/proprietary/libril-qc-1.so:system/lib/libril-qc-1.so \
#         vendor/odys/space/proprietary/libril-qcril-hook-oem.so:system/lib/libril-qcril-hook-oem.so \
#         vendor/odys/space/proprietary/libdiag.so:system/lib/libdiag.so

# Camera control and encoding libraries

# Build environment (obj)

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/liboemcamera.so:obj/lib/liboemcamera.so

# Target

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/liboemcamera.so:system/lib/liboemcamera.so \
	vendor/odys/space/proprietary/libmmjpeg.so:system/lib/libmmjpeg.so \
	vendor/odys/space/proprietary/libmmipl.so:system/lib/libmmipl.so

# Media libraries

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/libOmxAacDec.so:system/lib/libOmxAacDec.so \
	vendor/odys/space/proprietary/libOmxAacEnc.so:system/lib/libOmxAacEnc.so \
	vendor/odys/space/proprietary/libOmxAdpcmDec.so:system/lib/libOmxAdpcmDec.so \
	vendor/odys/space/proprietary/libOmxAmrDec.so:system/lib/libOmxAmrDec.so \
	vendor/odys/space/proprietary/libOmxAmrEnc.so:system/lib/libOmxAmrEnc.so \
	vendor/odys/space/proprietary/libOmxAmrRtpDec.so:system/lib/libOmxAmrRtpDec.so \
	vendor/odys/space/proprietary/libOmxAmrwbDec.so:system/lib/libOmxAmrwbDec.so \
	vendor/odys/space/proprietary/libOmxEvrcEnc.so:system/lib/libOmxEvrcEnc.so \
	vendor/odys/space/proprietary/libOmxH264Dec.so:system/lib/libOmxH264Dec.so \
	vendor/odys/space/proprietary/libOmxMp3Dec.so:system/lib/libOmxMp3Dec.so \
	vendor/odys/space/proprietary/libOmxMpeg4Dec.so:system/lib/libOmxMpeg4Dec.so \
	vendor/odys/space/proprietary/libOmxQcelp13Enc.so:system/lib/libOmxQcelp13Enc.so \
	vendor/odys/space/proprietary/libOmxVidEnc.so:system/lib/libOmxVidEnc.so \
	vendor/odys/space/proprietary/libOmxWmaDec.so:system/lib/libOmxWmaDec.so \
	vendor/odys/space/proprietary/libOmxWmvDec.so:system/lib/libOmxWmvDec.so \
	vendor/odys/space/proprietary/libmm-adspsvc.so:system/lib/libmm-adspsvc.so \
	vendor/odys/space/proprietary/libomx_aacdec_sharedlibrary.so:system/lib/libomx_aacdec_sharedlibrary.so \
	vendor/odys/space/proprietary/libomx_amrdec_sharedlibrary.so:system/lib/libomx_amrdec_sharedlibrary.so \
	vendor/odys/space/proprietary/libomx_amrenc_sharedlibrary.so:system/lib/libomx_amrenc_sharedlibrary.so \
	vendor/odys/space/proprietary/libomx_avcdec_sharedlibrary.so:system/lib/libomx_avcdec_sharedlibrary.so \
	vendor/odys/space/proprietary/libomx_m4vdec_sharedlibrary.so:system/lib/libomx_m4vdec_sharedlibrary.so \
	vendor/odys/space/proprietary/libomx_mp3dec_sharedlibrary.so:system/lib/libomx_mp3dec_sharedlibrary.so \
	vendor/odys/space/proprietary/libomx_sharedlibrary.so:system/lib/libomx_sharedlibrary.so


# GPS library

# Built environment (obj)

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/libloc.so:obj/lib/libloc.so

# Target

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/libloc.so:system/lib/libloc.so \
	vendor/odys/space/proprietary/libloc-rpc.so:system/lib/libloc-rpc.so \
	vendor/odys/space/proprietary/libcommondefs.so:system/lib/libcommondefs.so


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
# has to end up in /data/hostapd - who is copying ?

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/prebuilt/qcom_cfg.ini:system/etc/wifi/qcom_cfg.ini \
	vendor/odys/space/proprietary/prebuilt/hostapd.conf:system/etc/wifi/hostapd.conf

# Service and additional init script

PRODUCT_COPY_FILES += \
	vendor/odys/space/proprietary/etc/init.qcom.bt.sh:system/etc/init.qcom.bt.sh \
	vendor/odys/space/proprietary/etc/init.qcom.coex.sh:system/etc/init.qcom.coex.sh \
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
	vendor/odys/space/proprietary/prebuilt/wiperiface:system/bin/wiperiface \
	vendor/odys/space/proprietary/prebuilt/rmt_storage:system/bin/rmt_storage \
	vendor/odys/space/proprietary/prebuilt/netmgrd:system/bin/netmgrd


PRODUCT_BUILD_PROP_OVERRIDES += BUILD_UTC_DATE=0
PRODUCT_NAME := odys_space
PRODUCT_DEVICE := space
PRODUCT_MODEL := Odys Space
PRODUCT_BRAND := ACTION
PRODUCT_MANUFACTURER := ACTION

# Generate descriptive build.id
DISPLAY_BUILD_NUMBER := true
