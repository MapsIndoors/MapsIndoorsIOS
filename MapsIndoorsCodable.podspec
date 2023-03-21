#
# Be sure to run `pod lib lint MapsIndoors.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'MapsIndoorsCodable'
  s.version          = '4.0.0-beta7'
  s.summary          = 'Library making the MapsIndoors experience available to your iOS users.'
  s.description      = "The MapsIndoors SDK is the idea of integrating everything at your venue, like people, goods, offices, shops, rooms and buildings with the mapping, positioning and wayfinding technologies provided in the MapsIndoors platform. We make the MapsIndoors platform available to interested businesses and/or partners. So if you think you should be one of them, please call us or send us an email. Meanwhile, you are most welcome to check out the demo project using 'pod try MapsIndoors'."

  s.homepage         = "https://www.mapspeople.com/mapsindoors"
  # s.screenshots = 'app.mapsindoors.com/mapsindoors/ios/mapsindoors-ios-screenshot1.png', 'app.mapsindoors.com/mapsindoors/ios/mapsindoors-ios-screenshot2.png', 'app.mapsindoors.com/mapsindoors/ios/mapsindoors-ios-screenshot3.png'
  s.license          = { type: 'Commercial', text: "Copyright 2016-#{Time.now.year} by MapsPeople A/S" }
  s.changelog        = "https://docs.mapsindoors.com/changelogs/ios"

  s.author = { 'MapsPeople' => 'info@mapspeople.com' }
  s.source = { http: "https://github.com/MapsIndoors/MapsIndoorsIOS/releases/download/#{s.version.to_s}/#{s.name}.xcframework.zip" }

  s.platform = :ios, "13.0"
  s.swift_versions = "5.0"

  s.dependency 'MapsIndoors', s.version.to_s

  s.ios.vendored_frameworks  = "#{s.name}.xcframework"
end
