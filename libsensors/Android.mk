LOCAL_PATH := $(call my-dir)

# HAL module implemenation, not prelinked and stored in
# hw/<OVERLAY_HARDWARE_MODULE_ID>.<ro.product.board>.so

include $(CLEAR_VARS)

LOCAL_PRELINK_MODULE   := false
LOCAL_CFLAGS           := -DLOG_TAG=\"Sensors\"
LOCAL_MODULE_PATH      := $(TARGET_OUT_SHARED_LIBRARIES)/hw
LOCAL_SHARED_LIBRARIES := liblog libcutils
LOCAL_SRC_FILES        := sensors.cpp
LOCAL_MODULE           := sensors.$(TARGET_BOARD_PLATFORM)
LOCAL_MODULE_TAGS      := optional

include $(BUILD_SHARED_LIBRARY)
