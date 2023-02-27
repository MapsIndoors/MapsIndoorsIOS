# MapsIndoors

[![Version](https://img.shields.io/cocoapods/v/MapsIndoors.svg?style=flat)](http://cocoapods.org/pods/MapsIndoors)
[![License](https://img.shields.io/cocoapods/l/MapsIndoors.svg?style=flat)](http://cocoapods.org/pods/MapsIndoors)
[![Platform](https://img.shields.io/cocoapods/p/MapsIndoors.svg?style=flat)](http://cocoapods.org/pods/MapsIndoors)

## Usage

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

### Known Issues

> 1. Developing on the new Arm-based Apple Silicon (M1) Macs requires building and running on a physical iOS device or using an iOS simulator running iOS 13.7, e.g. iPhone 11. This is a temporary limitation in Google Maps SDK for iOS, and as such also a limitation in MapsIndoors, due to the dependency to Google Maps.

## Installation

MapsIndoors is available through [CocoaPods](http://cocoapods.org). To install it, add one of the following lines to your Podfile, depending on which map engine you will be using, Google Maps or Mapbox:

To use the Google Maps map engine add
```ruby
pod "MapsIndoorsGoogleMaps"
```

To use the Mapbox map engine add
```ruby
pod "MapsIndoorsMapbox"
```

## Author

MapsPeople A/S, info@mapspeople.com

## License

MapsIndoors SDK is released under a commercial license. The MapsIndoors demonstration apps are released under MIT license.
