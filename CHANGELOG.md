# MapsIndoors iOS SDK v3

### \[3.50.4] 2024-03-22[​](https://docs.mapsindoors.com/changelogs/ios#3504-2024-03-22) <a href="#3503-2023-11-22" id="3503-2023-11-22"></a>

#### Fixed
- Use of JSONModel library in MapsIndoors no longer prevents using it in your own app or using other libraries that also use JSONModel.

### \[3.50.3] 2023-11-22[​](https://docs.mapsindoors.com/changelogs/ios#3503-2023-11-22) <a href="#3503-2023-11-22" id="3503-2023-11-22"></a>

#### Added
- Property `hideIconsOverlappingRoute` added to MPMapControl making it possible to control if Location icons are allowed to be shown on top of the rendered route.

#### Fixed
- Locations with a 2D Model are now fully tappable.

### \[3.50.2] 2023-10-05[​](https://docs.mapsindoors.com/changelogs/ios#3502-2023-10-05) <a href="#3502-2023-10-05" id="3502-2023-10-05"></a>

#### Fixed

- Locations only represented with a 2D Model now correctly display info window upon tap.

### \[3.50.1] 2023-05-10[​](https://docs.mapsindoors.com/changelogs/ios#3501-2023-05-10) <a href="#3501-2023-05-10" id="3501-2023-05-10"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-10) <a href="#fixed-10" id="fixed-10"></a>

* DisplayRules inheriting visibility from the Location type will now be shown.

### \[3.50.0] 2023-04-26[​](https://docs.mapsindoors.com/changelogs/ios#3500-2023-04-26) <a href="#3500-2023-04-26" id="3500-2023-04-26"></a>

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-1) <a href="#changed-1" id="changed-1"></a>

* The minimum supported iOS version is now iOS 11.
* The MapsIndoors XCFramework is now built with Xcode 14.2. This is due to [the Apple announcement](https://developer.apple.com/news/?id=jd9wcyov) that from April 25 all apps submitted to the App Store must be built with Xcode 14.1 or later.
* MapsIndoors now sports the new MapsPeople logo.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-11) <a href="#fixed-11" id="fixed-11"></a>

* 2D Models will now show for POIs as well.
* Removed potential crash in some circumstances related to offline assets.

### \[3.43.3] 2023-03-08[​](https://docs.mapsindoors.com/changelogs/ios#3433-2023-03-08) <a href="#3433-2023-03-08" id="3433-2023-03-08"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-12) <a href="#fixed-12" id="fixed-12"></a>

* MapsIndoors will no longer crash on initialisation if there is no network connection.

### \[3.43.2] 2023-03-03[​](https://docs.mapsindoors.com/changelogs/ios#3432-2023-03-03) <a href="#3432-2023-03-03" id="3432-2023-03-03"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-13) <a href="#fixed-13" id="fixed-13"></a>

* 2D Models will now render in their proper place in the rendering stack to avoid being overlapped by polygons.

### \[3.43.1] 2022-11-09[​](https://docs.mapsindoors.com/changelogs/ios#3431-2022-11-09) <a href="#3431-2022-11-09" id="3431-2022-11-09"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-7) <a href="#added-7" id="added-7"></a>

* We added the method `provideAPIKey:googleAPIKey:completionBlock:` that will validate the MapsIndoors API key before returning control of flow to the app.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-14) <a href="#fixed-14" id="fixed-14"></a>

* Default images for MapsIndoors are now shown properly, including the User Position (blue dot). This also fixes an issue that prohibited making a custom User Position Display Rule.

### \[3.43.0] 2022-11-03[​](https://docs.mapsindoors.com/changelogs/ios#3430-2022-11-03) <a href="#3430-2022-11-03" id="3430-2022-11-03"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-8) <a href="#added-8" id="added-8"></a>

* We added a new method on MPLocationService: `getLocationsByExternalIds:`.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-15) <a href="#fixed-15" id="fixed-15"></a>

* A single network call had snuck on to the main thread. It has now been relegated to the background so Xcode 14 will no longer tell you that MapsIndoors is behaving badly.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-2) <a href="#changed-2" id="changed-2"></a>

* The images for 2D Models are now fetched only with the DataSetManager meaning less device storage is claimed when using 2D Models.

### \[3.42.0] 2022-10-13[​](https://docs.mapsindoors.com/changelogs/ios#3420-2022-10-13) <a href="#3420-2022-10-13" id="3420-2022-10-13"></a>

_**Note: Due to**_ [_**a bug in CocoaPods**_](https://github.com/CocoaPods/CocoaPods/issues/7155) _**it is necessary to include the post\_install hook in your Podfile described in the**_ [_**PodFile post\_install**_](https://github.com/MapsIndoors/MapsIndoorsIOS/wiki/Podfile-post\_install) _**wiki**_

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-9) <a href="#added-9" id="added-9"></a>

* Support for 2D Models on Locations.
* The SDK version number is now included in the XCFramework in the Info.plist for each architecture.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-16) <a href="#fixed-16" id="fixed-16"></a>

* Fixed a bug that would potentially exclude certain topics from being subscribed to via the LiveDataManager.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-3) <a href="#changed-3" id="changed-3"></a>

* The XCFramework no longer has dependencies on any other 3rd party libraries than Google Maps making it much easier to integrate MapsIndoors in your project. This also applies to the Cocoapod version, although dependencies are managed by Cocoapods.

### \[3.41.0] 2022-07-27[​](https://docs.mapsindoors.com/changelogs/ios#3410-2022-07-27) <a href="#3410-2022-07-27" id="3410-2022-07-27"></a>

_**Note: Due to**_ [_**a bug in CocoaPods**_](https://github.com/CocoaPods/CocoaPods/issues/7155) _**it is necessary to include the post\_install hook in your Podfile described in the**_ [_**PodFile post\_install**_](https://github.com/MapsIndoors/MapsIndoorsIOS/wiki/Podfile-post\_install) _**wiki**_

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-10) <a href="#added-10" id="added-10"></a>

