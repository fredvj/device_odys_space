#include <hardware/sensors.h>
#include <fcntl.h>
#include <errno.h>
#include <dirent.h>
#include <math.h>
#include <poll.h>
#include <pthread.h>
#include <linux/input.h>
#include <cutils/atomic.h>
#include <cutils/log.h>
#include <stdlib.h>

#include "bma150_cli/bma150.h"

#define DEBUG_SENSOR	1

#define CONVERT		(GRAVITY_EARTH / 256)
#define CONVERT_X	(CONVERT)
#define CONVERT_Y	-(CONVERT)
#define CONVERT_Z	(CONVERT)

// One event every 200ms / 5Hz

#define EVENT_DELAY	200000

#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))

struct sensors_poll_context_t {
	struct sensors_poll_device_t device;
	int fd;
	int64_t delay;
	int enabled;
};

static int poll__close(struct hw_device_t *dev)
{
	sensors_poll_context_t *spc = (sensors_poll_context_t *)dev;

#ifdef DEBUG_SENSOR
	LOGD("Closing sensor.\n");
#endif

	if(spc) {
		// Close the device

		if(close(spc->fd) != 0) {
			LOGE("Failed to close device!\n");
		}

		// Free the memory

		delete spc;
	}

	return 0;
}

static int poll__activate(struct sensors_poll_device_t *device, int handle, int enabled)
{
	sensors_poll_context_t *spc = (sensors_poll_context_t *)device;

#ifdef DEBUG_SENSOR
	LOGD("activate(enabled:=%d)\n", enabled);
#endif

	spc->enabled = enabled;

	return 0;
}

static int poll__setDelay(struct sensors_poll_device_t *device, int handle, int64_t ns)
{
	sensors_poll_context_t *spc = (sensors_poll_context_t *)device;

#ifdef DEBUG_SENSOR
        LOGD("setDelay(ns:=%ldus)\n", (long) ns / 1000);
#endif

	// Set the new delay - ready to be used with usleep

	spc->delay = ns / 1000;

	return 0;

}

static int poll__poll(struct sensors_poll_device_t *device, sensors_event_t* data, int count)
{
	struct input_event event;
	int ret;
	short bma150_data[8];
	sensors_poll_context_t *spc = (sensors_poll_context_t *)device;

	// If the system disabled this sensor, than take some time off

	if(!spc->enabled) {
#ifdef DEBUG_SENSOR
		LOGD("poll: Sensor disabled\n");
#endif
		// Sleep anyway

		usleep(spc->delay);

		return 0;
	}

#ifdef DEBUG_SENSOR
	LOGD("poll(count:=%d)\n", count);
#endif

	// If we do not have a file handle, there is really nothing we can do

	if (spc->fd < 0) {
#ifdef DEBUG_SENSOR
		LOGD("poll: Device not open\n");
#endif
		return 0;
	}

	// Sleep for a very short moment, just to make sure we do not saturate the OS with too much data

	usleep(spc->delay);

	// Read data from sensor

	if(ioctl(spc->fd, BMA150_READ_ACCEL_XYZ, &bma150_data) != 0) {
#ifdef DEBUG_SENSOR
		LOGE("poll: BMA150_READ_ACCEL_XYZ failed!\n");
#endif
		return 0;
	}

	// x and y are swapped

	// Default range: +/- 2G := +/- 512 (10 bit ADC)
	// 1G ~ 9.81 m/s*s

	data->acceleration.x = bma150_data[1] * CONVERT_X;
	data->acceleration.y = bma150_data[0] * CONVERT_Y;
	data->acceleration.z = bma150_data[2] * CONVERT_Z;

	data->timestamp += spc->delay * 1000;

	data->sensor = 0;
	data->type = SENSOR_TYPE_ACCELEROMETER;
	data->acceleration.status = SENSOR_STATUS_ACCURACY_HIGH;

#ifdef DEBUG_SENSOR
	LOGD("t : x,y,z: %.1f : %f,%f,%f\n",
		data->timestamp / 1000000000.0,
		data->acceleration.x,
		data->acceleration.y,
		data->acceleration.z);
#endif

	return 1;
}


static int open_input_device(void)
{
	int fd = -1;

#ifdef DEBUG_SENSOR
	LOGD("Device := \"%s\"\n", BMA150_NAME);
#endif

	fd = open(BMA150_NAME, O_RDONLY);

	if(fd == -1) {
		LOGE("Failed to open \"%s\"\n", BMA150_NAME);
		return fd;
	}

#ifdef DEBUG_SENSOR
	LOGD("Soft reset\n");
#endif

	if(ioctl(fd, BMA150_SOFT_RESET, NULL) != 0) {
		LOGE("Soft reset failed!\n");
	}

	// The device needs some time to recover after reset

	usleep(300000);

#ifdef DEBUG_SENSOR
	LOGD("File descriptor := %d\n", fd);
#endif

	return fd;
}

static const struct sensor_t sSensorList[] = {

        { 	"BMA020 3-axis accelerometer",
                "Bosch Sensortec GmbH",
                1, 0,
                SENSOR_TYPE_ACCELEROMETER,
		4.0f * GRAVITY_EARTH,
		4.0f * GRAVITY_EARTH / 256.0f,
		0.2f,
		0,
		{ }
	},

};

static int open_sensors(const struct hw_module_t* module,
			const char* name,
			struct hw_device_t** device);

static int sensors__get_sensors_list(struct sensors_module_t* module, struct sensor_t const** list)
{
	*list = sSensorList;

	return ARRAY_SIZE(sSensorList);
}

static struct hw_module_methods_t sensors_module_methods = {
	open : open_sensors
};

extern "C" const struct sensors_module_t HAL_MODULE_INFO_SYM = {
	common :{
		tag : HARDWARE_MODULE_TAG,
		version_major : 1,
		version_minor : 0,
		id : SENSORS_HARDWARE_MODULE_ID,
		name : "Odys Space Sensor Module",
		author : "fredvj",
		methods : &sensors_module_methods,
		dso : NULL,
		reserved : {},
	},

	get_sensors_list : sensors__get_sensors_list
};

static int open_sensors(const struct hw_module_t* module,
			const char* name,
			struct hw_device_t** device)
{
	int status = -EINVAL;

	sensors_poll_context_t *dev = new sensors_poll_context_t();
	memset(&dev->device, 0, sizeof(sensors_poll_device_t));

	dev->device.common.tag      = HARDWARE_DEVICE_TAG;
	dev->device.common.version  = 0;
	dev->device.common.module   = const_cast<hw_module_t*>(module);
	dev->device.common.close    = poll__close;
	dev->device.activate        = poll__activate;
	dev->device.setDelay        = poll__setDelay;
	dev->device.poll            = poll__poll;

	dev->fd = open_input_device();
	dev->delay = EVENT_DELAY;
	dev->enabled = 1;
	*device = &dev->device.common;
	status = 0;

	return status;
}
