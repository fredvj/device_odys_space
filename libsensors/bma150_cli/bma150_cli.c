/*
 * Command line utility to read data from /dev/bma150 on Odys Space
 * 2012, Quick and dirty
 */

#include <fcntl.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>

#include "bma150.h"

int main(int argc, char **argv)
{
 int fd, i;
 unsigned char buffer[6];
 short bma150_data[8];
 float x, y, z;

 printf("Opening \"%s\" ... ", BMA150_NAME);

 fd = open(BMA150_NAME, O_RDWR);

 if(fd == -1)
  printf("failed\n");
 else
  printf("okay\n");

 printf("Soft reset ... ");

 if(ioctl(fd, BMA150_SOFT_RESET, NULL) == 0)
  printf("okay\n");
 else
  printf("failed\n");

 usleep(500000);

 if(ioctl(fd, BMA150_READ_TEMPERATURE, &buffer) == 0)
  printf("Current temperature := %d\n", (unsigned char)buffer[0]);

 for(i=0; i<20; i++) {
  // Acceleration data

  usleep(500000);

  if(ioctl(fd, BMA150_READ_ACCEL_XYZ, &bma150_data) != 0)
   printf("Reading acceleration data failed\n");

  // x and y are swapped

  x = bma150_data[1];
  y = bma150_data[0] * -1.0f;
  z = bma150_data[2];

  printf("(x,y,z) := (%3.0f,%3.0f,%3.0f)\n", x, y, z);
 }

 printf("Closing \"%s\" ... ", BMA150_NAME);

 if(close(fd) == 0)
  printf("okay\n");
 else
  printf("failed\n");

 return 0;
}
