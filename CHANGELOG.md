---
title: Changelog
---
Changelog for MapsIndoors for iOS. This document structure is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and the project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!---
## [Unreleased]
### Added
### Fixed
### Changed
### Removed
-->

## [3.3.1-rc2] 2019-09-13
### Changed
- InfoWindows presented on the map is now made fully visible if needed - this changes the presented map area.
### Fixed
- Fixed location data was only synced once per session, regardless of explicit calls to +[MapsIndoors sunchronizeContent:].

## [3.3.0] 2019-08-26
### Added
- Support for custom fields on venues, buildings, categories and types authored in the CMS

## [3.2.0] 2019-08-20
### Changed
- Updated Google Maps SDK from 3.1.0 to 3.3.0 (see https://developers.google.com/maps/documentation/ios-sdk/releases for details)
- Default Google Maps styling is now applied to the map, so that we hide Google Maps icons that usually compete with, confuse or disturb the appearance of MapsIndoors location icons
### Added
- Support for building default floors.
- Support for profile-based routing.
- Support for travelmode specific venue entrypoints, so f.ex. driving routes can go via parking lots (require data configuration).
### Fixed
- Fixed an issue with loading solution-data from the MapsIndoors backend.
- Fixed an issue with searching for location aliases.
- Fixed a memory issue that can happen when multiple map instances are created in one session.
- Fixed a rare race condition during initialization.


## [3.1.2] 2019-06-27
### Fixed
- Fixed memory issue related to adding observers to `MPMapsIndoorsLocationSource`  in relation to entering and leaving a MapsIndoors map multiple times in the same session.
- Fixed occasional orphaned/ghost polyline from the `MPDirectionsRenderer`.
- Fixed wrong floor tiles showing in route step in some cases.
- Fixed an issue with route rendering.
- Fixed info window not appearing for selectedLocation after several api key switches.

## [3.1.1] 2019-06-21
### Fixed
- Fixed `MPMapControl.go(to:MPLocation)` so that the map now properly fits locations with polygons.
- Fixed dataset switching sometimes not working due to re-initialisation not properly executed behind the scenes.
- Fixed memory issues related to entering and leaving a MapsIndoors map multiple times in the same session.
- Adding custom `MPLocationDisplayRule` not affecting size and rank changes due to a race condition.
- Fixed a problem with transitioning from a Google route to a MapsIndoors route.

## [3.1.0] 2019-06-04
### Added
- Added a `MPGeometryHelper` class
- Added a way to get polygons for locations using `MPGeometryHelper.polygonsForLocation(location:MPLocation)`
- Updated Google Maps dependency to version 3.1.0
- Optimizing outdoor/indoor directions. Filters entry points by new travel mode flag in SDK before doing calculations.
- Now possible to set map style (layout) using `MPMapControl.mapStyle = MPMapStyle(string:"my-style")`. Only applies for data sets that has multiple defined styles.
### Fixed
- Fixed map markers being anchored at the bottom of a square icon, not the center.
- Fixed a race condition in the initial data fetch causing locations search results to be initially empty.
- Fixed error causing locations to show across all Floors when displaying as search result.
- Fixed tapping on Information Window does not center view based on selected location. 

## [3.0.4] 2019-04-29
### Fixed
- Improved search functionality.
- Fixed an issue with directions only returning routes on ground floor.
- Fixed issue with the directions service not resorting to offline even in case of cached route-networks.
- Fixed an issue where would return more than expected results when perfect match(es) was found.

## [3.0.3] 2019-04-11
### Fixed
- Fixed an issue changing MapsIndoors.positionProvider during the runtime of the app.

## [3.0.2] 2019-04-08
### Fixed
- Fixed an issue where MPMapControl would not update it's current location.

## [3.0.1] 2019-04-03
### Added
- MPMapControlDelegate now has a new method for notifying about which building is focused on the map  `- [MPMapControlDelegate focusedBuildingDidChange:(nullable MPLocation*)building]`
- MPMapControlDelegate now has a new method for notifying position updates  `- [MPMapControlDelegate onPositionUpdate:(nonnull MPPositionResult*)positionResult]`
### Changed
- MPMapControl.currentPosition has been deprecated; use MapsIndoors.positionProvider.latestPositionResult to know current position.
### Fixed
- Fixed an issue related to MPLocations using the default displayrule as well as their own icon.
- Fixed an issue causing MPLocationUpdate/MPLocation to always set floor index to zero on updates.

## [3.0.0] 2019-03-04
### Added
- Support for external location data sources using `[MapsIndoors registerLocationSources:sources]`
- New location service `MPLocationService` to replace `MPLocationsProvider`
- Location clustering support using `MPMapControl.locationClusteringEnabled`
- Added building and venues to the search experience

### Changed
- MPLocation properties are now read only

### Removed
- Removed a number of deprecated methods that was introduced in V1

## [2.2.0] 2019-03-22
### Added
- Now possible to set map style (layout) using `MPMapControl.mapStyle = MPMapStyle(string:"my-style")`. Only applies for data sets that has multiple defined styles.

## [2.1.10] 2019-03-05
### Fixed
- Fixed an issue causing map graphics not to show after a synchronisation followed by an app kill

## [2.1.9] 2019-02-15
### Fixed
- Fixed an occasional crash in MPVenueProvider, reported in [github](https://github.com/MapsIndoors/MapsIndoorsIOS/issues/5).
- Fixed an issue causing infowindow to pop up every time map is panned around with searchResult of 1 location
- Fixed a data synchronisation issue that could occur with two datasets that has offline capabilities
- Fixed MapsPeople logo so it respects MapView padding
- Fixed occasional crashes when running simulator builds

### Added
- Added some classes that were not present in reference guide

## [2.1.8] 2019-01-03
### Fixed
- The last segment of a route object returned from a directions request sometimes had an unexpected - and wrong - end location.
- Search engine sometimes returned some unexpected results.

## [2.1.7] 2018-12-10
### Fixed
- In some cases the "next"-button on `MPDirectionsRenderer` would display "Level (null)".

## [2.1.6] 2018-11-27
### Added
- Support for extra time penalties in the directions service
### Fixed
- When in flightmode, the routenetwork service would make two callbacks to the app: first callback with cached data and second callback with an error.
The second callback would result in no route being produced

## [2.1.5] 2018-11-06
### Added
- Support for multi-polygon floor geometry

## [2.1.4] 2018-11-01
### Fixed
- Issues related to POI presentation.

## [2.1.3] 2018-10-26
### Fixed
- Issues related to POI presentation.

## [2.1.2] 2018-10-10
### Fixed
- Fixed a Route Rendering issue causing it not to fit path shape properly
- Fixed bug that was causing an occasional malformatted url for the Google directions service.
- MapsPeople logo was misplaced on recent iPhone models. Now aligned to the Google Maps logo.
- Content type validations on some internal endpoints
- Improved the building selection triggered on camera change
- Fixed resetting marker map from non-ui thread that sometimes lead to a crash
- Fixed crash that was caused by GMSProjection occasionally not being in an operational state
### Added
- Support for multi-polygon floor geometry
- Respect larger (accessibility) font sizes, triggered automatically.
- Added some more internal data validation to the MPLocation


## [2.1.1] 2018-09-07
### Fixed
- Fixed an issue where occasionally rendered routes where not fitted properly inside the screen.
- Fixed an issue where occasionally the selected location and search results would fail to appear.
- Heading indicator on the "my position" marker is now only shown when heading data is available; would point straight north previously.

## [2.1.0] 2018-08-21
### Changed
- Changed how icons and labels are shown on the map, so that no labels or icons are shown on top of each other (Icon & label collision handling)
- Now supporting different icon sizes as recieved from CMS
- Now able to show outlines of rooms and areas if the dataset is prepared for this
### Added
- Basic voiceover/accessibility support.
### Fixed
- Fixed MPLocationQuery.orderBy was not respected.

## [2.0.4] 2018-06-27
### Fixed
- Fixed a major bug that caused the generated Swift interface in XCode to expose assumed nonnull properties in various areas of the interface
- Fixed an issue that was causing `MPDirectionsService` to return routes with duplicate legs for some routes between different venues
- Fixed an issue where in rare cases one of the internal callbacks in MapControl was not called causing the map to not fire the optional `[MPMapControlDelegate mapContentReady]`
### Changed
- A lot of properties have now become nullable because of the FIX needed above

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

