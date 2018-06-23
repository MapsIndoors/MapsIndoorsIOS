# Changelog
Changelog for MapsIndoors for iOS. This document structure is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and the project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!---
## [Unreleased]
### Added
### Fixed
### Changed
### Removed
-->

## [2.0.2] 2018-06-23

### Changed
- Updated to latest MapsIndoors SDK
### Removed
- POIData wrapper service for a locations provider

## [2.0.1] 2018-05-25

### Fixed
- Fixed occasional crash caused by rendering some routes
- Fixed that "Clear Map" button does not appear on iOS < 11
- Fixed logic that choosed which building should be in focus
- Fixed that selected location was not cleared after clearing map
- Fixed performance issue: blocking UI thread when adding markers to map.
- Fixed excessive CPU, GPU and battery load
- Fixed poor map startup performance (UI thread blocking) when loading a big map

### Changed
- Animation speed when showing directions is now adapting the the amount of movement and rotation needed for transitioning between steps.
- Better default resolution in map graphics for online use.
- Disallow the map to change floorplan when showing a route (map shows the floor of the shown part of the route)

## [2.0] 2018-04-09
