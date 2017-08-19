#
#  Be sure to run `pod spec lint NumericAnnex.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name                  = "NumericAnnex"
  s.summary               = "A supplement to the numeric facilities provided in the Swift standard library."
  s.version               = "0.1.16"
  s.license               = "MIT"
  s.homepage              = "https://github.com/xwu/NumericAnnex"
  s.author                = "Xiaodi Wu"
  s.social_media_url      = "https://twitter.com/xwu"

  s.source                = { :git => "https://github.com/xwu/NumericAnnex.git", :tag => "#{s.version}" }
  s.source_files          = "Sources"
  # s.exclude_files       = "Sources/Exclude"

  s.framework             = "Security"
  s.ios.deployment_target = "8.0"

end
