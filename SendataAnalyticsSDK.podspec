Pod::Spec.new do |s|
  s.name         = "SendataAnalyticsSDK"
  s.version      = "v1.0.0"
  s.summary      = "The official iOS SDK of Sendata Analytics."
  s.homepage     = "https://github.com/SmartHubAnalysis/sdk-ios"
  s.source       = { :git => "https://github.com/SmartHubAnalysis/sdk-ios.git", :tag => "v#{s.version}" }
  s.license = { :type => "Apache License, Version 2.0" }
  s.author = { "hello" => "hello@sendata.cn" }
  s.ios.deployment_target = '8.0'
  s.osx.deployment_target = '10.10'
  s.default_subspec = 'Core'
  s.frameworks = 'Foundation', 'SystemConfiguration'

  s.libraries = 'icucore', 'sqlite3', 'z'

  s.subspec 'Common' do |c|
    core_dir = "SendataAnalyticsSDK/Core/"
    c.source_files = core_dir + "**/*.{h,m}"
    c.public_header_files = core_dir + "SendataAnalyticsSDK.h", core_dir + "SendataAnalyticsSDK+Public.h", core_dir + "SAAppExtensionDataManager.h", core_dir + "SASecurityPolicy.h", core_dir + "SAConfigOptions.h", core_dir + "SAConstants.h"
    c.ios.source_files = "SendataAnalyticsSDK/RemoteConfig/**/*.{h,m}", "SendataAnalyticsSDK/ChannelMatch/**/*.{h,m}", "SendataAnalyticsSDK/Encrypt/**/*.{h,m}", "SendataAnalyticsSDK/Deeplink/**/*.{h,m}", "SendataAnalyticsSDK/DebugMode/**/*.{h,m}"
    c.ios.public_header_files = "SendataAnalyticsSDK/Encrypt/SASecretKey.h", "SendataAnalyticsSDK/ChannelMatch/SendataAnalyticsSDK+SAChannelMatch.h"
    c.ios.resource = 'SendataAnalyticsSDK/SendataAnalyticsSDK.bundle'
    c.ios.frameworks = 'CoreTelephony'
  end
  
  s.subspec 'Core' do |c|
    c.ios.dependency 'SendataAnalyticsSDK/Visualized'
    c.osx.dependency 'SendataAnalyticsSDK/Common'
  end

  # 支持 CAID 渠道匹配
  s.subspec 'CAID' do |f|
    f.ios.deployment_target = '8.0'
    f.dependency 'SendataAnalyticsSDK/Core'
    f.source_files = "SendataAnalyticsSDK/CAID/**/*.{h,m}"
    f.private_header_files = 'SendataAnalyticsSDK/CAID/**/*.h'
  end

  # 全埋点
  s.subspec 'AutoTrack' do |g|
    g.ios.deployment_target = '8.0'
    g.dependency 'SendataAnalyticsSDK/Common'
    g.source_files = "SendataAnalyticsSDK/AutoTrack/**/*.{h,m}"
    g.public_header_files = 'SendataAnalyticsSDK/AutoTrack/SendataAnalyticsSDK+SAAutoTrack.h'
    g.frameworks = 'UIKit'
  end

# 可视化相关功能，包含可视化全埋点和点击图
  s.subspec 'Visualized' do |f|
    f.ios.deployment_target = '8.0'
    f.dependency 'SendataAnalyticsSDK/AutoTrack'
    f.source_files = "SendataAnalyticsSDK/Visualized/**/*.{h,m}"
    f.public_header_files = 'SendataAnalyticsSDK/Visualized/SendataAnalyticsSDK+Visualized.h'
  end

  # 开启 GPS 定位采集
  s.subspec 'Location' do |f|
    f.ios.deployment_target = '8.0'
    f.frameworks = 'CoreLocation'
    f.dependency 'SendataAnalyticsSDK/Core'
    f.source_files = "SendataAnalyticsSDK/Location/**/*.{h,m}"
    f.private_header_files = 'SendataAnalyticsSDK/Location/**/*.h'
  end

  # 开启设备方向采集
  s.subspec 'DeviceOrientation' do |f|
    f.ios.deployment_target = '8.0'
    f.dependency 'SendataAnalyticsSDK/Core'
    f.source_files = 'SendataAnalyticsSDK/DeviceOrientation/**/*.{h,m}'
    f.private_header_files = 'SendataAnalyticsSDK/DeviceOrientation/**/*.h'
    f.frameworks = 'CoreMotion'
  end

  # 推送点击
  s.subspec 'AppPush' do |f|
    f.ios.deployment_target = '8.0'
    f.dependency 'SendataAnalyticsSDK/Core'
    f.source_files = "SendataAnalyticsSDK/AppPush/**/*.{h,m}"
    f.private_header_files = 'SendataAnalyticsSDK/AppPush/**/*.h'
  end

  # 使用崩溃事件采集
  s.subspec 'Exception' do |e|
    e.ios.deployment_target = '8.0'
    e.dependency 'SendataAnalyticsSDK/Common'
    e.source_files  =  "SendataAnalyticsSDK/Exception/**/*.{h,m}"
    e.private_header_files = 'SendataAnalyticsSDK/Exception/**/*.h'
  end

  # 基于 UA，使用 UIWebView 或者 WKWebView 进行打通
  s.subspec 'WebView' do |w|
    w.ios.deployment_target = '8.0'
    w.dependency 'SendataAnalyticsSDK/Core'
    w.source_files  =  "SendataAnalyticsSDK/WebView/**/*.{h,m}"
    w.public_header_files = 'SendataAnalyticsSDK/WebView/SendataAnalyticsSDK+WebView.h'
  end

  # 基于 UA，使用 WKWebView 进行打通
  s.subspec 'WKWebView' do |w|
    w.ios.deployment_target = '8.0'
    w.dependency 'SendataAnalyticsSDK/Core'
    w.source_files  =  "SendataAnalyticsSDK/WKWebView/**/*.{h,m}"
    w.public_header_files = 'SendataAnalyticsSDK/WKWebView/SendataAnalyticsSDK+WKWebView.h'
  end

end
