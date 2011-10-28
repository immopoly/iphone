#!/bin/bash

#  Automatic build script for libOAuth 
#  for iOS and iOSSimulator
#
#  Created by Felix Schulze on 29.03.11.
#  Copyright 2011 Felix Schulze. All rights reserved.
###########################################################################
#
SDKVERSION="4.3"
#
###########################################################################
#
# Don't change anything here
DEVICESDK="iphoneos${SDKVERSION}"
SIMSDK="iphonesimulator${SDKVERSION}"

echo "Building libOAuth for iPhoneSimulator and iPhoneOS ${SDKVERSION}"
# Clean the targets
if ! xcodebuild -project "libOAuth.xcodeproj" -target libOAuth -configuration "Release" -sdk "$DEVICESDK" clean ; then
	exit 1
fi
if ! xcodebuild -project "libOAuth.xcodeproj" -target libOAuth -configuration "Release" -sdk "$SIMSDK" clean ; then
	exit 1
fi

# Build the targets
if ! xcodebuild -project "libOAuth.xcodeproj" -target libOAuth -configuration "Release" -sdk "$DEVICESDK" build ; then
	exit 1
fi
if ! xcodebuild -project "libOAuth.xcodeproj" -target libOAuth -configuration "Release" -sdk "$SIMSDK" build ; then
	exit 1
fi

echo "Build library..."
lipo "build/Release-iphoneos/libOAuth.a" "build/Release-iphonesimulator/libOAuth.a" -create -output "libOAuth.a"
cp -R build/Release-iphoneos/include .
echo "Building done."
