#!/bin/sh

PROPS=../../../vendor/odys/space/proprietary/
BUILD=../../../out/target/product/space/

# find $PROPS -name \* -exec echo -e '{}' \;
find $PROPS -name \* -printf '%f ' > /tmp/extracted.lst

for f in `cat /tmp/extracted.lst`
do
	echo "$f:"
	find $BUILD -name $f -print
done

rm /tmp/extracted.lst

