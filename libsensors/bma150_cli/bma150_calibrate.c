/*
 * Command line utility to read data from /dev/bma150 on Odys Space
 * 2012, Quick and dirty
 */

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <hardware/sensors.h>

#include "bma150.h"

#define CONVERT (GRAVITY_EARTH / 256)

#define CALIBRATION_CYCLES	20

int main(int argc, char **argv)
{
 int fd, i, dot;
 unsigned char buffer[6];
 short bma150_data[8];
 float x, y, z, zr;
 struct bma150_calibration_data bcd = {
	BMA150_CALIBRATION_VERSION,
	0.0f,
	0.0f,
	0.0f
 };

 printf("##############################\n");
 printf("#                            #\n");
 printf("# Manual calibration utility #\n");
 printf("# Bosch Sensortec devices:   #\n");
 printf("# BMA020/BMA150/SMB380       #\n");
 printf("#                            #\n");
 printf("# 2012, fredvj               #\n");
 printf("#                            #\n");
 printf("##############################\n\n");

 printf("Opening \"%s\" ... ", BMA150_NAME);

 fd = open(BMA150_NAME, O_RDONLY);

 if(fd == -1) {
   printf("failed\n");
   return 1;
  }
 else
  printf("okay\n");

 printf("Soft reset ... ");

 if(ioctl(fd, BMA150_SOFT_RESET, NULL) == 0)
  printf("okay\n");
 else {
   printf("failed\n");
   return 1;
  }

 printf("\n");
 sleep(1);

 // Let us assume we are on planet earth
 
 // Wait for device to lie somewhere on a table, display heading to the sky

 printf("Please put your device on a table. Display heading to the sky.\n");
 printf("Waiting ... ");

 bma150_data[2] = 0;

 while(bma150_data[2] < 200)
  {
   if(ioctl(fd, BMA150_READ_ACCEL_XYZ, &bma150_data) != 0) {
    printf("error reading data from device ... exiting.\n\n");
    return 1;
   }
  }

 printf("thanks!\n\n");

 // Wait two second and read z-value

 sleep(2);

 if(ioctl(fd, BMA150_READ_ACCEL_XYZ, &bma150_data) != 0) {
  printf("Error reading baseline data from device ... exiting.\n\n");
  return 1;
 }

 zr = bma150_data[2];

 printf("Now, please turn the device around.\n");
 printf("Display flat on tables surface, please.\n\n");
 printf("Once this is done, I will wait 3 seconds\n");
 printf("and start the calibration process.\n\n");
 printf("Waiting ... ");

 while(bma150_data[2] > -200)
  {
   if(ioctl(fd, BMA150_READ_ACCEL_XYZ, &bma150_data) != 0) {
    printf("error reading data from device ... exiting.\n\n");
    return 1;
   }
  }

 printf("thanks!\n\n");

 printf("Waiting ... ");
 sleep(1);
 printf("1\n");
 sleep(1);
 printf("Waiting ... 2\n");
 sleep(1);
 printf("Waiting ... 3\n\n");

 printf("Calibration about to begin!\n\n");

 x = y = z = 0.0f;

 for(i=0; i<CALIBRATION_CYCLES; i++) {
  // Acceleration data

  usleep(200000);

  if(ioctl(fd, BMA150_READ_ACCEL_XYZ, &bma150_data) != 0)
   printf("Reading acceleration data failed\n");

  // x and y are swapped

  // Default range: +/- 2G := +/- 512 (10 bit ADC)
  // 1G ~ 9.81 m/s*s

  x += bma150_data[1];
  y += bma150_data[0] * -1.0f;
  z += bma150_data[2];

  // Show progress

  for(dot=0; dot<=i; dot++) {
    printf(".");
   }
  printf("\n"); 
 }

 printf("\nDone.\n\n");

 bcd.offset_x = (x / CALIBRATION_CYCLES) * -1.0f;
 bcd.offset_y = (y / CALIBRATION_CYCLES) * -1.0f;
 bcd.offset_z = zr + (z / CALIBRATION_CYCLES);

 printf("Calculated offsets are := {%.0f, %.0f, %.0f}\n\n", 
	bcd.offset_x,
	bcd.offset_y,
	bcd.offset_z);

 printf("Closing \"%s\" ... ", BMA150_NAME);

 if(close(fd) == 0)
  printf("okay\n");
 else {
   printf("failed\n");
   return 1;
  }

 return 0;
}
