# Changelog
Changelog for MapsIndoors for iOS. This document structure is based on [Keep a Changelog](http://keepachangelog.com/en/1.0.0/).

<!---
## [Unreleased]
### Added
### Fixed
### Changed
### Removed
-->

## [2021.1.29] 2020-01-29

### Added

- LIVE DATA INTEGRATIONS. MapsIndoors now accommodate live data from iOT sensors, and facilitates viewing the live status of things like meeting room availability, number people in a room, temperature and so on.
- RESOURCE BOOKING SERVICE INTEGRATION. MapsIndoors provides integration of room/resource booking, for example for meeting room booking.
- USER ROLES. User roles can impact what you can see on the map, search for and get directions to.

### Fixed
- Loads of bug-fixing, related to search, routing and more.

## [2020.9.30] 2020-09-30

### Added
- Initial support for Live Data. The app will show Live room occupancy data and position updates if available in the building.

## [2020.9.24] 2020-09-24

### Added
- Added option to add a help ressource url in the app info section.
- In the Dataset Management section we have optimized support for changing caching scope from a larger scope to a smaller scope, by deleting obsolete caches.

### Fixed

- Fixed various route rendering issues, e.g. route end marker was obscuring the destination location marker.
- Fixed a data synchronisation issue that caused the newly synchronised data to not being used before a new session was initiated.
- Fixed a route path optimization issue that caused the optimization to be applied unintentionally in some cases.
- Fixed a search issue that caused the search engine to ignore external ids.
- Fixed an issue causing the Info Window of selected location to not show up in some cases.
- Fixed an internal issue with the map rendering (marker collision handling).
- Some internal refactorings and optimizations.

### Changed

- Update to MapsIndoors SDK 3.11.1.

## [2020.2] 2020-02-04

### Update to MapsIndoors SDK 3.8.1
### Fixed
- Stability and performance improvements.

### Changed
- Improved route generation; improved detection of start and end rooms for indoor route, and improved rendering of route start and endpoints.
- Multiple improvements to the search engine has been implemented.
- Changed version scheme.

## [2.2.4] 2019-11-05
### Fixed
- Fixed synchronisation issue, that sometimes caused map graphics to disappear, if the app was killed in the middle of a synchronisation.
- Fixed directions rendering issue causing the map camera to display random parts of the Google map instead of the route that was intended to be rendered.
- Fixed some inconsistencies in how non-quadratic icons was anchored on the map.
### Changed
- Locations can now be configured as not searchable (configured from the MapsIndoors service), which in effect makes them eligible for map display but not searchable in the app.

## [2.2.3] 2019-08-16

### Fixed
- Fixed regression causing search url scheme not to work anymore, e.g. "myapp://search?q=Room123"

## [2.2.1] 2019-08-16

### Fixed
- Fixed some memory related crashes

## [2.2.0] 2019-08-08

### Added
- Map rendering now respects default floor per building configured in the MapsIndoors CMS
- Map rendering can perform clustering of location icons if enabled through the MapsIndoors CMS
- The map can now track user position and render relevant route part if indoor positioning is applicable
- Navigation can now find a nearest Parking lot when requesting directions by car
- Navigation now respects profile settings configured in the MapsIndoors CMS
- Navigation now respects locked doors configured in the MapsIndoors CMS
- Navigation now respects wait times configured in the MapsIndoors CMS
- Optimised directions requests in general
- The app is now WCAG "AA" compliant

### Changed
- Floor Selector now remains hidden until User interacts with Map (applies to Application Start and when selecting Venues) 
- Updated the Clear Map appearance and behaviour to become more intuitive and helpful
- The application now clears memory caches on low-memory warnings
- Implemented data integrity checks in to avoid corrupted data in the application cache

### Fixed
- Fixed a number of memory issues
- Various performance improvements throughout the entire application
- Improved offline search engine to give more meaningful results
- Improved List rendering
- Travel mode restrictions was sometimes not set correctly
- Some display settings performed in the MapsIndoors CMS was not affecting the intended change
- Infowindow popped up every time map was panned around with searchResult of 1 element
- Locations types with Visibility disabled was sometimes still displayed and clickable
- Advanced Icons was sometimes rendered twice upon clicking on a Room with a hidden Icon
- Some instructions in map labels for a requested route was incorrect
- Outlining the building in focus was sometimes inaccurate
- Sometimes the selected location failed to appear momentarily, as well as search results
- After browsing a category, free text search was unintentionally cleared when going back from details view
- Building Highlights/Outlines was difficult to discern even when zooming in
- Return to Venue was displayed when panning/moving away from a selected location
- Disabling Location Service blocked User from using Application
- Title of category was not updated when selecting category through quick access / floating menu
- Tapping on Information Window did not center view based on selected location
- "No Matches for..." warning was unintentionally displayed before populating the list with locations
- Advanced Icon tied to Destination retained on Map upon clearing Route
- Icon was not de-selected when selecting another Floor
- Google Maps logo was covered by my location and MapsPeople logo was misplaced on iPhone XR
- Fixed weird "jump" on the map when selecting route part

## [2.1.0] 2018-09-07

### Fixed
- Fixed issue causing "Clear Map" button not to appear on iOS < 11
- Increased shading behind venue select icon and app info icon
- Improved contrast on "show on map" button
- Fixed cases where distance rounding gave wrong and inconsistent results
- Fixed that category search results where not cleared after deleting letters in the search input field
- Fixed some issues in third party libraries that caused the app to crash under certain circumstances

### Changed
- Disable venueselector button when no venue has been selected
- Relevance-based sorting of POI-lists are now based on distance to user location
### Added
- A lot of accessibility improvements
- Updated MI SDK to 2.1.1

## [2.0.2] 2018-06-23

### Fixed
- Fixed an issue that was causing duplicate segments for some routes between different venues
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
