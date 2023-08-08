#
# Be sure to run `pod lib lint YMPlayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'YMPlayer'
  s.version          = '0.1.1'
  s.summary          = 'A short description of YMPlayer.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/HaryStep/YMPlayer'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'HaryStep' => 'warm588@163.com' }
  s.source           = { :git => 'https://github.com/HaryStep/YMPlayer.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'
  
  s.swift_version   = '4.0'
  s.ios.deployment_target = '11.0'
  s.static_framework = true
  s.source_files = 'YMPlayer/Classes/**/*'
  
  s.resource_bundles = {
    'YMPlayer' => ['YMPlayer/Assets/*']
  }

  s.public_header_files = 'YMPlayer/Classes/**/*.h'
  
  s.pod_target_xcconfig = {
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64'
  }
  s.user_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  
  s.frameworks = 'SystemConfiguration', 'CoreTelephony', 'QuartzCore', 'CoreText', 'CoreGraphics', 'UIKit', 'Foundation', 'CFNetwork', 'CoreMotion', 'WebKit', 'AVKit', 'AVFoundation'
  s.dependency 'Masonry', '~>1.1.0'
  s.dependency 'MCUIColorUtils'
  s.dependency 'pop'
  s.dependency 'AFNetworking'
  s.dependency 'SDWebImage'
  s.dependency 'MJExtension'
  s.dependency 'CocoaAsyncSocket'
  s.dependency 'ReactiveObjC', '~>3.1.1'
  s.dependency 'MCUIColorUtils'
  s.dependency 'Toast'
  s.dependency 'UICountingLabel'
  s.dependency 'MBProgressHUD'
  s.dependency 'IQKeyboardManager'
  s.dependency 'ijkplayer', '~>1.1.3'
  s.dependency 'WsRTC'
  s.dependency 'WMPageController', '~> 2.4.0'
  
end
