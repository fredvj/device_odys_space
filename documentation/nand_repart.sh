#!/sbin/sh
# patchbootimg.sh 
# 2010-06-24 Firerat
# patch boot.img with custom partition table
# Credits lbcoder
# http://forum.xda-developers.com/showthread.php?t=704560
# 2010-07-06 Firerat, added androidboot.bootloader=1.33.2005
# 2010-08-05 Firerat, ROM Manger compatible cache
# 2010-08-05 Firerat, legacy /system/sd support in cache bind mount
# 2010-08-05 Firerat, get partition table from dmesg
# 2010-08-06 Firerat, consolidated recovery and boot script into one ( makes life much easier )
# 2010-08-13 Firerat, reverted the 0x0.. strip, fixed typo in cmdline creation 
# 2010-08-13 Firerat, added 'All in One' script launcher
# 2010-08-13 Firerat, comment out 'fallback for dream/sapphire"
# 2010-10-12 daedelus82, added DataKBytes calculation. -@ was causing mtd0 to be overwritten on HTC Desire
# 2012-12-07 fredvj, command line checks for Odys Space
###############################################################################################

###############################################################################################


version=1.5.4
##
mapfile=mtdpartmap.txt
mtdpart=mtd.proc
dmesgmtdpart=mtdpartmap
logfile=mtdrecovery.log

readdmesg ()
{
cat dmesg-2.6.32.txt | awk '/0x.+: "/ {sub(/-/," ");gsub(/"/,"");gsub(/0x/,"");printf $6" 0x"toupper ($3)" 0x"toupper ($4)"\n"}' > $dmesgmtdpart

# need a sanity check, what if recovery had been running for ages and the dmesg buffer had been filled?
for sanity in userdata recovery boot system;do
    if [ `grep -q $sanity $dmesgmtdpart;echo $?` = "0" ];
    then
        sain=y
    else
        sain=n
        break
    fi
done

if [ "$sain" = "y" ];
then
    for partition in misc recovery boot;do
        eval ${partition}StartHex=`awk '/'$partition'/ {print $2}' $dmesgmtdpart`
        eval ${partition}EndHex=`awk '/'$partition'/ {print $3}' $dmesgmtdpart`
    done
    for partition in misc recovery boot;do
        eval StartHex=\$${partition}StartHex
        eval EndHex=\$${partition}EndHex
        eval ${partition}SizeKBytes=`expr \( $(printf %d $EndHex) - $(printf %d $StartHex) \) \/ 1024 `
        eval SizeKBytes=\$${partition}SizeKBytes
        eval ${partition}CL=`echo "${SizeKBytes}K@${StartHex}\(${partition}\)"`
        CLInit="mtdparts=msm_nand:${miscCL},${recoveryCL},${bootCL}"
    done
else
    echo -e "${boot} Patcher v${version}\npartition layout not found in dmesg\nand Dream/Magic not found\nPlease use ${boot} patcher early" >> $logfile
    exit
fi
return
}

recoverymode ()
{
mount /sdcard
# new mtdpartmap config
if [ -e $mapfile ];
then
	busybox dos2unix $mapfile
	if [ "`egrep -q \"mtd|spl\" $mapfile;echo $?`" != "0" ];
	then
		SystemMB=`awk '{print $1}' $mapfile`
		CacheMB=`awk '{print $2}' $mapfile`
		if [ "$CacheMB" -lt "2" ];
		then
			# need at least 2mb cache for recovery to not complain
			CacheMB=2
		fi
	else
		SystemMB=`awk '/mtd/ {print $2}' $mapfile`
		CacheMB=`awk '/mtd/ {print $3}' $mapfile`
		FakeSPL=`awk '/spl/ {print $2}' $mapfile`
		
		if [ "$SystemMB" = "" ];
		then
		    SystemMB=90
		fi
		
		if [ "$CacheMB" = "" ];
		then
			CacheMB=2
		fi
	fi
else
	SystemMB=90
	CacheMB=2
	FakeSPL=""
fi

if [ "$FakeSPL" = "" ];
then
	CLInit="$CLInit"
else
	CLInit="androidboot.bootloader=$FakeSPL $CLInit"
fi
return
}

CreateCMDline ()
{

if [ "$sain" = "y" ];
then
    MiscStartHex=`awk '/misc/ { print $2 }' $dmesgmtdpart`
    MiscStartBytes=`printf %d $(awk '/misc/ { print $2 }' $dmesgmtdpart)`
    SystemStartHex=`awk '/system/ { print $2 }' $dmesgmtdpart`
    SystemStartBytes=`printf %d $(awk '/system/ { print $2 }' $dmesgmtdpart)`
elif [ "`egrep -q "trout|sapphire" /proc/cmdline;echo $?`" = "0" ];
then
    SystemStartBytes=48496640
    SystemStartHex=`printf '%X' $SystemStartBytes`
else
    echo -e "${boot} Patcher v${version}\n" >> $logfile
    echo "errm, shouldn't have got this far" >> $logfile
	exit
fi

if [ "$Mode" = "recovery" ];
then
	SystemKBytes=`expr $SystemMB \* 1024`
	SystemBytes=`expr $SystemKBytes \* 1024`
else
	SystemSizeHex=`awk '/system/ { print "0x"$2 }' $mtdpart`
	CacheSizeHex=`awk '/cache/ { print "0x"$2 }' $mtdpart`
	SystemBytes=`printf '%d' $SystemSizeHex`

	SystemKBytes=`expr $SystemBytes \/ 1024`
fi

if [ "$Mode" = "recovery" ];
then
	CacheKBytes=`expr $CacheMB \* 1024`
	CacheBytes=`expr $CacheKBytes \* 1024`
else
	CacheSizeHex=`awk '/cache/ { print "0x"$2 }' $mtdpart`
	CacheBytes=`printf '%d' $CacheSizeHex`
	CacheKBytes=`expr $CacheBytes \/ 1024`
fi

CacheStartBytes=`expr $SystemStartBytes + $SystemBytes`
CacheStartHex=`printf '%X' $CacheStartBytes`

# data size is 'wildcard' -@ uses remaining space
DataStartBytes=`expr $CacheStartBytes + $CacheBytes`
DataStartHex=`printf '%X' ${DataStartBytes}`
DataKBytes=`expr \( $MiscStartBytes - $DataStartBytes \) \/ 1024 `

KCMDline=${CLInit},${SystemKBytes}k@${SystemStartHex}\(system\),${CacheKBytes}k@0x${CacheStartHex}\(cache\),${DataKBytes}k@0x${DataStartHex}\(userdata\)
echo $KCMDline
return
}

flashimg ()
{
 return
}

#end functions

Mode=$1
if [ "$Mode" = "recovery" -o "$Mode" = "boot" ];
then
	readdmesg
	if [ "$Mode" = "recovery" ];
	then
		boot=recovery
		recoverymode
	else
		if [ "$Mode" = "boot" ];
		then
			boot=boot
		fi
	fi
	CreateCMDline
	flashimg
	
else
    echo -e "CustomMTD Patcher v${version}\nNo Argument given, script needs either:\nboot or recovery )" >> $logfile
	exit
fi

