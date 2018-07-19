#
#  Be sure to run `pod spec lint WMH5SDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "WMH5SDK"
  s.version      = "1.0.0"
  s.summary      = "Wenman H5 Native SDK"
  s.description  = "A SDK for fast access to Wenman H5 application, The default navigation bar and progress bar are provided, Provide scheme for payment completion return APP."

  s.homepage     = "https://github.com/WYWM/WMH5SDK-iOS"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author             = { "fangxiaomin" => "fangxiaomin@corp.netease.com" }
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/WYWM/WMH5SDK-iOS.git", :tag => "#{s.version}" }
  s.source_files  = "libWMH5SDK/include/**/*.{h,m}"

  s.resources = "libWMH5SDK/resource/*"

  s.frameworks = "AdSupport", "CoreTelephony", "Security", "CoreLocation", "SystemConfiguration"

  s.libraries = "sqlite3", "z"
  s.vendored_libraries = "libWMH5SDK/*.a"

  s.requires_arc = true

end
