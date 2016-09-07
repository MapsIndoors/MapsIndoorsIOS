//
//  MPVenueProvider.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPVenueCollection.h"
#import "MPBuilding.h"
#import "MPVenue.h"
#import "MPMapExtend.h"


typedef void(^mpVenueDetailsHandlerBlockType)(MPVenue* venue, NSError* error);
typedef void(^mpVenueListHandlerBlockType)(MPVenueCollection* venueCollection, NSError* error);
typedef void(^mpBuildingDetailsHandlerBlockType)(MPBuilding* building, NSError* error);
typedef void(^mpBuildingListHandlerBlockType)(NSArray* buildings, NSError* error);

/**
 * Venue provider delegate.
 */
@protocol MPVenueProviderDelegate <NSObject>
/**
 * Venue data ready event method.
 * @param venueCollection The venue data collection.
 */
@required
- (void) onVenuesReady: (MPVenueCollection*)venueCollection;
- (void) onBuildingWithinBoundsReady: (MPBuilding*)building;
- (void) onBuildingDetailsReady: (MPBuilding*)building;
- (void) onVenueDetailsReady: (MPVenue*)venue;
- (void) onBuildingsReady: (NSArray*)buildings;
@end
/**
 * Venue provider interface, that defines a delegate and a method for venue queries.
 */
@interface MPVenueProvider : NSObject
/**
 * Venue provider delegate.
 */
@property (weak) id <MPVenueProviderDelegate> delegate;
/**
 * Get venues from this provider.
 */
- (void)getVenuesAsync: (NSString*) arg language: (NSString*) language;
/**
* Get building within bounds from this provider.
*/
- (void)getBuildingWithinBoundsAsync: (MPMapExtend*)mapExtend arg: (NSString*) solutionId language: (NSString*) language;
- (void)getBuildingsAsync: (NSString*)venue arg: (NSString*) solutionId language: (NSString*) language;
- (void)getBuildingDetailsAsync: (NSString*)buildingId arg: (NSString*) solutionId language: (NSString*) language;
- (void)getVenueDetailsAsync: (NSString*)venueId arg: (NSString*) solutionId language: (NSString*) language;

/**
 * Get venues from this provider.
 */
- (void)getVenuesAsync: (NSString*) arg language: (NSString*) language completionHandler:(mpVenueListHandlerBlockType)handler;
/**
 * Get building within bounds from this provider.
 */
- (void)getBuildingWithinBoundsAsync: (MPMapExtend*)mapExtend arg: (NSString*) solutionId language: (NSString*) language completionHandler:(mpBuildingDetailsHandlerBlockType)handler;

- (void)getBuildingsAsync: (NSString*)venue arg: (NSString*) solutionId language: (NSString*) language completionHandler:(mpBuildingListHandlerBlockType)handler;

- (void)getBuildingDetailsAsync: (NSString*)buildingId arg: (NSString*) solutionId language: (NSString*) language completionHandler:(mpBuildingDetailsHandlerBlockType)handler;

- (void)getVenueDetailsAsync: (NSString*)venueId arg: (NSString*) solutionId language: (NSString*) language completionHandler:(mpVenueDetailsHandlerBlockType)handler;


@end
