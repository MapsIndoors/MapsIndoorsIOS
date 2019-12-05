---
title: Changelog
layout: default
published: true
nav_weight: 1000
---

Changelog for MapsIndoors for iOS. This document structure is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/) and the project adheres to [Semantic Versioning](http://semver.org/spec/v2.0.0.html).

<!---
## [Unreleased]
### Fixed
### Added
### Fixed
### Changed
### Removed
-->

> Known Issues:
1. If you are compiling with Xcode 11 with bitcode ON, you should either switch OFF bitcode or update to version 3.6.0 or later. With bitcode ON, previous versions of the SDK could crash. We are in dialog with Apple regarding the bitcode issue.
2. [This issue](https://forums.developer.apple.com/thread/123003) makes our SDK crash if built with XCode 10 and below. We implement a workaround in 3.6.2. An immediate workaround for you is to build with XCode 11. 
{: .mi-careful}

## [3.7.1] 2019-12-05
### Added
- Added `MPMapControl` now has new functionality for temporarily changing the `MPDisplayRule` for individual `MPLocations`.  See `-[MPMapControl setDisplayRule:forLocation:]`, `-[MPMapControl resetDisplayRuleForLocation:]` and similar methods.  
### Changed
- Multiple improvements to the search engine has been implemented. 

## [3.6.2] 2019-11-18
### Fixed
- Fixed a memory leak happening when switching solution / api-key.
- Fixed `MPMapControl` is now more resilient against `GMSMapView.delegate` being changed.
- [This issue](https://forums.developer.apple.com/thread/123003) made our SDK crash if built with XCode 10 and below. We have implemented a workaround in this version. 
- Fixed Restored previous behaviour where the map settles on a building and showing the floor selector initially.
- Fixed Improved switching between different solutions / api keys.

## [3.6.1] 2019-11-05
### Fixed
- Fixed synchronisation issue, that sometimes caused map graphics to disappear, if the app was killed in the middle of a synchronisation.
- Fixed directions rendering issue causing the map camera to display random parts of the Google map instead of the step or leg that was intended to be rendered.
- Fixed some inconsistencies in how non-quadratic icons was anchored on the map.
### Changed
- Locations can now be configured as searchable (from the backend), which in effect makes them eligible for map display but not retrievable from a search query through `MPLocationService`.

## [3.6.0] 2019-10-10
### Fixed
- `MPDirectionsQuery.init(originPoint:MPPoint, destPoint:MPPoint)` could produce origins and destinations on level 0, resulting in incorrect route results.
### Changed
- Compiled with Xcode 11 for iOS 13
- Internal refactoring to improve memory and threading error resilience.

## [3.5.0] 2019-09-25
### Added
- Added `depth` property to `MPFilter`, used with the `parents` property, making it possible to e.g. get all buildings and floors within a venue (depth 2) or get only floors within a building (depth 1).
- Added the ability to control the visibility of map icons and map labels independently, through `MPLocationDisplayRule.showIcon` and  `MPLocationDisplayRule.showLabel`.
- Added property `locationBaseType` on `MPLocation`, making it possible to dstinguish buildings from venues, floors from rooms, areas from POIs etc.
### Fixed
- Fixed issue with info window disappearing after location selection when search result is currently rendered.
- Fixed some internal concurrency issues.

## [3.3.1] 2019-09-15
### Changed
- InfoWindows presented on the map is now made fully visible if needed - this changes the presented map area.
### Fixed
- Fixed location data was only synced once per session, regardless of explicit calls to `MapsIndoors.synchronizeContent()`.

## [3.3.0] 2019-08-30
### Added
- Support for custom fields on venues, buildings and categories (writable from the MapsIndoors Data API).

## [3.2.0] 2019-08-20
### Changed
- Updated Google Maps SDK from 3.1.0 to 3.3.0 (see https://developers.google.com/maps/documentation/ios-sdk/releases for details).
- Default Google Maps styling is now applied to the map, so that we hide Google Maps icons that usually compete with, confuse or disturb the appearance of MapsIndoors location icons.
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
- Fixed info window not appearing for selectedLocation after several API key switches.

## [3.1.1] 2019-06-21
### Fixed
- Fixed `MPMapControl.go(to:MPLocation)` so that the map now properly fits locations with polygons.
- Fixed dataset switching sometimes not working due to re-initialisation not properly executed behind the scenes.
- Fixed memory issues related to entering and leaving a MapsIndoors map multiple times in the same session.
- Adding custom `MPLocationDisplayRule` not affecting size and rank changes due to a race condition.
- Fixed a problem with transitioning from a Google route to a MapsIndoors route.

## [3.1.0] 2019-06-04
### Added
- Added a `MPGeometryHelper` class.
- Added a way to get polygons for locations using `MPGeometryHelper.polygonsForLocation(location:MPLocation)`.
- Updated Google Maps dependency to version 3.1.0.
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

