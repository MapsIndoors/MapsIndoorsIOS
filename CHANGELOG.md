# Changelog
Changelog for MapsIndoors for iOS. This document structure is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and the project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!---
## [Unreleased]
### Added
### Fixed
### Changed
### Removed
-->

## [2.0.4] 2018-06-22
### Fixed
- Fixed a major bug that caused the generated Swift interface in XCode to expose assumed nonnull properties in various areas of the interface
### Changed
- A lot of properties have now become nullable

## [2.0.3] 2018-06-15
### Fixed
- Fixed logic that selects the current building in focus
- POI Labels were not shown on the map
- Selected location not cleared after clearing map `-[MPMapControl clearMap]`.
- Fixed route animation graphics glitch
- Fixed casing intolerance when retrieving route networks for route calculation
- Fixed internal geometry calculation that could cause `MPDirectionsRenderer` to crash when rendering
- Fixed inconsistent map search state caused by passing zero length array to `MPMapControl.searchResult`
### Changed
- Improved map graphics used for cases when there are no bundled map graphics
- Improved Google Maps directions integration / handover from Google Maps to MapsIndoors
- Animation speed when showing directions is now adapting the the amount of movement and rotation needed for transitioning between steps.
- Moved MapsPeople logo to the lower right side of the map.

## [2.0.2-rc1] 2018-05-02
### Added
### Fixed
- Fixed logic that selects the current building in focus
### Changed
- Improved map graphics used for cases when there are no bundled map graphics
- Improved Google Maps directions integration / handover from Google Maps to MapsIndoors
### Removed

## [2.0.1-rc6] 2018-05-02
### Added
### Fixed
- POI Labels were not shown on the map.
- Selected location not cleared after clearing map `-[MPMapControl clearMap]`.
### Changed
- Animation speed when showing directions is now adapting the the amount of movement and rotation needed for transitioning between steps.
### Removed

## [2.0.0] 2018-04-10
### Added
- On-device route calculation optionally with routing-data embedded into the app.
- Fetching of all MapsIndoors content now possible using `[MapsIndoors synchroniseContent:]`
- Fetching and bundling of all MapsIndoors content now possible using build run script phase
- On-device route calculation optionally with routing-data embedded into the app.
- Fetching of all MapsIndoors content now possible using `[MapsIndoors synchroniseContent:]`

### Fixed
- Performance improvements by delegating image rendering to background queue.
- Improvements in CPU load and battery consumption.
- MPDirectionsRenderer: exposed a property to indicate whether a route is rendered or not.
- Less strict internal data parsing, ensuring that some location properties can be omitted
- Fixed an error where directions service would crash if no API key was properly set
- Fixed an error where map graphics was not loaded properly
- Fixed an error where updating of a display rule would unintentionally persist across initialisations of `MPMapControl`
- Fixed an error where fetching of messages failed because of mal-formatted language
- Fixed callback issues when calling multiple route requests simultaneously
- Fixed an error where directions service would crash if no API key was properly set
- Fixed an error where map graphics was not loaded properly
- Fixed an error where updating of a display rule was persistent across initialisations of `MPMapControl`
- Fixed an error where fetching of messages failed because of mal-formatted language
- Fixed callback issues when calling multiple route requests simultaneously

### Changed
- Changed initialisation steps, see [Getting Started](https://mapsindoors.github.io/ios/v2)
- Added `MPDirectionsQuery` and new method to query routes on `MPDirectionsService`
- Deprecations introduced on various methods
- Deprecations introduced on various UI controls
- Added `MPDirectionsQuery` and new method to query routes on `MPDirectionsService`
- Deprecations introduced on various UI controls
- Deprecations introduced on various methods

### Removed
- All beacon positioning related logic (moved to public app code)
- Made peripheral code private that was public before
- All beacon positioning related logic (moved to public app code)
- Made peripheral code private that was public before

