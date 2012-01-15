#!/bin/sh

PROPS=../../../vendor/odys/space/proprietary/

mkdir -p $PROPS
mkdir -p $PROPS/modules
mkdir -p $PROPS/hw
mkdir -p $PROPS/egl
mkdir -p $PROPS/bluez-plugin
mkdir -p $PROPS/etc
mkdir -p $PROPS/etc/bluetooth
mkdir -p $PROPS/prebuilt

echo "Please connect your phone to USB"
echo -n "Waiting ... "
adb wait-for-device
echo "phone connected. Pulling files"

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

echo "    -------------------- Bluetooth helpers"
adb pull /system/bin/hci_qcomm_init $PROPS

echo "    -------------------- Radio and associated libraries"
for f in libcm.so libdsm.so libdss.so libgsdi_exp.so libgstk_exp.so libmmgsdilib.so libnv.so liboem_rapi.so liboncrpc.so libqmi.so libqueue.so libril-qc-1.so libwms.so libwmsts.so libsnd.so libgsl.so libdiag.so
	do adb pull /system/lib/$f $PROPS
done

# frevj: Not using this file ??? libril-qcril-hook-oem.so libril.so

echo "    -------------------- Camera control and encoding libraries"
for f in libcamera.so liboemcamera.so libmmjpeg.so
	do adb pull /system/lib/$f $PROPS
done

echo "    -------------------- Media libraries"
for f in libmm-adspsvc.so libOmxH264Dec.so libOmxMpeg4Dec.so libOmxVidEnc.so
	do adb pull /system/lib/$f $PROPS
done

echo "    -------------------- GPS library"
adb pull /system/lib/libgps.so $PROPS

echo "    -------------------- Firmware"

adb pull /etc/firmware/yamato_pm4.fw $PROPS/prebuilt/
adb pull /etc/firmware/yamato_pfp.fw $PROPS/prebuilt/

echo "    -------------------- WLAN Firmware"

adb pull /persist/qcom_wlan_nv.bin $PROPS/prebuilt/
adb pull /data/hostapd/qcom_cfg.ini $PROPS/prebuilt/

adb pull /etc/firmware/wlan/cfg.dat $PROPS/prebuilt/
adb pull /etc/firmware/wlan/qcom_wapi_fw.bin $PROPS/prebuilt/
adb pull /etc/firmware/wlan/qcom_fw.bin $PROPS/prebuilt/


# /system/etc:
# init.qcom.bt.sh
# init.qcom.coex.sh
# init.qcom.fm.sh
# init.qcom.post_boot.sh
# init.qcom.sdio.sh
# init.qcom.wifi.sh

echo "    -------------------- Android 2.2.2 init scripts"
for f in init.qcom.bt.sh init.qcom.coex.sh init.qcom.fm.sh init.qcom.post_boot.sh init.qcom.sdio.sh init.qcom.wifi.sh 01_qcomm_omx.cfg
	do adb pull /system/etc/$f $PROPS/etc/
done

# /init.qcom.rc

adb pull /init.qcom.rc .

# And the master

adb pull /init.rc init.space.rc

echo "    -------------------- Other prebuilt binaries from Anroid 2.2.2 image"

adb pull /system/bin/battery_charging $PROPS/prebuilt/
adb pull /system/bin/qmuxd $PROPS/prebuilt/
adb pull /system/bin/btwlancoex $PROPS/prebuilt/
adb pull /system/bin/wifiwritemac $PROPS/prebuilt/
adb pull /system/bin/port-bridge $PROPS/prebuilt/
adb pull /system/bin/CKPD-daemon $PROPS/prebuilt/
# File not found on device
# adb pull /system/bin/hdmid prebuilt/
adb pull /system/bin/hostapd $PROPS/prebuilt/
adb pull /data/hostapd/hostapd.conf $PROPS/prebuilt/
adb pull /system/bin/fm_qsoc_patches $PROPS/prebuilt/

echo "    -------------------- DONE. check the above lines for errors"
