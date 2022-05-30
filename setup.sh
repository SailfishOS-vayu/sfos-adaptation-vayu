# Sfos Adaptation for the Xiaomi Poco X3 Pro(vayu)

FIRMWARE="/data/.stowaways/firmware";
SFOS="/data/.stowaways/sailfishos";
OUTFD=/proc/self/fd/$1;
VENDOR_DEVICE_PROP=`grep ro.product.vendor.device /vendor/build.prop | cut -d "=" -f 2 | awk '{print tolower($0)}'`;

# ui_print <text>
ui_print() { echo -e "ui_print $1\nui_print" > $OUTFD; }

# Copy files
ui_print "Copying device adaptation files...";
cp -r sfos/* $SFOS/;

ui_print "Copying firmware images";
mkdir $FIRMWARE;
cp -r firmware/* $FIRMWARE/;

# flash dtbo.img
ui_print "Flash and backup dtbo images";
dd if=/dev/block/bootdevice/by-name/dtbo of=$SFOS/boot/droid-dtbo.img;
ln -s $SFOS/boot/droid-dtbo.img /sdcard;
ln -s $FIRMWARE/hybris-dtbo.img /sdcard;
flash_image /dev/block/bootdevice/by-name/dtbo firmware/hybris-dtbo.img;
