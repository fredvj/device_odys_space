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

#define DEBUG_SENSOR	1

#define CONVERT		(GRAVITY_EARTH / 256)
#define CONVERT_X	-(CONVERT)
#define CONVERT_Y	-(CONVERT)
#define CONVERT_Z	(CONVERT)

#define SENSOR_NAME	"fake"
#define INPUT_DIR	"/dev/input"

// One event every 200ms / 5Hz

#define EVENT_DELAY	200000

#define ARRAY_SIZE(a) (sizeof(a) / sizeof(a[0]))

struct sensors_poll_context_t {
	struct sensors_poll_device_t device;
	int fd;
	char class_path[256];
};

static int poll__close(struct hw_device_t *dev)
{
	sensors_poll_context_t *ctx = (sensors_poll_context_t *)dev;
	if (ctx) {
		delete ctx;
	}

	return 0;
}

static int poll__activate(struct sensors_poll_device_t *dev,
        int handle, int enabled) {

	return 0;
}

static int set_sysfs_input_attr(char *class_path,
				const char *attr, char *value, int len)
{
	return 0;
}

static int poll__setDelay(struct sensors_poll_device_t *device,
        int handle, int64_t ns) {

#ifdef DEBUG_SENSOR
        LOGD("Sensor: setDelay(%d)\n", ns);
#endif

	return 0;

}

static int poll__poll(struct sensors_poll_device_t *device,
        sensors_event_t* data, int count) {

	struct input_event event;
	int ret;
	sensors_poll_context_t *dev = (sensors_poll_context_t *)device;

	if (dev->fd < 0)
	return 0;

	// Let us fake some data - max. seems to be 9.81f

	usleep(EVENT_DELAY);

	ret = rand() % (981 * 2);
        data->acceleration.x = (float)(ret-981) / 100.0f;

	ret = rand() % (981 * 2);
        data->acceleration.y = (float)(ret-981) / 100.0f;

	ret = rand() % (981 * 2);
        data->acceleration.z = (float)(ret-981) / 100.0f;

	data->timestamp += EVENT_DELAY * 1000;

	data->sensor = 0;
	data->type = SENSOR_TYPE_ACCELEROMETER;
	data->acceleration.status = SENSOR_STATUS_ACCURACY_HIGH;


#ifdef DEBUG_SENSOR
	LOGD("Sensor: t-x,y,z: %f-%f,%f,%f\n",
		data->timestamp / 1000000000.0,
		data->acceleration.x,
		data->acceleration.y,
		data->acceleration.z);
#endif

	return 1;
}


static int sensor_get_class_path(sensors_poll_context_t *dev)
{
	return 0;
}

static int open_input_device(void)
{
#ifdef DEBUG_SENSOR
	LOGD("devname is %s \n", "fake");
#endif

	return 23;
}

static const struct sensor_t sSensorList[] = {

        { 	"Fake 3-axis accelerometer",
                "Useless Data Inc.",
                1, 0,
                SENSOR_TYPE_ACCELEROMETER,
		4.0f*9.81f,
		(4.0f*9.81f)/256.0f,
		0.2f,
		0,
		{ }
	},

};

static int open_sensors(const struct hw_module_t* module, const char* name,
        struct hw_device_t** device);

static int sensors__get_sensors_list(struct sensors_module_t* module,
        struct sensor_t const** list)
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
		name : "Fake Sensor Module",
		author : "Cryptophon",
		methods : &sensors_module_methods,
		dso : NULL,
		reserved : {},
	},

	get_sensors_list : sensors__get_sensors_list
};

static int open_sensors(const struct hw_module_t* module, const char* name,
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


	if(sensor_get_class_path(dev) < 0) {
		LOGD("g sensor get class path error \n");
	}
	else {
		dev->fd = open_input_device();
		*device = &dev->device.common;
		status = 0;
	}

	return status;
}
