# -*- coding: utf-8 -*-

# from: https://github.com/bitbar/testdroid-samples/blob/03fc043ba98235b9ea46a0ab8646f3b20dd1960e/appium/sample-scripts/python/testdroid_safari.py

import os
from device_finder import DeviceFinder

# Demonstrate finding available free iOS and Android devices.

testdroid_username = os.environ['TESTDROID_USERNAME']
testdroid_password = os.environ['TESTDROID_PASSWORD']

## DeviceFinder can be used to find available freemium device for testing
deviceFinder = DeviceFinder(testdroid_username, testdroid_password)
testdroid_device = ""

## Safari testing iPad 3 freemium device not yet supported as it is iOS 8.2 device
while testdroid_device == "" or testdroid_device == "iPad 3 A1416 8.2":
  testdroid_device = deviceFinder.available_free_ios_device()

testdroid_device = ""
while testdroid_device == "":
    testdroid_device = deviceFinder.available_free_android_device()