* We added a new delegate `MPLocationServiceDelegate` with a `locationsReady` callback invoked when the Locations in the current Solution are all loaded and ready to be worked with, e.g. search in them.
* We added a new `locationSourceStatus` property to `MPLocationService` that can be checked to see if Locations in the current Solution are all loaded and ready to be worked with, e.g. search in them. This is an alternative to using the `MPLocationServiceDelegate.locationsReady` delegate callback.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-4) <a href="#changed-4" id="changed-4"></a>

* The SDK now queries the MapsIndoors backend to determine which cache endpoint will respond the fastest to future queries from the SDK. This will be done once per app launch.

### \[3.40.0] 2022-06-27[​](https://docs.mapsindoors.com/changelogs/ios#3400-2022-06-27) <a href="#3400-2022-06-27" id="3400-2022-06-27"></a>

_**Note: Due to**_ [_**a bug in CocoaPods**_](https://github.com/CocoaPods/CocoaPods/issues/7155) _**it is necessary to include the post\_install hook in your Podfile described in the**_ [_**PodFile post\_install**_](https://github.com/MapsIndoors/MapsIndoorsIOS/wiki/Podfile-post\_install) _**wiki**_

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-11) <a href="#added-11" id="added-11"></a>

* We added forwarding of the missing Google Map View Delegate methods. Now all delegate methods are supported.
* We added the possibility to use Google API keys that are restricted to an iOS app, as Google recommends.
* We added support for any HighwayType in `avoidWayTypes` so it is possible to avoid e.g. elevators specifically.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-17) <a href="#fixed-17" id="fixed-17"></a>

* We fixed an issue where it was not possible to get a route from an external location to a MapsIndoors Location if all entries are restricted by user roles.

### \[3.39.0] 2022-03-31[​](https://docs.mapsindoors.com/changelogs/ios#3390-2022-03-31) <a href="#3390-2022-03-31" id="3390-2022-03-31"></a>

_**Note: Due to**_ [_**a bug in CocoaPods**_](https://github.com/CocoaPods/CocoaPods/issues/7155) _**it is necessary to include the post\_install hook in your Podfile described in the**_ [_**PodFile post\_install**_](https://github.com/MapsIndoors/MapsIndoorsIOS/wiki/Podfile-post\_install) _**wiki**_

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-12) <a href="#added-12" id="added-12"></a>

* We added an enum for `MPHighwayType`, so it is now easy to know which values are valid to use.
* We added the possibility to get the `translatedName` property of Location Types.
* We added the method `MPVenue.hasGraph` so it can be checked if there is a routing network available on a solution to get directions.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-5) <a href="#changed-5" id="changed-5"></a>

* A number of headers have been made private to reduce clutter in the reference documentation.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-18) <a href="#fixed-18" id="fixed-18"></a>

* We made the standard floor selector control always update to the correct floor.

### \[3.38.0] 2022-01-10[​](https://docs.mapsindoors.com/changelogs/ios#3380-2022-01-10) <a href="#3380-2022-01-10" id="3380-2022-01-10"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-13) <a href="#added-13" id="added-13"></a>

* We added support for `escalators` in `MPDirectionsQuery.avoidWayTypes`.

### \[3.37.1] 2021-12-21[​](https://docs.mapsindoors.com/changelogs/ios#3371-2021-12-21) <a href="#3371-2021-12-21" id="3371-2021-12-21"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-19) <a href="#fixed-19" id="fixed-19"></a>

* We fixed an issue where selecting a Location with `MPMapcontrol.selectedLocation` would not obey the current zoom level.

### \[3.37.0] 2021-12-20[​](https://docs.mapsindoors.com/changelogs/ios#3370-2021-12-20) <a href="#3370-2021-12-20" id="3370-2021-12-20"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-20) <a href="#fixed-20" id="fixed-20"></a>

* We fixed an issue where the shown route could have an unintended starting point.
* We fixed an issue where the selected Location would not be properly selected if it had been set to `nil` shortly before.
* We fixed an issue where the html instructions for a route was not identical to the route leg description.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-6) <a href="#changed-6" id="changed-6"></a>

* The default value for `MPFilter.take` has been changed from 25 to unlimited.
* The default value for `MPDirectionsRendererContextualInfoSettings.maxDistance` has been changed from 0 to 5 meters.

### \[3.36.0] 2021-11-15[​](https://docs.mapsindoors.com/changelogs/ios#3360-2021-11-15) <a href="#3360-2021-11-15" id="3360-2021-11-15"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-21) <a href="#fixed-21" id="fixed-21"></a>

* We fixed an issue where MapsIndoors would crash while calculating a route.
* We fixed an issue where location specific icons could disappear.
* We fixed an issue where the correct floor (and tiles for it) would not be shown when advancing on a route.

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-14) <a href="#added-14" id="added-14"></a>

* We added support for requiring authentication for accessing MapsIndoors solution data.
* We added the ability to create room bookings associated with a specific user account rather than only anonymous bookings. This also enables the possibility to delete bookings.
* We added a possibility to show specific contextual information on the map along a route. You can choose to show icon, label or both.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-7) <a href="#changed-7" id="changed-7"></a>

* The `MPLocationDisplayRule.labelWidth` attribute added in 3.35.0 has been renamed to `MPLocationDisplayRule.labelMaxWidth`.
* It is now not possible to change user roles while worknig in offline mode.

### \[3.35.0] 2021-10-29[​](https://docs.mapsindoors.com/changelogs/ios#3350-2021-10-29) <a href="#3350-2021-10-29" id="3350-2021-10-29"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-22) <a href="#fixed-22" id="fixed-22"></a>

