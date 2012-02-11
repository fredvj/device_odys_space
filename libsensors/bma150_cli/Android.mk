LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

LOCAL_MODULE_TAGS      := optional
LOCAL_ARM_MODE         := arm
LOCAL_SRC_FILES        := bma150_cli.c
LOCAL_SHARED_LIBRARIES := liblog libcutils
LOCAL_MODULE           := bma150_cli

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_MODULE_TAGS      := optional
LOCAL_ARM_MODE         := arm
LOCAL_SRC_FILES        := bma150_calibrate.c
LOCAL_SHARED_LIBRARIES := liblog libcutils
LOCAL_MODULE           := bma150_calibrate

include $(BUILD_EXECUTABLE)
