
## iOS Version Requirements

MapsIndoors SDK v4 requires at least iOS 13 and Xcode 14.

## [4.0.0-beta7] 2023-03-20

MapsIndoors iOS v4 SDK is considered feature complete but some changes to the public interface is to be expected. The beta status indicates that there may be bugs and unresponsive or slow map rendering under certain conditions.

### Added

- MapsIndoors framework that contains the public interface for MapsIndoors.

### Changed

- With the addition of the MapsIndoors framework it is now necessary to `import MapsIndoors` instead of `import MapsIndoorsCore` (`import MapsIndoorsCore` is still needed in a few cases as described in the documentation and migration guide).

### Fixed

- Directions now work with external routes as well, using Google Maps Directions API or Mapbox Navigation API, respectively.

## [4.0.0-beta6] 2023-02-16

### Changed

* `MapsIndoors.shared.newMapControl(mapConfig:)` has been renamed to `MapsIndoors.shared.createMapControl(mapConfig:)`
* Assignment of PositionProvider is moved to MapControl.
* Access to pre-defined DisplayRules and those from the CMS are now accessed via `MapsIndoors.shared.displayRuleFor(displayRuleType:)`

### Fixed

* Tiles load faster on Google Map.
* 2D Models use less resources.
* Building outline is drawn in correct width.
* Location polygons respect opacity.

## [4.0.0-beta5] 2023-02-13

### Fixed

* Locations now actually show on Mapbox Map in apps using Cocoapod or XCFramework

### Known issues

* Content rendering order (polygons, markers, models, etc.)
* Clustering not working
* Directions relying on external routing not working

## [4.0.0-beta4] 2023-02-10

### Fixed

* Locations now show on Mapbox Map in apps using Cocoapod or XCFramework

### Known issues

* Content rendering order (polygons, markers, models, etc.)
* Clustering not working
* Directions relying on external routing not working

## [4.0.0-beta3] 2023-02-09

### Added

* Added support for MPSelectionBehavior
* Added support for MPFilterBehavior

### Fixed

* InfoWindow shows when Location is selected
* Support of "Hide icon over label" configuration
* 2D models are shown on Google Maps

### Known issues

* Content rendering order (polygons, markers, models, etc.)
* Clustering not working
* Directions relying on external routing not working

## [4.0.0-beta2] 2023-02-03

### Changed

* Many interface changes. See migration guide for help in migrating from MapsIndoors SDK v3.
* Minimum iOS version supported is iOS 13.
* Required Xcode version is Xcode 14.

## [4.0.0-beta1] 2023-01-11

### Added

* Support for Mapbox as map engine.

### Changed

* Many interface changes. See migration guide for help in migrating from MapsIndoors SDK v3.
* Minimum iOS version supported is iOS 13.
* Required Xcode version is Xcode 14.