* We fixed an issue in the floor selector causing the scroll indicator to be shown when only few levels.
* We fixed a rendering issue with live data badges when location is unoccupied.

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-15) <a href="#added-15" id="added-15"></a>

* We added support for multiple lines in labels on the map by including a "\n" as part of the Location name or by setting `MPLocationDisplayRule.labelWidth`.

### \[3.34.0] 2021-09-28[​](https://docs.mapsindoors.com/changelogs/ios#3340-2021-09-28) <a href="#3340-2021-09-28" id="3340-2021-09-28"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-23) <a href="#fixed-23" id="fixed-23"></a>

* We fixed a layout issue in the floor selector causing large (>4 characters) floor names to be truncated.
* We fixed a Location selection issue causing the Info Window to sometimes not show on selection.
* We fixed a rendering issue causing some Live Data badges to show as unintentionally large icons.
* We fixed an issue causing some icon images to not load and display on the map.
* We fixed a packaging issue causing some CocoaPods project integrations to not being able to build when using static libraries instead of frameworks in CocoaPods.
* We fixed an issue in our [Dataset Cache Manager](https://docs.mapsindoors.com/data/offline-data/offline-ios/) causing some images to not being properly fetched from cache.
* We fixed a warning about some public header files not being included by the framework umbrella header.
* We fixed some issues with the `MPRouteStep` [instructions property](https://app.mapsindoors.com/mapsindoors/reference/ios/v3/interface\_m\_p\_route\_step.html#aff76e19b8eb2de29490cf4f4ac7e4d15) not properly reflecting the recommended end-user actions.

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-16) <a href="#added-16" id="added-16"></a>

* We added support for Obstacles to our [Directions Service](https://docs.mapsindoors.com/directions/directions-service/directions-service-ios/). No interface changes are made, but the routing engine will fetch and respect Obstacles created in the MapsIndoors backbone when creating routes.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-8) <a href="#changed-8" id="changed-8"></a>

* We are now sorting search results using a more natural sorting algorithm when applicable.
* We have changed the our internal image service so that it now primarily serves higher quality remote images and resorting to potentially lower quality cached images when offline.

### \[3.33.1] 2021-08-30[​](https://docs.mapsindoors.com/changelogs/ios#3331-2021-08-30) <a href="#3331-2021-08-30" id="3331-2021-08-30"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-24) <a href="#fixed-24" id="fixed-24"></a>

* We fixed an issue causing route instructions to reflect the wrong floor when routing across several floors.

### \[3.33.0] 2021-08-24[​](https://docs.mapsindoors.com/changelogs/ios#3330-2021-08-24) <a href="#3330-2021-08-24" id="3330-2021-08-24"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-17) <a href="#added-17" id="added-17"></a>

* Added internal logging functionality in the SDK. Logging of anonymous statistics and diagnostic events will occur if enabled for the current API key. Logging may be disabled entirely by calling `MapsIndoors.eventLoggingDisabled = true`. [Read more](https://docs.mapsindoors.com/ios/v3/guides/event-logging/).
* Search for Floor aliases is now possible.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-25) <a href="#fixed-25" id="fixed-25"></a>

* Single character query works again.
* Position is now validated before drawing proximity circle, preventing app crashes in certain circumstances.
* Location images are now always presented in best quality available.
* Route descriptions are now consistent for floor changes.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-9) <a href="#changed-9" id="changed-9"></a>

* `administrativeId` is now provided as supplied from the CMS instead of always being lower case.

### \[3.32.0] 2021-07-05[​](https://docs.mapsindoors.com/changelogs/ios#3320-2021-07-05) <a href="#3320-2021-07-05" id="3320-2021-07-05"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-26) <a href="#fixed-26" id="fixed-26"></a>

* Fixed missing call of the `GMSMapViewDelegate` method `markerInfoContents()`.
* Fixed an issue causing Location Updates involving floor changes to not being updated on the map.

### \[3.31.0] 2021-06-22[​](https://docs.mapsindoors.com/changelogs/ios#3310-2021-06-22) <a href="#3310-2021-06-22" id="3310-2021-06-22"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-27) <a href="#fixed-27" id="fixed-27"></a>

* Fixed an archive issue caused by missing architectures in the XCFramework.
* Fixed a rendering issue in `MPDirectionsRenderer` causing a route to be rendered at the wrong floor.
* Fixed an issue in the `MPFloorSelectorControl` causing it to not reflecting the correct floor in some cases.
* Fixed an issue causing inactive Locations to briefly appear when Live Data was imposed to them.
* Fixed an issue in `MPBookingService` causing some booked slots to appear as not booked.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-10) <a href="#changed-10" id="changed-10"></a>

* Changed default Occupancy Live Data rendering for unknown number of people.
* Improved raster image quality.
* Now defaulting to `MPMapControl.mapIconSize` in an `MPLocationDisplayRule`.

### \[3.30.0] 2021-06-07[​](https://docs.mapsindoors.com/changelogs/ios#3300-2021-06-07) <a href="#3300-2021-06-07" id="3300-2021-06-07"></a>

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-11) <a href="#changed-11" id="changed-11"></a>

* We are now distributing MapsIndoors as an XCFramework.
* This version is functionally identical to version 3.28.0.

### \[3.28.0] 2021-05-31[​](https://docs.mapsindoors.com/changelogs/ios#3280-2021-05-31) <a href="#3280-2021-05-31" id="3280-2021-05-31"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-18) <a href="#added-18" id="added-18"></a>

* Added new default renderings of live CO2 levels and humidity. For more information about Live Data, read about the feature in the [Live Data Guide](https://docs.mapsindoors.com/map/live-data/live-data-intro-ios/).

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-28) <a href="#fixed-28" id="fixed-28"></a>

