LOCAL_PATH := $(call my-dir)

ifeq ($(TARGET_BOOTLOADER_BOARD_NAME),space)
include $(call all-makefiles-under,$(LOCAL_PATH))
# include $(call all-named-subdir-makefiles, recovery)
endif

# LOCAL_PATH := $(my-dir)
#
# ifeq ($(TARGET_DEVICE),space)
# #	include $(call all-named-subdir-makefiles, recovery libaudio libril libcamera libgralloc libcopybit libsensors liblights)
# 	include $(call all-named-subdir-makefiles, recovery)
# endif
