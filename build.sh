#!/bin/bash
set -e

echo "Starting build for adbd_root..."

if ! command -v ndk-build &> /dev/null; then
    echo "ERROR: ndk-build not found in PATH. Please install Android NDK and set PATH."
    exit 1
fi

echo "Compiling native code with ndk-build..."
ndk-build

if [ ! -d "libs" ]; then
    echo "ERROR: libs directory not found after ndk-build. Build may have failed."
    exit 1
fi

MODULE_DIR="magisk_module"
if [ ! -d "$MODULE_DIR" ]; then
    echo "ERROR: $MODULE_DIR directory not found."
    exit 1
fi

echo "Preparing Magisk module structure..."
mkdir -p "$MODULE_DIR/bin"/{arm64-v8a,armeabi-v7a,x86,x86_64}
mkdir -p "$MODULE_DIR/lib"/{arm64-v8a,armeabi-v7a,x86,x86_64}

echo "Copying binaries for all architectures..."
for arch in arm64-v8a armeabi-v7a x86 x86_64; do
    if [ -f "libs/$arch/adbd" ]; then
        cp "libs/$arch/adbd" "$MODULE_DIR/bin/$arch/"
        echo "OK: $arch/adbd"
    else
        echo "WARNING: libs/$arch/adbd not found, skipping"
    fi
    if [ -f "libs/$arch/libadb_root_helper.so" ]; then
        cp "libs/$arch/libadb_root_helper.so" "$MODULE_DIR/lib/$arch/"
        echo "OK: $arch/libadb_root_helper.so"
    else
        echo "WARNING: libs/$arch/libadb_root_helper.so not found, skipping"
    fi
done

if [ -f "README.md" ]; then
    cp README.md "$MODULE_DIR/"
    echo "README.md copied"
else
    echo "README.md not found, creating an empty one"
    touch "$MODULE_DIR/README.md"
fi

echo "Packaging Magisk module..."
cd "$MODULE_DIR"
zip -r ../adb_root.zip . > /dev/null
cd ..

echo "Build complete! Output: adb_root.zip"
ls -lh adb_root.zip