* Fixed an issue causing the user position (blue dot) to be displayed with full opacity where it should be displayed as semi-transparent.
* Fixed an issue causing with the `MPFilter.parents` filter to return unexpected results.
* Fixed an issue causing Live Data badges from the default rendering to get different sizes depending on the original image.
* Fixed mis-alignment of text instructions for offline and online directions.
* Fixed an issue causing `MPMapControl` to lock the maps view port to a search result of a single Location.
* Improved the ranking of search results.
* Small performance improvements.

### \[3.24.0] 2021-04-15[​](https://docs.mapsindoors.com/changelogs/ios#3240-2021-04-15) <a href="#3240-2021-04-15" id="3240-2021-04-15"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-19) <a href="#added-19" id="added-19"></a>

* Added new default renderings of Temperature and Count Domains. For more information about Live Data, read about the feature in the [Live Data Guide](https://docs.mapsindoors.com/map/live-data/live-data-intro-ios/).

### \[3.23.0] 2021-04-06[​](https://docs.mapsindoors.com/changelogs/ios#3230-2021-04-06) <a href="#3230-2021-04-06" id="3230-2021-04-06"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-29) <a href="#fixed-29" id="fixed-29"></a>

* Fixed an occasional crash issue caused by changing the text size through the accessibility settings while showing a map.
* Fixed an issue causing Live Data to not appear when enabled under offline conditions and getting connectivity at a later stage.
* Fixed a parameter assertion causing a crash in `MPLocationsProvider`.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-12) <a href="#changed-12" id="changed-12"></a>

* Changed some Location polygon styling defaults. To customize the styling of polygons, see this [guide about map styling](https://docs.mapsindoors.com/map/map-styling/map-styling-ios/).

### \[3.22.0] 2021-03-18[​](https://docs.mapsindoors.com/changelogs/ios#3220-2021-03-18) <a href="#3220-2021-03-18" id="3220-2021-03-18"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-30) <a href="#fixed-30" id="fixed-30"></a>

* Fixed an issue with our offline bundling feature causing languages to be mixed on first install and start of the application using the SDK with offline bundling.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-13) <a href="#changed-13" id="changed-13"></a>

* A map label will now be centered when the icon is hidden for a given Location.
* When Live Data is enabled for both `occupancy` and `availability`, the default rendering will now combine these two into a visualisation where it is possible to see if a room is booked and how many people are in the room.

### \[3.20.0] 2021-03-05[​](https://docs.mapsindoors.com/changelogs/ios#3200-2021-03-05) <a href="#3200-2021-03-05" id="3200-2021-03-05"></a>

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-14) <a href="#changed-14" id="changed-14"></a>

* Changed the default map label font to Arial to fix a rendering issue with the original default font. The choice of Arial font aligns well with rendering on a Google Map. If you need to change this, use `MPMapControl.mapLabelFont`
* Changed the default map label font size to 14 points.
* `MPMapControlDelegate` method `didTapAtCoordinate(withLocations:)` now calls back on both map and marker tappings.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-31) <a href="#fixed-31" id="fixed-31"></a>

* Fixed some map label rendering artifacts when rendering the system font with a stroke as the map label font.
* Fixed some Live Data related stability issues.
* Fixed a caching issue causing some Locations to get the same icon.

### \[3.19.0] 2021-02-24[​](https://docs.mapsindoors.com/changelogs/ios#3190-2021-02-24) <a href="#3190-2021-02-24" id="3190-2021-02-24"></a>

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-15) <a href="#changed-15" id="changed-15"></a>

* `MPLocationService` now accounts for vertical proximity when `near` (z value) parameter is provided with `MPQuery`.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-32) <a href="#fixed-32" id="fixed-32"></a>

* Fixed a map rendering issue where icons would appear/disappear in a flaky and not intuitive manner.
* Fixed an issue with custom Display Rules not being properly rendered.
* Fixed an issue in the Live Data convenience methods in `MPMapControl`, causing Live Data subscriptions not to be updated a Floor level change.
* Fixed an issue causing the default Live Data rendering to skip Locations that were previously not shown.

### \[3.18.0] 2021-02-05[​](https://docs.mapsindoors.com/changelogs/ios#3180-2021-02-05) <a href="#3180-2021-02-05" id="3180-2021-02-05"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-20) <a href="#added-20" id="added-20"></a>

* Added a `floorName` property on `MPLocation`.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-16) <a href="#changed-16" id="changed-16"></a>

* Changed the default icon for a Location where it is not possible to determine a specific icon.
* Changed `iconUrl` on `MPLocation` so that it will conveniently return either specific icon url or the icon url for the corresponding Location Type.

### \[3.17.0] 2021-01-21[​](https://docs.mapsindoors.com/changelogs/ios#3170-2021-01-21) <a href="#3170-2021-01-21" id="3170-2021-01-21"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-21) <a href="#added-21" id="added-21"></a>

* Added an `address` property on `MPBuilding` which can be set in MapsIndoors CMS.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-33) <a href="#fixed-33" id="fixed-33"></a>

* Fixed a date bug in the `MPBookingService` causing the service to query for available Locations with a wrong date, offset by one hour from the intended date.
* Fixed a bug preventing display of info windows for Locations that should not have an icon nor a label.
* Improved various elements of our search engine.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-17) <a href="#changed-17" id="changed-17"></a>

