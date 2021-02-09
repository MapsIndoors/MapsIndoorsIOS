# MapsIndoorsUtils

> This software is currently beta and is subject to change without notice.

In order to make it easier to work with the appearance of special icons on the MapsIndoors map, we are releasing some rendering helpers in a Utility Library for each MapsIndoors platform. We don’t want to force an app into a specific visualization, so the helpers create a sensible default, with a few options for configuration. If a developer is not happy with defaults or the ways it can be configured, it is possible to create a rendering from the scratch or create a modified rendering with this source code as a starting point.

Currently, the only utility is a rendering helper for placing a badge on an icon image. The result is a larger image with both the original image graphics and the badge placed on top of the image.

At the moment these customizations can be made:

* Setting the text of the badge
* Setting the position of the badge
* Setting the background color of the bagde
* Setting the font for the text on the badge
* Setting the font color for the text on the badge
* Setting the padding of the badge

## Installation

MapsIndoorsUtils is available as a [CocoaPods](https://cocoapods.org) pod. To install
it, simply add the following line to your Podfile:

```ruby
pod 'MapsIndoorsUtils', git: => 'https://github.com/MapsIndoors/MapsIndoorsUtilsIOS.git'
```

## Authors

Dedicated brains @MapsPeople, mail@mapspeople.com

## License

MapsIndoorsUtils is available under the MIT license. See the LICENSE file for more info.
