Changelog for MapsIndoors for iOS. This document structure is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and the project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!---
## [Unreleased]
### Fixed
### Added
### Fixed
### Changed
### Removed
-->

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