* Changed the default selection highlight color for Locations with a polygon shape. See [more about the UX decision behind it here](https://blog.mapspeople.com/new-selection-highlight-color). To customize the highlight color see this [guide about map styling](https://docs.mapsindoors.com/ios/v3/map-styling/#modify-the-display-rule-for-the-selected-location).

### \[3.16.1] 2021-01-04[​](https://docs.mapsindoors.com/changelogs/ios#3161-2021-01-04) <a href="#3161-2021-01-04" id="3161-2021-01-04"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-22) <a href="#added-22" id="added-22"></a>

* Added convenience methods for enabling Live Data for a `MPMapControl` instance. Methods are `MPMapControl.enableLiveData()` (two variants) and `MPMapControl.disableLiveData()`. For more information, read about this feature in the [Live Data Guide](https://docs.mapsindoors.com/map/live-data/live-data-intro-ios/).
* Added default rendering of Live Data when using the above interface.
* Added optional method `updateLiveDataInfo` to `MPLiveDataManager`. This makes it possible to fetch updated information about active Live Data Domain Types in the current dataset.
* Added optional method `didUpdateLiveDataInfo` to `MPLiveDataManagerDelegate`. This makes it possible to receive updated information about active Live Data Domain Types in the current dataset.
* When developing with Live Data, you can now use/cast to subclasses of `MPLiveUpdate`: `MPPositionLiveUpdate`, `MPOccupancyLiveUpdate`, `MPAvailabilityLiveUpdate`.
* Added `types` and `locations` filter to `MPLocationService`.
* Now returning an error from `MPLocationService` if a Location Source status changes to `unavailable`.
* Added property `positionProviderConfigs` on `MPSolution` model.
* Added property `dataSetId` on `MPSolution` model.
* Added property `isIndoors` on `MPLocation` model, returning true if location is indoors and belongs to a building.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-18) <a href="#changed-18" id="changed-18"></a>

* Made `didReceiveLiveUpdate` on `MPLiveDataManagerDelegate` optional.
* Deprecated `MPLocationsProvider`. You can/should use `MPLocationService` instead.
* Instead of ignoring Topics with Domain Types that are not relevant/active for current dataset, `MPLiveDataManager` will now throw an error through the delegate instead.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-34) <a href="#fixed-34" id="fixed-34"></a>

* Fix `bbox` getter returning `nil` on `MPMultiPolygonGeometry` and `MPPolygonGeometry`
* Fixed occasional crash in `MPBooking` deserialization.
* Improved search and filtering quality of the search engine in `MPLocationService`.

### \[3.15.0] 2020-11-12[​](https://docs.mapsindoors.com/changelogs/ios#3150-2020-11-12) <a href="#3150-2020-11-12" id="3150-2020-11-12"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-23) <a href="#added-23" id="added-23"></a>

* Support for Booking of Locations through a MapsIndoors Google Calendar Booking Provider, see [guide about booking](https://docs.mapsindoors.com/data/booking/booking-ios/).

### \[3.14.0] 2020-11-11[​](https://docs.mapsindoors.com/changelogs/ios#3140-2020-11-11) <a href="#3140-2020-11-11" id="3140-2020-11-11"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-24) <a href="#added-24" id="added-24"></a>

* Support for global App User Roles setting, `MapsIndoors.userRoles`, see [introduction to App User Roles here](https://docs.mapsindoors.com/map/displaying-objects/app-user-roles/).

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-35) <a href="#fixed-35" id="fixed-35"></a>

* Fixed an issue causing `MapsIndoors.synchronizeContent` to call its completion handler too early.
* Fixed an issue causing outdoor locations to only show on floor index 0.
* Fixed an issue where map imagery was disappearing in some cases and datasets.
* Boosted the pathfinding performance of `MPDirectionsService`.
* Fixed an issue with network issues causing occational UI freeze in Live Data sessions.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-19) <a href="#changed-19" id="changed-19"></a>

* `MPLocation.imageUrl` deprecation has been revoked.

### \[3.13.0] 2020-10-14[​](https://docs.mapsindoors.com/changelogs/ios#3130-2020-10-14) <a href="#3130-2020-10-14" id="3130-2020-10-14"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-25) <a href="#added-25" id="added-25"></a>

* Support for Rendering of Polygons through Display Rules, see [updated guide about map styling](https://docs.mapsindoors.com/map/map-styling/map-styling-ios/).

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-36) <a href="#fixed-36" id="fixed-36"></a>

* Fixed an issue causing our route to go through walls in some cases. Sure hope we didn't cause any accidents:)
* Fixed a logging issue causing obsolete logs to spam the console.
* Fixed a rare issue causing a Live Data session to freeze in the UI thread.
* Fixed an issue causing some Live Updates to be discarded unintentionally.
* Fixed an issue causing some Live Updates to be emitted unintentionally while they should have been discarded.
* Fixed offline data script so that it handles external ressources better.
* Fixed some general stability issues

### \[3.12.0] 2020-09-30[​](https://docs.mapsindoors.com/changelogs/ios#3120-2020-09-30) <a href="#3120-2020-09-30" id="3120-2020-09-30"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-26) <a href="#added-26" id="added-26"></a>

* Support for Live Data added. For more information, read about this feature in the [Live Data Guide](https://docs.mapsindoors.com/map/live-data/live-data-intro-ios/).

### \[3.11.1] 2020-09-28[​](https://docs.mapsindoors.com/changelogs/ios#3111-2020-09-28) <a href="#3111-2020-09-28" id="3111-2020-09-28"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-27) <a href="#added-27" id="added-27"></a>

* In `MPDatasetCacheManager` we have optimized support for changing caching scope from a larger scope to a smaller scope, by deleting obsolete caches.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-37) <a href="#fixed-37" id="fixed-37"></a>

* Fixed that route end marker on `MPDirectionsRenderer` was obscuring the destination location marker.
* Fixed an issue causing `MPDirectionsRenderer` not to use the `MPDirectionsRenderer.actionPointImages` in some cases.
* Fixed a data synchronisation issue that caused the newly synchronised data to not being used before a new session was initiated.
* Fixed a route path optimization issue that caused the optimization to be applied unintentionally in some cases.
* Fixed a search issue that caused the search engine to ignore `MPLocation.externalId`.
* Fixed a routing issue that caused the `MPDirectionsRenderer` to show a wrong the next leg marker.
* Fixed an issue causing the Info Window of `MPMapControl.selectedLocation` to not show up in some cases.
* Fixed an internal issue with the map marker collision handling.
* Some internal refactorings and optimizations.

