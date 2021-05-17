---
title: iOS SDK v3 Changelog
permalink: /changelogs/ios/v3/
eleventyNavigation:
  key: iOS SDK v3 Changlog
  parent: changelogs
  order: 3
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

## [3.27.0] 2021-05-17

### Fixed

- Fixed an issue causing the user position (blue dot) to be displayed with full opacity where it should be displayed as semi-transparent.
- Fixed an issue causing with the `MPFilter.parents` filter to return unexpected results.
- Fixed an issue causing Live Data badges from the default rendering to get different sizes depending on the original image.
- Fixed mis-alignment of text instructions for offline and online directions.
- Fixed an issue causing `MPMapControl` to lock the maps view port to a search result of a single Location.
- Improved the ranking of search results.
- Small performance improvements.

## [3.24.0] 2021-04-15

### Added

- Added new default renderings of Temperature and Count Domains. For more information about Live Data, read about the feature in the [Live Data Guide](https://docs.mapsindoors.com/ios/v3/live-data/).

## [3.23.0] 2021-04-06

### Fixed

- Fixed an occasional crash issue caused by changing the text size through the accessibility settings while showing a map.
- Fixed an issue causing Live Data to not appear when enabled under offline conditions and getting connectivity at a later stage.
- Fixed a parameter assertion causing a crash in `MPLocationsProvider`.

### Changed

- Changed some Location polygon styling defaults. To customize the styling of polygons, see this [guide about map styling](https://docs.mapsindoors.com/ios/v3/map-styling/).

## [3.22.0] 2021-03-18

### Fixed

- Fixed an issue with our offline bundling feature causing languages to be mixed on first install and start of the application using the SDK with offline bundling.

### Changed

- A map label will now be centered when the icon is hidden for a given Location.
- When Live Data is enabled for both `occupancy` and `availability`, the default rendering will now combine these two into a visualisation where it is possible to see if a room is booked and how many people are in the room.

## [3.20.0] 2021-03-05

### Changed

- Changed the default map label font to Arial to fix a rendering issue with the original default font. The choice of Arial font aligns well with rendering on a Google Map. If you need to change this, use `MPMapControl.mapLabelFont`
- Changed the default map label font size to 14 points.
- `MPMapControlDelegate` method `didTapAtCoordinate(withLocations:)` now calls back on both map and marker tappings.

### Fixed

- Fixed some map label rendering artifacts when rendering the system font with a stroke as the map label font.
- Fixed some Live Data related stability issues.
- Fixed a caching issue causing some Locations to get the same icon.

## [3.19.0] 2021-02-24

### Changed

- `MPLocationService` now accounts for vertical proximity when `near` (z value) parameter is provided with `MPQuery`.

### Fixed

- Fixed a map rendering issue where icons would appear/disappear in a flaky and not intuitive manner.
- Fixed an issue with custom Display Rules not being properly rendered.
- Fixed an issue in the Live Data convenience methods in `MPMapControl`, causing Live Data subscriptions not to be updated a Floor level change.
- Fixed an issue causing the default Live Data rendering to skip Locations that were previously not shown.

## [3.18.0] 2021-02-05

### Added

- Added a `floorName` property on `MPLocation`.

### Changed

- Changed the default icon for a Location where it is not possible to determine a specific icon.
- Changed `iconUrl` on `MPLocation` so that it will conveniently return either specific icon url or the icon url for the corresponding Location Type.

## [3.17.0] 2021-01-21

### Added

- Added an `address` property on `MPBuilding` which can be set in MapsIndoors CMS.

### Fixed

- Fixed a date bug in the `MPBookingService` causing the service to query for available Locations with a wrong date, offset by one hour from the intended date.
- Fixed a bug preventing display of info windows for Locations that should not have an icon nor a label.
- Improved various elements of our search engine.

### Changed

- Changed the default selection highlight color for Locations with a polygon shape. See [more about the UX decision behind it here](https://blog.mapspeople.com/new-selection-highlight-color). To customize the highlight color see this [guide about map styling](https://docs.mapsindoors.com/ios/v3/map-styling/#modify-the-display-rule-for-the-selected-location).

## [3.16.1] 2021-01-04

### Added

- Added convenience methods for enabling Live Data for a `MPMapControl` instance. Methods are `MPMapControl.enableLiveData()` (two variants) and `MPMapControl.disableLiveData()`. For more information, read about this feature in the [Live Data Guide](https://docs.mapsindoors.com/ios/v3/live-data/).
- Added default rendering of Live Data when using the above interface.
- Added optional method `updateLiveDataInfo` to `MPLiveDataManager`. This makes it possible to fetch updated information about active Live Data Domain Types in the current dataset.
- Added optional method `didUpdateLiveDataInfo` to `MPLiveDataManagerDelegate`. This makes it possible to receive updated information about active Live Data Domain Types in the current dataset.
- When developing with Live Data, you can now use/cast to subclasses of `MPLiveUpdate`: `MPPositionLiveUpdate`, `MPOccupancyLiveUpdate`, `MPAvailabilityLiveUpdate`.
- Added `types` and `locations` filter to `MPLocationService`.
- Now returning an error from `MPLocationService` if a Location Source status changes to `unavailable`.
- Added property `positionProviderConfigs` on `MPSolution` model.
- Added property `dataSetId` on `MPSolution` model.
- Added property `isIndoors` on `MPLocation` model, returning true if location is indoors and belongs to a building.

### Changed

- Made `didReceiveLiveUpdate` on `MPLiveDataManagerDelegate` optional.
- Deprecated `MPLocationsProvider`. You can/should use `MPLocationService` instead.
- Instead of ignoring Topics with Domain Types that are not relevant/active for current dataset, `MPLiveDataManager` will now throw an error through the delegate instead.

### Fixed

- Fix `bbox` getter returning `nil` on `MPMultiPolygonGeometry` and `MPPolygonGeometry`
- Fixed occasional crash in `MPBooking` deserialization.
- Improved search and filtering quality of the search engine in `MPLocationService`.

## [3.15.0] 2020-11-12

### Added

- Support for Booking of Locations through a MapsIndoors Google Calendar Booking Provider, see [guide about booking](https://docs.mapsindoors.com/ios/v3/booking/).

## [3.14.0] 2020-11-11

### Added

- Support for global App User Roles setting, `MapsIndoors.userRoles`, see [introduction to App User Roles here](https://docs.mapsindoors.com/ios/v3/app-user-roles/).

### Fixed

- Fixed an issue causing `MapsIndoors.synchronizeContent` to call its completion handler too early.
- Fixed an issue causing outdoor locations to only show on floor index 0.
- Fixed an issue where map imagery was disappearing in some cases and datasets.
- Boosted the pathfinding performance of `MPDirectionsService`.
- Fixed an issue with network issues causing occational UI freeze in Live Data sessions.

### Changed

- `MPLocation.imageUrl` deprecation has been revoked.

## [3.13.0] 2020-10-14

### Added

- Support for Rendering of Polygons through Display Rules, see [updated guide about map styling](https://docs.mapsindoors.com/ios/v3/map-styling/).

### Fixed

- Fixed an issue causing our route to go through walls in some cases. Sure hope we didn't cause any accidents:)
- Fixed a logging issue causing obsolete logs to spam the console.
- Fixed a rare issue causing a Live Data session to freeze in the UI thread.
- Fixed an issue causing some Live Updates to be discarded unintentionally.
- Fixed an issue causing some Live Updates to be emitted unintentionally while they should have been discarded.
- Fixed offline data script so that it handles external ressources better.
- Fixed some general stability issues

## [3.12.0] 2020-09-30

### Added

- Support for Live Data added. For more information, read about this feature in the [Live Data Guide](https://docs.mapsindoors.com/ios/v3/live-data/).

## [3.11.1] 2020-09-28

### Added

- In `MPDatasetCacheManager` we have optimized support for changing caching scope from a larger scope to a smaller scope, by deleting obsolete caches.

### Fixed

- Fixed that route end marker on `MPDirectionsRenderer` was obscuring the destination location marker.
- Fixed an issue causing `MPDirectionsRenderer` not to use the `MPDirectionsRenderer.actionPointImages` in some cases.
- Fixed a data synchronisation issue that caused the newly synchronised data to not being used before a new session was initiated.
- Fixed a route path optimization issue that caused the optimization to be applied unintentionally in some cases.
- Fixed a search issue that caused the search engine to ignore `MPLocation.externalId`.
- Fixed a routing issue that caused the `MPDirectionsRenderer` to show a wrong the next leg marker.
- Fixed an issue causing the Info Window of `MPMapControl.selectedLocation` to not show up in some cases.
- Fixed an internal issue with the map marker collision handling.
- Some internal refactorings and optimizations.

## [3.9.9] 2020-08-31

### Fixed

- Fixed issues causing `MPMapControl` to not properly clean up content on the map when `MapsIndoors.provideAPIKey()` is called while a `MPMapControl` instance is already initialized.
- Fixed issue causing `MPMapControl.selectedLocation` to not properly highlight on the map in some cases.
- Internal search engine optimizations and improvements.

## [3.9.7] 2020-08-19

### Fixed

- Fixed a race condition occurring in some poor networking conditions causing `MPMapControl` not to properly show its initial building outline.
- Other internal stability improvements.

## [3.9.6] 2020-07-06

### Fixed

- Fixed indoor routes with stairs leading to the same Floor would omit the stair steps.

## [3.9.5] 2020-07-02

### Added

- Added a helper method on `MPLocation` to retrieve fields using case-insenitive keys: `location.getField(forKey: "key")`

## [3.9.4] 2020-06-24

### Fixed

- Fixed an issue that caused search functionality to stop working after receiving a low memory warning.
- Fixed an issue that caused some map location images to show at wrong locations in some cases.

### Changed

- Venue labels now show only for zoom levels 10 to 15 (exclusively)

## [3.9.3] 2020-06-16

### Changed

- Routes rendered on the map with `MPDirectionsRenderer` now have rounded curves when directions on the route change.

### Fixed

- Fixed a crash in `MPDirectionsRenderer` that happened when new routes were applied in quick succession.
- Fixed a problem synchronising multiple datasets simultaneously.

## [3.9.2] 2020-06-02

### Fixed

- Synchronizing new data would not take in current app session.

## [3.9.1] 2020-05-18

### Fixed

- Too many wayfinding steps were emitted for routes with slight curvature.

## [3.9.0] 2020-05-04

### Added

- Support for caching offline data for multiple datasets. See `MapsIndoors.dataSetCacheManager` and [https://docs.mapsindoors.com/ios/v3/offline/](https://docs.mapsindoors.com/ios/v3/offline/) for more details.

### Changed

- Updated Google Maps dependency to Google Maps 3.8.0

## [3.8.3] 2020-03-05

### Fixed

- Fixed an issue that would make devices with iOS 10 crash occasionally.

## [3.8.2] 2020-03-02

### Fixed

- Fixed an issue where the rendered route part would sometimes not be fully visible.
- Fixed a problem with loading maptiles embedded in apps at first launch of app.
- Fixed an directions issue where the reversed directions request (swapping origin and destination) could sometimes not be calculated.

### Added

- Added an ExternalId property `MPLocation.externalId`. This field is used for identifying each location on a matter that is external to MapsIndoors. The ExternalId is maintained in MapsIndoors CMS.

### Changed

- Deprecated `MPLocation.roomId`. `MPLocation.externalId` is to be used instead.

## [3.8.1] 2020-02-04

### Fixed

- Some searches unfortunately ended in a crash related to data inconsistency.
- Directions completion handler was sometimes on the main queue.
- Improved detection of start and end rooms on a route.
- Script for embedding data for offline use would download all referenced URLs but should only download referenced images and maptiles.

## [3.8.0] 2020-01-24

### Changed

- Improved route generation; improved detection of start and end rooms for indoor route, and improved rendering of route start and endpoints.

## [3.7.2] 2019-01-09

### Fixed

- Applying  `MPMapControl.setDisplayRule(:forLocation:)` for one or more locations that was already hidden by default would not change the locations visibility. This is now fixed.

## [3.7.1] 2019-12-05

### Added

- Added `MPMapControl` now has new functionality for temporarily changing the `MPDisplayRule` for individual `MPLocations`.  See `MPMapControl.setDisplayRule(:forLocation:)`, `MPMapControl.resetDisplayRuleForLocation()` and similar methods.

### Changed

- Multiple improvements to the search engine has been implemented.

## [3.6.2] 2019-11-18

### Fixed

- Fixed a memory leak happening when switching Solution or API key.
- Fixed `MPMapControl` is now more resilient against `GMSMapView.delegate` being changed.
- [This issue](https://forums.developer.apple.com/thread/123003) made our SDK crash if built with XCode 10 and below. We have implemented a workaround in this version.
- Fixed Restored previous behaviour where the map settles on a building and showing the floor selector initially.
- Fixed Improved switching between different Solutions / API keys.

## [3.6.1] 2019-11-05

### Fixed

- Fixed synchronisation issue, that sometimes caused map graphics to disappear, if the app was shut down in the middle of a synchronisation.
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

- Updated Google Maps SDK from 3.1.0 to 3.3.0 (see <https://developers.google.com/maps/documentation/ios-sdk/releases> for details).
- Default Google Maps styling is now applied to the map, so that we hide Google Maps icons that usually compete with, confuse or disturb the appearance of MapsIndoors location icons.

### Added

- Support for building default floors.
- Support for profile-based routing.
- Support for travelmode specific venue entrypoints, so e.g. driving routes can go via parking lots (require data configuration).

### Fixed

- Fixed an issue with loading Solution data from the MapsIndoors backend.
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

- MPMapControlDelegate now has a new method for notifying about which building is focused on the map  `MPMapControlDelegate.focusedBuildingDidChange()`
- MPMapControlDelegate now has a new method for notifying position updates  `MPMapControlDelegate.onPositionUpdate()`

### Changed

- MPMapControl.currentPosition has been deprecated; use MapsIndoors.positionProvider.latestPositionResult to know current position.

### Fixed

- Fixed an issue related to MPLocations using the default displayrule as well as their own icon.
- Fixed an issue causing MPLocationUpdate/MPLocation to always set floor index to zero on updates.

## [3.0.0] 2019-03-04

### Added

- Support for external location data sources using `MapsIndoors.registerLocationSources()`
- New location service `MPLocationService` to replace `MPLocationsProvider`
- Location clustering support using `MPMapControl.locationClusteringEnabled`
- Added building and venues to the search experience

### Changed

- MPLocation properties are now read only

### Removed

- Removed a number of deprecated methods that was introduced in V1
