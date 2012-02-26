USE_CAMERA_STUB := false

# inherit from the proprietary version
-include vendor/odys/space/BoardConfigVendor.mk

TARGET_NO_BOOTLOADER := true
TARGET_NO_RADIOIMAGE := true
TARGET_BOARD_PLATFORM := msm7k
TARGET_ARCH_VARIANT := armv6-vfp
TARGET_CPU_ABI := armeabi
TARGET_CPU_ABI := armeabi-v6l
TARGET_CPU_ABI2 := armeabi

# Let us try to allow recovery to flash old images
TARGET_PRODUCT_NAME := msm7627_ffa
TARGET_PRODUCT_DEVICE := msm7627_ffa
TARGET_PRODUCT_BOARD := 7x27

TARGET_BOARD_PLATFORM_GPU := qcom-adreno200
TARGET_BOOTLOADER_BOARD_NAME := space

WIFI_DRIVER_MODULE_NAME     := libra
WIFI_DRIVER_MODULE_PATH     := /system/lib/modules/libra.ko
WIFI_PRE_LOADER             := wifipreloader

BOARD_WPA_SUPPLICANT_DRIVER := WEXT
WPA_SUPPLICANT_VERSION      := VER_0_6_X

HOSTAPD_VERSION             := VER_0_6_X
BOARD_WLAN_DEVICE           := wlan0


JS_ENGINE := v8

BOARD_NO_RGBX_8888 := true
TARGET_USES_16BPPSURFACE_FOR_OPAQUE := true
TARGET_LIBAGL_USE_GRALLOC_COPYBITS := true
BOARD_AVOID_DRAW_TEXTURE_EXTENSION := true

BOARD_EGL_CFG := device/odys/space/egl.cfg

# BOARD_USE_FROYO_LIBCAMERA := true
BOARD_USE_CAF_LIBCAMERA := true

BOARD_HAVE_BLUETOOTH := true

BOARD_USES_QCOM_HARDWARE := true
BOARD_USES_QCOM_LIBS := true
BOARD_USES_QCOM_LIBRPC := true

# See above - BOARD_USES_QCOM_HARDWARE := true
# See above - BOARD_USES_QCOM_LIBS := true
BOARD_USES_QCOM_GPS := true
BOARD_VENDOR_QCOM_GPS_LOC_API_HARDWARE := msm7k
BOARD_VENDOR_QCOM_GPS_LOC_API_AMSS_VERSION := 50000
BOARD_GPS_NEEDS_XTRA := true

BOARD_HAS_SDCARD_INTERNAL := true
BOARD_USE_USB_MASS_STORAGE_SWITCH := true
TARGET_USE_CUSTOM_LUN_FILE_PATH := /sys/devices/platform/msm_hsusb/gadget/lun
BOARD_UMS_LUNFILE := "/sys/devices/platform/msm_hsusb/gadget/lun0/file"
BOARD_CUSTOM_USB_CONTROLLER := ../../device/odys/space/UsbController.cpp

TARGET_PROVIDES_LIBRIL := true
TARGET_PROVIDES_LIBAUDIO := true

# The name of the init file can be controlled from the kernel command line
# androidboot.hardware=qcom will result in init calling init.qcom.rc in addition to init.rc

BOARD_KERNEL_CMDLINE := mem=212M console=ttyMSM2 androidboot.hardware=qcom
# BOARD_KERNEL_BASE := 0x00200000
BOARD_KERNEL_BASE := 0x00208000
BOARD_KERNEL_PAGESIZE := 2048

# # cat /proc/mtd on Odys Space
# dev:    size   erasesize  name 
# mtd0: 00500000 00020000 "boot" 
# mtd1: 09600000 00020000 "system" 
# mtd2: 00100000 00020000 "splash" 
# mtd3: 02300000 00020000 "cache" 
# mtd4: 00500000 00020000 "recovery" 
# mtd5: 00180000 00020000 "persist" 
# mtd6: 0ef00000 00020000 "userdata" 

BOARD_BOOTIMAGE_PARTITION_SIZE := 0x00500000
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 0x00500000
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 0x09600000
BOARD_USERDATAIMAGE_PARTITION_SIZE := 0x0ef00000
BOARD_FLASH_BLOCK_SIZE := 131072

TARGET_PREBUILT_KERNEL := device/odys/space/prebuilt/kernel

BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../device/odys/space/recovery/space_recovery_ui.c
TARGET_RECOVERY_INITRC := device/odys/space/recovery/recovery.rc

