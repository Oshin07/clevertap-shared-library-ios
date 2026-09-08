#!/bin/bash
# ─────────────────────────────────────────────────────────────
# Build SharedEventLib.xcframework
# Run from this directory:  chmod +x build-xcframework.sh && ./build-xcframework.sh
# Requires: Xcode 14+ with command-line tools installed
# ─────────────────────────────────────────────────────────────

set -e

SCHEME="SharedEventLib"
OUTPUT="SharedEventLib.xcframework"
BUILD_DIR="./build"

echo "🔨 Cleaning previous build..."
rm -rf "$BUILD_DIR" "$OUTPUT"

echo "📦 Resolving Swift Package dependencies (fetching CleverTap SDK)..."
swift package resolve

echo "📦 Building for iOS Device (arm64)..."
xcodebuild build \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS" \
  -derivedDataPath "$BUILD_DIR/ios-derived" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO

echo "📦 Building for iOS Simulator (arm64 + x86_64)..."
xcodebuild build \
  -scheme "$SCHEME" \
  -destination "generic/platform=iOS Simulator" \
  -derivedDataPath "$BUILD_DIR/sim-derived" \
  BUILD_LIBRARY_FOR_DISTRIBUTION=YES \
  SKIP_INSTALL=NO

IOS_FW=$(find "$BUILD_DIR/ios-derived" -name "$SCHEME.framework" ! -path "*/Objects-normal/*" | head -1)
SIM_FW=$(find "$BUILD_DIR/sim-derived" -name "$SCHEME.framework" ! -path "*/Objects-normal/*" | head -1)

echo "📦 iOS framework:  $IOS_FW"
echo "📦 Sim framework:  $SIM_FW"

# Copy swiftmodule files into the framework Modules directory
echo "📦 Copying Swift module interfaces into frameworks..."

IOS_MODULES=$(find "$BUILD_DIR/ios-derived/Build/Products" -name "$SCHEME.swiftmodule" ! -path "*/Objects-normal/*" | head -1)
SIM_MODULES=$(find "$BUILD_DIR/sim-derived/Build/Products" -name "$SCHEME.swiftmodule" ! -path "*/Objects-normal/*" | head -1)

mkdir -p "$IOS_FW/Modules/$SCHEME.swiftmodule"
mkdir -p "$SIM_FW/Modules/$SCHEME.swiftmodule"
cp "$IOS_MODULES"/* "$IOS_FW/Modules/$SCHEME.swiftmodule/"
cp "$SIM_MODULES"/* "$SIM_FW/Modules/$SCHEME.swiftmodule/"

echo "🔗 Creating XCFramework..."
xcodebuild -create-xcframework \
  -framework "$IOS_FW" \
  -framework "$SIM_FW" \
  -output "$OUTPUT"

echo ""
echo "✅ Done! XCFramework is at: $(pwd)/$OUTPUT"
echo "   Drop SharedEventLib.xcframework into the client's Xcode project."
echo "   Add CleverTapSDK via SPM as well (it's a dependency of this library)."