### \[3.9.9] 2020-08-31[​](https://docs.mapsindoors.com/changelogs/ios#399-2020-08-31) <a href="#399-2020-08-31" id="399-2020-08-31"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-38) <a href="#fixed-38" id="fixed-38"></a>

* Fixed issues causing `MPMapControl` to not properly clean up content on the map when `MapsIndoors.provideAPIKey()` is called while a `MPMapControl` instance is already initialized.
* Fixed issue causing `MPMapControl.selectedLocation` to not properly highlight on the map in some cases.
* Internal search engine optimizations and improvements.

### \[3.9.7] 2020-08-19[​](https://docs.mapsindoors.com/changelogs/ios#397-2020-08-19) <a href="#397-2020-08-19" id="397-2020-08-19"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-39) <a href="#fixed-39" id="fixed-39"></a>

* Fixed a race condition occurring in some poor networking conditions causing `MPMapControl` not to properly show its initial building outline.
* Other internal stability improvements.

### \[3.9.6] 2020-07-06[​](https://docs.mapsindoors.com/changelogs/ios#396-2020-07-06) <a href="#396-2020-07-06" id="396-2020-07-06"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-40) <a href="#fixed-40" id="fixed-40"></a>

* Fixed indoor routes with stairs leading to the same Floor would omit the stair steps.

### \[3.9.5] 2020-07-02[​](https://docs.mapsindoors.com/changelogs/ios#395-2020-07-02) <a href="#395-2020-07-02" id="395-2020-07-02"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-28) <a href="#added-28" id="added-28"></a>

* Added a helper method on `MPLocation` to retrieve fields using case-insenitive keys: `location.getField(forKey: "key")`

### \[3.9.4] 2020-06-24[​](https://docs.mapsindoors.com/changelogs/ios#394-2020-06-24) <a href="#394-2020-06-24" id="394-2020-06-24"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-41) <a href="#fixed-41" id="fixed-41"></a>

* Fixed an issue that caused search functionality to stop working after receiving a low memory warning.
* Fixed an issue that caused some map location images to show at wrong locations in some cases.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-20) <a href="#changed-20" id="changed-20"></a>

* Venue labels now show only for zoom levels 10 to 15 (exclusively)

### \[3.9.3] 2020-06-16[​](https://docs.mapsindoors.com/changelogs/ios#393-2020-06-16) <a href="#393-2020-06-16" id="393-2020-06-16"></a>

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-21) <a href="#changed-21" id="changed-21"></a>

* Routes rendered on the map with `MPDirectionsRenderer` now have rounded curves when directions on the route change.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-42) <a href="#fixed-42" id="fixed-42"></a>

* Fixed a crash in `MPDirectionsRenderer` that happened when new routes were applied in quick succession.
* Fixed a problem synchronising multiple datasets simultaneously.

### \[3.9.2] 2020-06-02[​](https://docs.mapsindoors.com/changelogs/ios#392-2020-06-02) <a href="#392-2020-06-02" id="392-2020-06-02"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-43) <a href="#fixed-43" id="fixed-43"></a>

* Synchronizing new data would not take in current app session.

### \[3.9.1] 2020-05-18[​](https://docs.mapsindoors.com/changelogs/ios#391-2020-05-18) <a href="#391-2020-05-18" id="391-2020-05-18"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-44) <a href="#fixed-44" id="fixed-44"></a>

* Too many wayfinding steps were emitted for routes with slight curvature.

### \[3.9.0] 2020-05-04[​](https://docs.mapsindoors.com/changelogs/ios#390-2020-05-04) <a href="#390-2020-05-04" id="390-2020-05-04"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-29) <a href="#added-29" id="added-29"></a>

* Support for caching offline data for multiple datasets. See `MapsIndoors.dataSetCacheManager` and [https://docs.mapsindoors.com/data/offline-data/offline-ios/)](https://docs.mapsindoors.com/data/offline-data/offline-ios/)) for more details.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-22) <a href="#changed-22" id="changed-22"></a>

* Updated Google Maps dependency to Google Maps 3.8.0

### \[3.8.3] 2020-03-05[​](https://docs.mapsindoors.com/changelogs/ios#383-2020-03-05) <a href="#383-2020-03-05" id="383-2020-03-05"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-45) <a href="#fixed-45" id="fixed-45"></a>

* Fixed an issue that would make devices with iOS 10 crash occasionally.

### \[3.8.2] 2020-03-02[​](https://docs.mapsindoors.com/changelogs/ios#382-2020-03-02) <a href="#382-2020-03-02" id="382-2020-03-02"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-46) <a href="#fixed-46" id="fixed-46"></a>

* Fixed an issue where the rendered route part would sometimes not be fully visible.
* Fixed a problem with loading maptiles embedded in apps at first launch of app.
* Fixed an directions issue where the reversed directions request (swapping origin and destination) could sometimes not be calculated.

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-30) <a href="#added-30" id="added-30"></a>

* Added an ExternalId property `MPLocation.externalId`. This field is used for identifying each location on a matter that is external to MapsIndoors. The ExternalId is maintained in MapsIndoors CMS.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-23) <a href="#changed-23" id="changed-23"></a>

* Deprecated `MPLocation.roomId`. `MPLocation.externalId` is to be used instead.

### \[3.8.1] 2020-02-04[​](https://docs.mapsindoors.com/changelogs/ios#381-2020-02-04) <a href="#381-2020-02-04" id="381-2020-02-04"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-47) <a href="#fixed-47" id="fixed-47"></a>

* Some searches unfortunately ended in a crash related to data inconsistency.
* Directions completion handler was sometimes on the main queue.
* Improved detection of start and end rooms on a route.
* Script for embedding data for offline use would download all referenced URLs but should only download referenced images and maptiles.

