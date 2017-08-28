Pod::Spec.new do |s|

  s.name                  = "NumericAnnex"
  s.version               = "0.1.19"
  s.author                = "Xiaodi Wu"
  s.social_media_url      = "https://twitter.com/xwu"
  s.license               = "MIT"

  s.homepage              = "https://github.com/xwu/NumericAnnex"
  s.source                = { :git => "https://github.com/xwu/NumericAnnex.git", :tag => "#{s.version}" }
  s.summary               = "A supplement to the numeric facilities provided in the Swift standard library."
  s.documentation_url     = "https://xwu.github.io/NumericAnnex"

  s.ios.deployment_target = "8.0"
  s.framework             = "Security"
  s.source_files          = "Sources"
  # s.exclude_files       = "Sources/Exclude"

end
