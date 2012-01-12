LOCAL_PATH := $(my-dir)

ifeq ($(TARGET_DEVICE),space)
#	include $(call all-named-subdir-makefiles, recovery libaudio libril libcamera libgralloc libcopybit libsensors BladeParts liblights)
	include $(call all-named-subdir-makefiles, recovery hwprops)
endif
