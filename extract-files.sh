#!/bin/sh

mkdir -p ../../../vendor/odys/space/proprietary
PROPS=../../../vendor/odys/space/proprietary/
mkdir -p $PROPS/modules
mkdir -p $PROPS/hw
mkdir -p $PROPS/egl
mkdir -p $PROPS/bluez-plugin
mkdir -p etc

echo "Please connect your phone to USB"
echo -n "Waiting ... "
adb wait-for-device
echo "phone connected. Pulling files"

# echo "    -------------------- Wifi AR6002 firmware files..."
# for f in athwlan.bin.z77 data.patch.hw2_0.bin eeprom.bin;
# 	do adb pull /system/etc/wifi/fw/$f $PROPS
# done

echo "    -------------------- Kernel modules"
for f in libra_ftm.ko libra.ko librasdioif.ko
	do adb pull /system/lib/modules/$f $PROPS/modules
done

echo "    -------------------- Hardware libraries"
for f in copybit.msm7k.so gralloc.msm7k.so lights.msm7k.so sensors.7x27.so
	do adb pull /system/lib/hw/$f $PROPS/hw
done

echo "    -------------------- Graphic hardware"
for f in libGLESv1_CM_adreno200.so libGLESv2_adreno200.so libEGL_adreno200.so libq3dtools_adreno200.so
	do adb pull /system/lib/egl/$f $PROPS/egl
done

echo "    -------------------- Bluez Plugin"
for f in input.so audio.so
	do adb pull /system/lib/bluez-plugin/$f $PROPS/bluez-plugin
done

echo "    -------------------- Bluetooth helpers"
adb pull /system/bin/hci_qcomm_init $PROPS
adb pull /system/bin/hciattach $PROPS

echo "    -------------------- Radio and associated libraries"
for f in libcm.so libdsm.so libdss.so libgsdi_exp.so libgstk_exp.so libmmgsdilib.so libnv.so liboem_rapi.so liboncrpc.so libqmi.so libqueue.so libril-qc-1.so libwms.so libwmsts.so libsnd.so
	do adb pull /system/lib/$f $PROPS
done

# frevj: Not using this file ??? libril-qcril-hook-oem.so libril.so

echo "    -------------------- Camera control and encoding libraries"
# for f in libmmcamera.so libmmcamera_target.so libmmjpeg.so
for f in libcamera.so liboemcamera.so libcamera_client.so libcameraservice.so libmmjpeg.so
	do adb pull /system/lib/$f $PROPS
done

echo "    -------------------- Media libraries"
for f in libmm-adspsvc.so libOmxH264Dec.so libOmxMpeg4Dec.so libOmxVidEnc.so
	do adb pull /system/lib/$f $PROPS
done

echo "    -------------------- GPS library"
adb pull /system/lib/libgps.so $PROPS

echo "    -------------------- Missing /system/etc/bluetooth"
echo "    -------------------- Missing /system/etc/firmware"
echo "    -------------------- Missing /system/etc/firmware/wlan"

# /system/etc:
# init.qcom.bt.sh
# init.qcom.coex.sh
# init.qcom.fm.sh
# init.qcom.post_boot.sh
# init.qcom.sdio.sh
# init.qcom.wifi.sh

echo "    -------------------- Android 2.2.2 init scripts"
for f in init.qcom.bt.sh init.qcom.coex.sh init.qcom.fm.sh init.qcom.post_boot.sh init.qcom.sdio.sh init.qcom.wifi.sh
	do adb pull /system/etc/$f etc/
done

# /init.qcom.rc

adb pull /init.qcom.rc .

echo "    -------------------- DONE. check the above lines for errors"
