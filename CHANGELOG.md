# Changelog
The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!---
 ## [Unreleased]
 - None
 -->


## [1.11.1-beta2] - 2017-08-29
### Fixed
- Fixed issue getting multiple delegate or completionHandler calls from MPVenueProvider.

## [1.11.1-beta1] - 2017-08-29
### Fixed
- Fixed issue getting no route results when creating a directions request before initialising MPMapControl.

## [1.11.0-beta2] - 2017-08-29
### Changed
- Internal refactoring.

## [1.11.0-beta1] - 2017-08-29
### Fixed
- Fixed issue with MPLocationsProvider fired in parallel. 
- Added property queryMode to MPLocationsQuery, can be set to MPLocationsQueryModeAutocomplete or MPLocationsQueryModeNormal (default)

## [1.10.5-beta2] - 2017-08-24
### Fixed
- MPFloorSelector: Fixed a few layout issues.

## [1.10.5-beta1] - 2017-08-24
### Fixed
- MPLocationsProvider: Unable to filter by Type in some cases.

## [1.10.4-beta1] - 2017-08-18
### Fixed
- TileService: Only report error when we cant get tileUrlData *and* we dont have cached data.
- Prevent multiple calls to completionHandler from -[MapsIndoors fetchDataForOfflineUse:]
- Calls to -[MPSolutionProvider getSolutionAsync:completionHandler:] while a call is already ongoing would fail to call completion handler.

## [1.10.3-beta1] - 2017-08-09
### Changed
- Updated Google Maps SDK dependency.

## [1.10.2-beta6] - 2017-08-09
### Changed
- Optimized tile loading performance.

## [1.10.2-beta5] - 2017-08-09

## [1.10.2-beta4] - 2017-07-14
### Changed
- Internal works, optimizing network requests and caching mechanisms

## [1.10.1] - 2017-07-14
### Fixed
- Fix `MPLocation.copy()` results in nil `MPLocation.descr`

## [1.10.0] - 2017-07-14
### Fixed
- Fix geometry property nil when copying `MPLocation`
- Fix unlabeled icons not respecting `MapsIndoors.mapIconSize`

### Added
- Support for statically adding a position provider, optionally by setting `MapsIndoors.positionProvider`

## [1.10.0-beta5] - 2017-07-13
### Fixed
- Fix geometry property nil when copying `MPLocation`
- Fix unlabeled icons not respecting `MapsIndoors.mapIconSize`

## [1.10.0-beta] - 2017-07-12
### Added
- Support for statically adding a position provider, optionally by setting `MapsIndoors.positionProvider`

## [1.9.1-beta1] - 2017-07-09
### Added
- Support for custom image provider, optionally by setting `MapsIndoors.imageProvider`

## [1.9.0-beta2] - 2017-07-08
### Fixed
- Fix image streching on non-quadratic marker icons

## [1.9.0-beta] - 2017-07-05
### Added
- Support for venue display rules (optional)
- Support for venue markers (optional), enabled by a display rule called "venue"
- Property iconSize to `MPLocationDisplayRule`
- Static properties `mapLabelColor` and `mapLabelFont` to `MapsIndoors`
- Default click handling to venue markers

### Fixed
- Internal bugfixing