### \[3.8.0] 2020-01-24[​](https://docs.mapsindoors.com/changelogs/ios#380-2020-01-24) <a href="#380-2020-01-24" id="380-2020-01-24"></a>

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-24) <a href="#changed-24" id="changed-24"></a>

* Improved route generation; improved detection of start and end rooms for indoor route, and improved rendering of route start and endpoints.

### \[3.7.2] 2019-01-09[​](https://docs.mapsindoors.com/changelogs/ios#372-2019-01-09) <a href="#372-2019-01-09" id="372-2019-01-09"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-48) <a href="#fixed-48" id="fixed-48"></a>

* Applying `MPMapControl.setDisplayRule(:forLocation:)` for one or more locations that was already hidden by default would not change the locations visibility. This is now fixed.

### \[3.7.1] 2019-12-05[​](https://docs.mapsindoors.com/changelogs/ios#371-2019-12-05) <a href="#371-2019-12-05" id="371-2019-12-05"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-31) <a href="#added-31" id="added-31"></a>

* Added `MPMapControl` now has new functionality for temporarily changing the `MPDisplayRule` for individual `MPLocations`. See `MPMapControl.setDisplayRule(:forLocation:)`, `MPMapControl.resetDisplayRuleForLocation()` and similar methods.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-25) <a href="#changed-25" id="changed-25"></a>

* Multiple improvements to the search engine has been implemented.

### \[3.6.2] 2019-11-18[​](https://docs.mapsindoors.com/changelogs/ios#362-2019-11-18) <a href="#362-2019-11-18" id="362-2019-11-18"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-49) <a href="#fixed-49" id="fixed-49"></a>

* Fixed a memory leak happening when switching Solution or API key.
* Fixed `MPMapControl` is now more resilient against `GMSMapView.delegate` being changed.
* [This issue](https://forums.developer.apple.com/thread/123003) made our SDK crash if built with XCode 10 and below. We have implemented a workaround in this version.
* Fixed Restored previous behaviour where the map settles on a building and showing the floor selector initially.
* Fixed Improved switching between different Solutions / API keys.

### \[3.6.1] 2019-11-05[​](https://docs.mapsindoors.com/changelogs/ios#361-2019-11-05) <a href="#361-2019-11-05" id="361-2019-11-05"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-50) <a href="#fixed-50" id="fixed-50"></a>

* Fixed synchronisation issue, that sometimes caused map graphics to disappear, if the app was shut down in the middle of a synchronisation.
* Fixed directions rendering issue causing the map camera to display random parts of the Google map instead of the step or leg that was intended to be rendered.
* Fixed some inconsistencies in how non-quadratic icons was anchored on the map.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-26) <a href="#changed-26" id="changed-26"></a>

* Locations can now be configured as searchable (from the backend), which in effect makes them eligible for map display but not retrievable from a search query through `MPLocationService`.

### \[3.6.0] 2019-10-10[​](https://docs.mapsindoors.com/changelogs/ios#360-2019-10-10) <a href="#360-2019-10-10" id="360-2019-10-10"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-51) <a href="#fixed-51" id="fixed-51"></a>

* `MPDirectionsQuery.init(originPoint:MPPoint, destPoint:MPPoint)` could produce origins and destinations on level 0, resulting in incorrect route results.

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-27) <a href="#changed-27" id="changed-27"></a>

* Compiled with Xcode 11 for iOS 13
* Internal refactoring to improve memory and threading error resilience.

### \[3.5.0] 2019-09-25[​](https://docs.mapsindoors.com/changelogs/ios#350-2019-09-25) <a href="#350-2019-09-25" id="350-2019-09-25"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-32) <a href="#added-32" id="added-32"></a>

* Added `depth` property to `MPFilter`, used with the `parents` property, making it possible to e.g. get all buildings and floors within a venue (depth 2) or get only floors within a building (depth 1).
* Added the ability to control the visibility of map icons and map labels independently, through `MPLocationDisplayRule.showIcon` and `MPLocationDisplayRule.showLabel`.
* Added property `locationBaseType` on `MPLocation`, making it possible to dstinguish buildings from venues, floors from rooms, areas from POIs etc.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-52) <a href="#fixed-52" id="fixed-52"></a>

* Fixed issue with info window disappearing after location selection when search result is currently rendered.
* Fixed some internal concurrency issues.

### \[3.3.1] 2019-09-15[​](https://docs.mapsindoors.com/changelogs/ios#331-2019-09-15) <a href="#331-2019-09-15" id="331-2019-09-15"></a>

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-28) <a href="#changed-28" id="changed-28"></a>

* InfoWindows presented on the map is now made fully visible if needed - this changes the presented map area.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-53) <a href="#fixed-53" id="fixed-53"></a>

* Fixed location data was only synced once per session, regardless of explicit calls to `MapsIndoors.synchronizeContent()`.

### \[3.3.0] 2019-08-30[​](https://docs.mapsindoors.com/changelogs/ios#330-2019-08-30) <a href="#330-2019-08-30" id="330-2019-08-30"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-33) <a href="#added-33" id="added-33"></a>

* Support for custom fields on venues, buildings and categories (writable from the MapsIndoors Data API).

### \[3.2.0] 2019-08-20[​](https://docs.mapsindoors.com/changelogs/ios#320-2019-08-20) <a href="#320-2019-08-20" id="320-2019-08-20"></a>

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-29) <a href="#changed-29" id="changed-29"></a>

* Updated Google Maps SDK from 3.1.0 to 3.3.0 (see [https://developers.google.com/maps/documentation/ios-sdk/releases](https://developers.google.com/maps/documentation/ios-sdk/releases) for details).
* Default Google Maps styling is now applied to the map, so that we hide Google Maps icons that usually compete with, confuse or disturb the appearance of MapsIndoors location icons.

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-34) <a href="#added-34" id="added-34"></a>

* Support for building default floors.
* Support for profile-based routing.
* Support for travelmode specific venue entrypoints, so e.g. driving routes can go via parking lots (require data configuration).

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-54) <a href="#fixed-54" id="fixed-54"></a>

