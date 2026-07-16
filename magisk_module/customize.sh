#!/system/bin/sh

if [ -f "/apex/com.android.adbd/bin/adbd" ]; then
    ADBD_PATH="/apex/com.android.adbd/bin/adbd"
    ADBD_REAL="/apex/com.android.adbd/bin/adbd.real"
    ADBD_DIR="/apex/com.android.adbd/bin"
elif [ -f "/system/bin/adbd" ]; then
    ADBD_PATH="/system/bin/adbd"
    ADBD_REAL="/system/bin/adbd.real"
    ADBD_DIR="/system/bin"
else
    exit 0
fi

case $ARCH in
    arm64)   ABI="arm64-v8a"   ;;
    arm)     ABI="armeabi-v7a" ;;
    x86)     ABI="x86"         ;;
    x64)     ABI="x86_64"      ;;
    *)       abort "Unsupported architecture: $ARCH" ;;
esac

MOD_ADBD="$MODPATH/system$ADBD_DIR/adbd"
MOD_ADBD_REAL="$MODPATH/system$ADBD_DIR/adbd.real"

mkdir -p "$MODPATH/system$ADBD_DIR"

if [ -f "$ADBD_PATH" ]; then
    cp -f "$ADBD_PATH" "$MOD_ADBD_REAL"
else
    abort "adbd not found at $ADBD_PATH"
fi

cp -f "$MODPATH/bin/$ABI/adbd" "$MOD_ADBD"

if [ "$ABI" = "arm64-v8a" ] || [ "$ABI" = "x86_64" ]; then
    LIB_DIR="$MODPATH/system/lib64"
else
    LIB_DIR="$MODPATH/system/lib"
fi
mkdir -p "$LIB_DIR"
cp -f "$MODPATH/lib/$ABI/libadb_root_helper.so" "$LIB_DIR/"

chmod 755 "$MOD_ADBD" "$MOD_ADBD_REAL"
if [ -f "$ADBD_PATH" ]; then
    chcon --reference="$ADBD_PATH" "$MOD_ADBD" "$MOD_ADBD_REAL"
fi

rm -rf "$MODPATH/bin" "$MODPATH/lib"