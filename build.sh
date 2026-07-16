#!/bin/bash

if [ "$1" = "clean" ]; then
    cd adbd_helper && ndk-build clean
    exit
fi

cd adbd_helper && ndk-build

MODULE_DIR="magisk_module"
rm -rf $MODULE_DIR/bin $MODULE_DIR/lib
mkdir -p $MODULE_DIR/bin/arm64-v8a
mkdir -p $MODULE_DIR/bin/armeabi-v7a
mkdir -p $MODULE_DIR/bin/x86
mkdir -p $MODULE_DIR/bin/x86_64
mkdir -p $MODULE_DIR/lib/arm64-v8a
mkdir -p $MODULE_DIR/lib/armeabi-v7a
mkdir -p $MODULE_DIR/lib/x86
mkdir -p $MODULE_DIR/lib/x86_64

cp adbd_helper/libs/arm64-v8a/adbd $MODULE_DIR/bin/arm64-v8a/
cp adbd_helper/libs/arm64-v8a/libadb_root_helper.so $MODULE_DIR/lib/arm64-v8a/

cp adbd_helper/libs/armeabi-v7a/adbd $MODULE_DIR/bin/armeabi-v7a/
cp adbd_helper/libs/armeabi-v7a/libadb_root_helper.so $MODULE_DIR/lib/armeabi-v7a/

cp adbd_helper/libs/x86/adbd $MODULE_DIR/bin/x86/
cp adbd_helper/libs/x86/libadb_root_helper.so $MODULE_DIR/lib/x86/

cp adbd_helper/libs/x86_64/adbd $MODULE_DIR/bin/x86_64/
cp adbd_helper/libs/x86_64/libadb_root_helper.so $MODULE_DIR/lib/x86_64/

cp README.md $MODULE_DIR/

cd $MODULE_DIR && zip -r ../adb_root.zip -x "*.DS_Store" -- *