* Fixed an issue with loading Solution data from the MapsIndoors backend.
* Fixed an issue with searching for location aliases.
* Fixed a memory issue that can happen when multiple map instances are created in one session.
* Fixed a rare race condition during initialization.

### \[3.1.2] 2019-06-27[​](https://docs.mapsindoors.com/changelogs/ios#312-2019-06-27) <a href="#312-2019-06-27" id="312-2019-06-27"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-55) <a href="#fixed-55" id="fixed-55"></a>

* Fixed memory issue related to adding observers to `MPMapsIndoorsLocationSource` in relation to entering and leaving a MapsIndoors map multiple times in the same session.
* Fixed occasional orphaned/ghost polyline from the `MPDirectionsRenderer`.
* Fixed wrong floor tiles showing in route step in some cases.
* Fixed an issue with route rendering.
* Fixed info window not appearing for selectedLocation after several API key switches.

### \[3.1.1] 2019-06-21[​](https://docs.mapsindoors.com/changelogs/ios#311-2019-06-21) <a href="#311-2019-06-21" id="311-2019-06-21"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-56) <a href="#fixed-56" id="fixed-56"></a>

* Fixed `MPMapControl.go(to:MPLocation)` so that the map now properly fits locations with polygons.
* Fixed dataset switching sometimes not working due to re-initialisation not properly executed behind the scenes.
* Fixed memory issues related to entering and leaving a MapsIndoors map multiple times in the same session.
* Adding custom `MPLocationDisplayRule` not affecting size and rank changes due to a race condition.
* Fixed a problem with transitioning from a Google route to a MapsIndoors route.

### \[3.1.0] 2019-06-04[​](https://docs.mapsindoors.com/changelogs/ios#310-2019-06-04) <a href="#310-2019-06-04" id="310-2019-06-04"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-35) <a href="#added-35" id="added-35"></a>

* Added a `MPGeometryHelper` class.
* Added a way to get polygons for locations using `MPGeometryHelper.polygonsForLocation(location:MPLocation)`.
* Updated Google Maps dependency to version 3.1.0.
* Optimizing outdoor/indoor directions. Filters entry points by new travel mode flag in SDK before doing calculations.
* Now possible to set map style (layout) using `MPMapControl.mapStyle = MPMapStyle(string:"my-style")`. Only applies for data sets that has multiple defined styles.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-57) <a href="#fixed-57" id="fixed-57"></a>

* Fixed map markers being anchored at the bottom of a square icon, not the center.
* Fixed a race condition in the initial data fetch causing locations search results to be initially empty.
* Fixed error causing locations to show across all Floors when displaying as search result.
* Fixed tapping on Information Window does not center view based on selected location.

### \[3.0.4] 2019-04-29[​](https://docs.mapsindoors.com/changelogs/ios#304-2019-04-29) <a href="#304-2019-04-29" id="304-2019-04-29"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-58) <a href="#fixed-58" id="fixed-58"></a>

* Improved search functionality.
* Fixed an issue with directions only returning routes on ground floor.
* Fixed issue with the directions service not resorting to offline even in case of cached route-networks.
* Fixed an issue where would return more than expected results when perfect match(es) was found.

### \[3.0.3] 2019-04-11[​](https://docs.mapsindoors.com/changelogs/ios#303-2019-04-11) <a href="#303-2019-04-11" id="303-2019-04-11"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-59) <a href="#fixed-59" id="fixed-59"></a>

* Fixed an issue changing MapsIndoors.positionProvider during the runtime of the app.

### \[3.0.2] 2019-04-08[​](https://docs.mapsindoors.com/changelogs/ios#302-2019-04-08) <a href="#302-2019-04-08" id="302-2019-04-08"></a>

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-60) <a href="#fixed-60" id="fixed-60"></a>

* Fixed an issue where MPMapControl would not update it's current location.

### \[3.0.1] 2019-04-03[​](https://docs.mapsindoors.com/changelogs/ios#301-2019-04-03) <a href="#301-2019-04-03" id="301-2019-04-03"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-36) <a href="#added-36" id="added-36"></a>

* MPMapControlDelegate now has a new method for notifying about which building is focused on the map `MPMapControlDelegate.focusedBuildingDidChange()`
* MPMapControlDelegate now has a new method for notifying position updates `MPMapControlDelegate.onPositionUpdate()`

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-30) <a href="#changed-30" id="changed-30"></a>

* MPMapControl.currentPosition has been deprecated; use MapsIndoors.positionProvider.latestPositionResult to know current position.

#### Fixed[​](https://docs.mapsindoors.com/changelogs/ios#fixed-61) <a href="#fixed-61" id="fixed-61"></a>

* Fixed an issue related to MPLocations using the default displayrule as well as their own icon.
* Fixed an issue causing MPLocationUpdate/MPLocation to always set floor index to zero on updates.

### \[3.0.0] 2019-03-04[​](https://docs.mapsindoors.com/changelogs/ios#300-2019-03-04) <a href="#300-2019-03-04" id="300-2019-03-04"></a>

#### Added[​](https://docs.mapsindoors.com/changelogs/ios#added-37) <a href="#added-37" id="added-37"></a>

* Support for external location data sources using `MapsIndoors.registerLocationSources()`
* New location service `MPLocationService` to replace `MPLocationsProvider`
* Location clustering support using `MPMapControl.locationClusteringEnabled`
* Added building and venues to the search experience

#### Changed[​](https://docs.mapsindoors.com/changelogs/ios#changed-31) <a href="#changed-31" id="changed-31"></a>

* MPLocation properties are now read only

#### Removed[​](https://docs.mapsindoors.com/changelogs/ios#removed) <a href="#removed" id="removed"></a>

* Removed a number of deprecated methods that was introduced in V1
