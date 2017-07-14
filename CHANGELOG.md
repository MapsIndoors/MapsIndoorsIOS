# Changelog
The format is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/)
and this project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.10.2-beta4] - 2017-07-14
### Changed
- Internal works, optimizing network requests and caching mechanisms

## [1.10.1] - 2017-07-14
### Changed
- Fix `MPLocation.copy()` results in nil `MPLocation.descr`

## [1.10.0] - 2017-07-14
### Changed
- Fix geometry property nil when copying `MPLocation`
- Fix unlabeled icons not respecting `MapsIndoors.mapIconSize`

### Added
- Support for statically adding a position provider, optionally by setting `MapsIndoors.positionProvider`

## [1.10.0-beta5] - 2017-07-13
### Changed
- Fix geometry property nil when copying `MPLocation`
- Fix unlabeled icons not respecting `MapsIndoors.mapIconSize`

## [1.10.0-beta] - 2017-07-12
### Added
- Support for statically adding a position provider, optionally by setting `MapsIndoors.positionProvider`

## [1.9.1-beta1] - 2017-07-09
### Added
- Support for custom image provider, optionally by setting `MapsIndoors.imageProvider`

## [1.9.0-beta2] - 2017-07-08
### Changed
- Fix image streching on non-quadratic marker icons

## [1.9.0-beta] - 2017-07-05
### Added
- Support for venue display rules (optional)
- Support for venue markers (optional), enabled by a display rule called "venue"
- Property iconSize to `MPLocationDisplayRule`
- Static properties `mapLabelColor` and `mapLabelFont` to `MapsIndoors`
- Default click handling to venue markers

### Changed
- Bugfixing
