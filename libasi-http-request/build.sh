#!/bin/bash

#  Automatic build script for asi-http-request 
#  for iOS and iOSSimulator
#
#  Created by Felix Schulze on 29.03.11.
#  Copyright 2011 Felix Schulze. All rights reserved.
###########################################################################
#
SDKVERSION="5.0"
#
###########################################################################
#
# Don't change anything here
DEVICESDK="iphoneos${SDKVERSION}"
SIMSDK="iphonesimulator${SDKVERSION}"

echo "Building asi-http-request for iPhoneSimulator and iPhoneOS ${SDKVERSION}"
# Clean the targets
if ! xcodebuild -project "asi-http-request.xcodeproj" -target asi-http-request -configuration "Release" -sdk "$DEVICESDK" clean ; then
	exit 1
fi
if ! xcodebuild -project "asi-http-request.xcodeproj" -target asi-http-request -configuration "Release" -sdk "$SIMSDK" clean ; then
	exit 1
fi

# Build the targets
if ! xcodebuild -project "asi-http-request.xcodeproj" -target asi-http-request -configuration "Release" -sdk "$DEVICESDK" -arch "armv6 armv7" build ; then
	exit 1
fi
if ! xcodebuild -project "asi-http-request.xcodeproj" -target asi-http-request -configuration "Release" -sdk "$SIMSDK" build ; then
	exit 1
fi

echo "Build library..."
lipo "build/Release-iphoneos/libasi-http-request.a" "build/Release-iphonesimulator/libasi-http-request.a" -create -output "libasi-http-request.a"
cp -R build/Release-iphoneos/include .
echo "Building done."
