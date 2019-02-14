Pod::Spec.new do |s|

  s.name         = "NewFrameworkTemplate"
  s.version      = "0.1.0"
  s.summary      = "TODO: Short Framework description"

  s.description  = <<-DESC
    TODO: Describe this framework in detail here.
                   DESC

  s.homepage     = "https://github.com/Flinesoft/NewFrameworkTemplate"
  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Cihat Gündüz" => "cocoapods@cihatguenduez.de" }
  s.social_media_url   = "https://twitter.com/Dschee"

  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.10"
  s.tvos.deployment_target = "9.0"

  s.source       = { :git => "https://github.com/Flinesoft/NewFrameworkTemplate.git", :tag => "#{s.version}" }
  s.source_files = "Sources", "Sources/**/*.swift"
  s.framework    = "Foundation"
  s.swift_version = "4.2"

  # s.dependency "HandyUIKit", "~> 1.6"
  # s.dependency "HandySwift", "~> 2.5"

end
