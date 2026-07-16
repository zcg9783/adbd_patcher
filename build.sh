#!/bin/bash
set -e

echo "Starting build for adbd_root..."

if ! command -v ndk-build &> /dev/null; then
    echo "ERROR: ndk-build not found in PATH."
    exit 1
fi

echo "Compiling native code with ndk-build..."
cd adbd_helper
ndk-build
cd ..

if [ ! -d "adbd_helper/libs" ]; then
    echo "ERROR: adbd_helper/libs not found."
    exit 1
fi

MODULE_DIR="magisk_module"
mkdir -p "$MODULE_DIR/bin"/{arm64-v8a,armeabi-v7a,x86,x86_64}
mkdir -p "$MODULE_DIR/lib"/{arm64-v8a,armeabi-v7a,x86,x86_64}

for arch in arm64-v8a armeabi-v7a x86 x86_64; do
    if [ -f "adbd_helper/libs/$arch/adbd" ]; then
        cp "adbd_helper/libs/$arch/adbd" "$MODULE_DIR/bin/$arch/"
        echo "OK: $arch/adbd"
    else
        echo "WARNING: adbd_helper/libs/$arch/adbd not found"
    fi
    if [ -f "adbd_helper/libs/$arch/libadb_root_helper.so" ]; then
        cp "adbd_helper/libs/$arch/libadb_root_helper.so" "$MODULE_DIR/lib/$arch/"
        echo "OK: $arch/libadb_root_helper.so"
    else
        echo "WARNING: adbd_helper/libs/$arch/libadb_root_helper.so not found"
    fi
done

if [ -f "README.md" ]; then
    cp README.md "$MODULE_DIR/"
fi

echo "Packaging Magisk module..."
cd "$MODULE_DIR"
zip -r ../adb_root.zip . > /dev/null
cd ..

echo "Build complete. Output: adb_root.zip"
ls -lh adb_root.zip