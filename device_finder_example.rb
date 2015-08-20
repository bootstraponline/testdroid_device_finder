# port of testdroid's device_finder.py
# https://raw.githubusercontent.com/bitbar/testdroid-samples/03fc043ba98235b9ea46a0ab8646f3b20dd1960e/appium/sample-scripts/python/device_finder.py

require 'rubygems'
require 'rest-client'
require 'json'
require 'pry'

url      = 'https://cloud.testdroid.com'
username = ENV['TESTDROID_USERNAME']
password = ENV['TESTDROID_PASSWORD']

require_relative 'device_finder'

device_finder = DeviceFinder.new username, password, url

device_finder.available_free_ios_device

device_finder.available_free_android_device
