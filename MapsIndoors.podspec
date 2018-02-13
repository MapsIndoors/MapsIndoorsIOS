#
# Be sure to run `pod lib lint MapsIndoors.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MapsIndoors"
  s.version          = "2.0.0-alpha62"
  s.summary          = "Library for making the MapsIndoors experience available to your iOS users."
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
  s.source           = { :git => "https://github.com/MapsIndoors/MapsIndoorsIOS.git", :tag => s.version.to_s }

#s.source_files = ['Source/*/*.swift']

  s.dependency 'GoogleMaps', '2.4'
  #s.dependency 'Gloss', '1.1.1'
  #s.dependency 'Zip', '0.6.0'

  s.frameworks = "UserNotifications", "GameplayKit"

  s.ios.deployment_target    = '9.0'
  s.ios.preserve_paths = ['MapsIndoors.framework','Scripts']
  #s.ios.public_header_files  = 'MapsIndoors.framework/Versions/A/Headers/*.h'
  s.ios.vendored_frameworks  = 'MapsIndoors.framework'#, 'MapsIndoorsSwift.framework'
  s.resources = ['MapsIndoors.framework/Versions/A/Resources/MapsIndoors.bundle']

end
