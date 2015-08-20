# port of testdroid's device_finder.py
# https://raw.githubusercontent.com/bitbar/testdroid-samples/03fc043ba98235b9ea46a0ab8646f3b20dd1960e/appium/sample-scripts/python/device_finder.py

require 'rubygems'
require 'rest-client'
require 'json'

# RestClient.log = 'stdout'

class DeviceFinder
  # Cloud URL (not including API path)
  attr_accessor :cloud_url
  # Oauth access token
  attr_accessor :access_token
  # Oauth refresh token
  attr_accessor :refresh_token
  # Unix timestamp (seconds) when token expires
  attr_accessor :token_expiration_time
  # Testdroid username
  attr_accessor :username
  # Testdroid password
  attr_accessor :password

  # Full constructor with username and password

  def initialize username, password, url='https://cloud.testdroid.com'
    @username  = username
    @password  = password
    @cloud_url = url
  end

  # Get Oauth2 token
  def get_token
    if not access_token
      # TODO: refresh
      url     = "#{cloud_url}/oauth/token"
      payload = {
        'client_id':  'testdroid-cloud-api',
        'grant_type': 'password',
        'username':   username,
        'password':   password
      }

      res = RestClient.post(url,
                            payload,
                            content_type: :json,
                            accept:       :json)
      if res.code != 200
        puts 'FAILED: Authentication or connection failure. Check Testdroid Cloud URL and your credentials.'
        exit -1
      end

      reply = JSON.parse(res)

      @access_token          = reply['access_token']
      @refresh_token         = reply['refresh_token']
      @token_expiration_time = Time.now + reply['expires_in']
    elsif token_expiration_time < Time.now
      url     = "#{cloud_url}/oauth/token"
      payload = {
        'client_id':     'testdroid-cloud-api',
        'grant_type':    'refresh_token',
        'refresh_token': refresh_token
      }
      res     = RestClient.post(url,
                                payload,
                                content_type: :json,
                                accept:       :json)
      if res.code != 200
        puts 'FAILED: Unable to get a new access token using refresh token'
        @access_token = nil
        return get_token
      end

      reply = JSON.parse(res)

      @access_token          = reply['access_token']
      @refresh_token         = reply['refresh_token']
      @token_expiration_time = Time.now + reply['expires_in']
    end

    access_token
  end

  # Helper method for getting necessary headers to use for API calls, including authentication
  def _build_headers
    { Authorization: "Bearer #{get_token}", content_type: :json, accept: :json }
  end

  # GET from API resource
  def get path=nil, headers={}
    if (path.index('v2/') || -1) >= 0
      cut_path = path.split('v2/')
      path     = cut_path[1]
    end

    url = "#{cloud_url}/api/v2/#{path}"
    headers.merge!(_build_headers)
    res = RestClient.get url, headers

    if res.headers[:content_type].include? 'application/json'
      JSON.parse(res)
    else
      res.body
    end
  end

  # Returns list of devices
  def get_devices limit=0
    get "devices?limit=#{limit}"
  end

  # Find available free Android device
  def available_free_android_device limit=0
    puts 'Searching Available Free Android Device...'

    get_devices(limit)['data'].each do |device|
      if device['creditsPrice'] == 0 and
        device['locked'] == false and
        device['osType'] == 'ANDROID' and
        device['softwareVersion']['apiLevel'] > 16

        puts "Found device #{device['displayName']}"
        puts
        return device['displayName']
      end
    end

    puts 'No available device found'
    puts
  end

  # Find available free iOS device
  def available_free_ios_device limit=0
    puts 'Searching Available Free iOS Device...'

    for device in get_devices(limit)['data']
      if device['creditsPrice'] == 0 and device['locked'] == false and device['osType'] == 'IOS'
        puts "Found device #{device['displayName']}"
        puts
        return device['displayName']
      end
    end

    puts 'No available device found'
    puts
  end
end # class DeviceFinder
