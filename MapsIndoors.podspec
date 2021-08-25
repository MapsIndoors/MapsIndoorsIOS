#
# Be sure to run `pod lib lint MapsIndoors.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MapsIndoors"
  s.version          = "3.33.0"
  s.summary          = "Library making the MapsIndoors experience available to your iOS users."
  s.description      = <<-DESC
    The MapsIndoors SDK is the idea of integrating everything on your venue, like people, goods, offices, shops, rooms and buildings with the mapping, positioning and wayfinding technologies provided in the MapsIndoors platform. We make the MapsIndoors platform available to interested businesses and/or partners. So if you think you should be one of them, please call us or send us an email. Mean while, you are most welcome to check out the demo project using 'pod try MapsIndoors'.
                       DESC

  s.homepage         = "https://mapspeople.com/developers"
  s.screenshots     = "https://d3jdh4j7ox95tn.cloudfront.net/mapsindoors/ios/mapsindoors-ios-screenshot1.png", "https://d3jdh4j7ox95tn.cloudfront.net/mapsindoors/ios/mapsindoors-ios-screenshot2.png", "https://d3jdh4j7ox95tn.cloudfront.net/mapsindoors/ios/mapsindoors-ios-screenshot3.png"
  s.license          = { :type => 'Commercial', :text => <<-LICENSE
      Copyright 2016-2017 by MapsPeople A/S
      LICENSE
    }
  s.author           = { "MapsPeople" => "info@mapspeople.com" }
  s.source           = { :git => "https://github.com/MapsIndoors/MapsIndoorsIOS.git", :tag => s.version.to_s, :submodules => true }

  s.dependency 'GoogleMaps', '4.2.0'

  s.frameworks = "UserNotifications", "GameplayKit"

  s.ios.deployment_target    = '10.0'
  s.ios.preserve_paths = ['MapsIndoors.xcframework','Scripts']
  s.ios.vendored_frameworks  = 'MapsIndoors.xcframework'
  s.resources = ['MapsIndoors.xcframework/ios-arm64_armv7_armv7s/MapsIndoors.framework/Versions/A/Resources/MapsIndoors.bundle']

end
