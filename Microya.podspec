Pod::Spec.new do |s|

  s.name         = "Microya"
  s.version      = "0.1.1"
  s.summary      = "A micro version of the Moya network abstraction layer written in Swift."

  s.description  = <<-DESC
    A micro version of the Moya network abstraction layer written in Swift.
    Currently only supports JSON APIs.
                   DESC

  s.homepage     = "https://github.com/Flinesoft/Microya"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Cihat Gündüz" => "cocoapods@cihatguenduez.de" }
  s.social_media_url   = "https://twitter.com/Jeehut"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/Flinesoft/Microya.git", :tag => "#{s.version}" }
  s.source_files = "Frameworks/**/*.swift"
  s.framework    = "Foundation"
  s.swift_version = "4.2"

  # s.dependency "HandyUIKit", "~> 1.6"
  # s.dependency "HandySwift", "~> 2.5"

end
