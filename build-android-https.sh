#!/bin/bash
set -e

echo "================================"
echo "Building FFmpeg Kit HTTPS Package for Android"
echo "================================"

# Check environment variables
if [[ -z ${ANDROID_SDK_ROOT} ]]; then
  echo "ERROR: ANDROID_SDK_ROOT not defined"
  exit 1
fi

if [[ -z ${ANDROID_NDK_ROOT} ]]; then
  echo "ERROR: ANDROID_NDK_ROOT not defined"
  exit 1
fi

echo "Android SDK Root: ${ANDROID_SDK_ROOT}"
echo "Android NDK Root: ${ANDROID_NDK_ROOT}"
echo ""

# Clean previous builds
echo "Cleaning previous builds..."
rm -rf prebuilt/android-aar/ffmpeg-kit-https

# Build the HTTPS package
# The "https" package includes: gmp + gnutls (for HTTPS support)
# No GPL libraries (x264, x265, xvidcore, vid.stab)
echo ""
echo "Starting build process..."
echo "Package: https (gmp + gnutls)"
echo "No GPL libraries included"
echo ""

./android.sh \
  --enable-gnutls \
  --enable-gmp \
  --disable-x86 \
  --disable-x86-64 \
  --api-level=24

echo ""
echo "================================"
echo "Build completed!"
echo "================================"
echo ""
echo "Output AAR files location:"
find prebuilt/android-aar -name "*.aar" -type f

echo ""
echo "Done!"
