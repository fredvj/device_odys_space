USE_CAMERA_STUB := true

# inherit from the proprietary version
-include vendor/odys/space/BoardConfigVendor.mk

TARGET_NO_BOOTLOADER := true
TARGET_BOARD_PLATFORM := msm7k
TARGET_CPU_ABI := armeabi
TARGET_BOOTLOADER_BOARD_NAME := space

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

TARGET_PREBUILT_KERNEL := device/odys/space/kernel

#BOARD_HAS_NO_SELECT_BUTTON := true
# Use this flag if the board has a ext4 partition larger than 2gb
#BOARD_HAS_LARGE_FILESYSTEM := true

BOARD_CUSTOM_RECOVERY_KEYMAPPING := ../../device/odys/space/recovery/space_recovery_ui.c
TARGET_RECOVERY_INITRC := device/odys/space/recovery/recovery.rc
