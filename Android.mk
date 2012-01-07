LOCAL_PATH := $(my-dir)

ifeq ($(TARGET_DEVICE),space)
    subdir_makefiles := \
        $(LOCAL_PATH)/recovery/Android.mk

    include $(subdir_makefiles)
endif
