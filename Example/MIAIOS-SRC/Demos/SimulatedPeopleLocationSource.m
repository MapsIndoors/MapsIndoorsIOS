//
//  SimulatedPeopleLocationSource.m
//  kpmg-testbed
//
//  Created by Michael Bech Hansen on 27/11/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "SimulatedPeopleLocationSource.h"


@interface SimulatedPeopleLocationSource ()

@property (nonatomic, strong) NSMutableDictionary<NSString*,MPLocation*>*   locations;
@property (nonatomic, strong) MPLocation*                                   currentUser;

@property (nonatomic, strong) NSMutableSet<id<MPLocationsObserver>>*        observers;
@property (nonatomic) MPLocationSourceStatus                                status;

@property (nonatomic, strong) NSMutableSet<NSString*>*                      venuesResolving;
@property (nonatomic, strong) NSTimer*                                      movementTimer;
@property (nonatomic) NSTimeInterval                                        updateInterval;


@property (nonatomic, readwrite) NSInteger                                  incrementedLocationId;

@end


static NSString*                 _poiType = @"person";
static NSString*                 _currentUserType = @"current_user";
static MPLocationDisplayRule*    _peopleDisplayRule;
static MPLocationDisplayRule*    _currentUserDisplayRule;




@implementation SimulatedPeopleLocationSource

- (instancetype)init
{
    self = [super init];
    if (self) {
        _observers = [NSMutableSet set];
        _locations = [NSMutableDictionary dictionary];
        _updateInterval = 1.0;
        self.incrementedLocationId = 0;
        [self prepareLocations];
    }
    return self;
}

- (void)setStatus:(MPLocationSourceStatus)sourceStatus {

    if ( _status != sourceStatus ) {

        _status = sourceStatus;
        [self notifyStatusChange];
    }
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
- (void) prepareLocations {

    [[MPVenueProvider new] getBuildingsWithCompletion:^(NSArray<MPBuilding *> * _Nullable buildings, NSError * _Nullable error) {

        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            for ( MPBuilding* building in buildings ) {

                for ( NSString* floor in building.floors.allKeys ) {

                    NSNumber*   floorNumber = @([floor integerValue]);

                    if ( self.currentUser == nil ) {
                        self.currentUser = [self createPersonNamed:@"Me" type:_currentUserType building:building floor:floorNumber];
                    }

                    NSUInteger  numPeople = 10 + arc4random_uniform( 15 );      // 10-25 people on each floor.
                    [self generatePeoplePois:numPeople onFloor:floorNumber inBuilding:building];

                    //NSLog( @"simpeeps: Adding %@ people to %@ (floor %@)", @(numPeople), building.name, floor );
                }
            }
            
            self.status = MPLocationSourceStatusAvailable;
            
            [self notifyUpdatedLocations: self.locations.allValues ];

            dispatch_async(dispatch_get_main_queue(), ^{
                __weak typeof(self)weakSelf = self;
                self.movementTimer = [NSTimer scheduledTimerWithTimeInterval:self.updateInterval repeats:YES block:^(NSTimer * _Nonnull timer) {
                    [weakSelf animateAllThePeople];
                }];
            });
        });
    }];
}
#pragma clang diagnostic pop

- (NSInteger) incrementedLocationId {
    return ++_incrementedLocationId;
}


#pragma mark - MPLocationSource protocol

- (void) addLocationsObserver:(nonnull id<MPLocationsObserver>)observer {

    [self.observers addObject:observer];
}

- (void) removeLocationsObserver:(nonnull id<MPLocationsObserver>)observer {

    [self.observers removeObject:observer];
}

- (nonnull NSArray<MPLocation*>*) getLocations {

    return self.locations.allValues;
}

- (int)sourceId {
    return (int)self;
}

#pragma mark - Helpers

- (GMSPath*) pathFromCoordinateArray:(NSArray*)coordinateArray {

    GMSMutablePath*     path = [GMSMutablePath new];

    for ( NSArray* oneCoo in coordinateArray ) {

        double  longitude = [oneCoo[0] doubleValue];
        double  latitude  = [oneCoo[1] doubleValue];

        [path addCoordinate:CLLocationCoordinate2DMake(latitude, longitude)];
    }

    return [path copy];
}

- (NSString*) randomName {

    static NSArray<NSString*>*  firstNames;
    static NSArray<NSString*>*  surNames;
    static dispatch_once_t      onceToken;
    dispatch_once(&onceToken, ^{
        firstNames = @[ @"John", @"Joe", @"Javier", @"Mike", @"Janet", @"Susan", @"Cristina", @"Michelle"];
        surNames = @[ @"Smith", @"Jones", @"Andersson", @"Perry", @"Brown", @"Hill", @"Moore", @"Baker"];
    });

    uint32_t  ixFirst = arc4random_uniform( (uint32_t)firstNames.count);
    uint32_t  ixSecond = arc4random_uniform( (uint32_t)surNames.count);

    return [NSString stringWithFormat:@"%@ %@", firstNames[ixFirst], surNames[ixSecond]];
}

- (NSURL*) randomImageUrl {

    static NSArray<NSURL*>*     imageUrls;
    static dispatch_once_t      onceToken;
    static uint32_t             ix = 0;

    dispatch_once(&onceToken, ^{
        imageUrls = @[ [NSURL URLWithString:@"http://via.placeholder.com/88x88"]
                     , [NSURL URLWithString:@"https://www.fillmurray.com/88/88"]
                     , [NSURL URLWithString:@"https://loremflickr.com/88/88"]
                     , [NSURL URLWithString:@"https://morganfillman.space/88/88"]
                     , [NSURL URLWithString:@"https://placekitten.com/88/88"]
                     , [NSURL URLWithString:@"https://placebeard.it/88x88"]
                     , [NSURL URLWithString:@"https://www.placecage.com/88/88"]
                     , [NSURL URLWithString:@"https://placebear.com/88/88"]
                     , [NSURL URLWithString:@"https://www.stevensegallery.com/88/88"]
                     ];
    });

    NSURL*  url = imageUrls[ ix % imageUrls.count ];
    ++ix;

    return url;
}

- (UIImage*) randomPersonImage {
    
    static NSArray<UIImage*>*   images;
    static dispatch_once_t      onceToken;
    static uint32_t             ix = 0;
    
    dispatch_once(&onceToken, ^{
        
        // Blocking load of all images:
        NSArray<NSString*>*    imageUrls = @[ @"https://www.fillmurray.com/88/88"
                                              , @"https://loremflickr.com/88/88"
                                              , @"https://placekitten.com/88/88"
                                              , @"https://placebeard.it/88x88"
                                              , @"https://www.placecage.com/88/88"
                                              , @"https://placebear.com/88/88"
                                              , @"https://www.stevensegallery.com/88/88"
                                              , @"https://www.fillmurray.com/88/88"
                                              , @"https://loremflickr.com/120/120"
                                              , @"https://placekitten.com/120/120"
                                              , @"https://placebeard.it/120x120"
                                              , @"https://www.placecage.com/120/120"
                                              , @"https://placebear.com/120/120"
                                              , @"https://www.stevensegallery.com/120/120"
                                              ];
        
        NSMutableArray<UIImage*>*   mutableImages = [NSMutableArray array];
        for ( NSString* url in imageUrls ) {
            UIImage*    image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
            if ( image ) {
                [mutableImages addObject: image];
                NSLog( @"Loaded placeholder from: %@", url );
            } else {
                NSLog( @"Failed to load placeholder from: %@", url );
            }
        }
        
        images = [mutableImages copy];
    });
    
    UIImage*  image = images[ ix % images.count ];
    ++ix;
    
    return image;
}

+ (MPLocationDisplayRule *) peopleDisplayRule {

    if ( _peopleDisplayRule == nil ) {

        _peopleDisplayRule = [MPLocationDisplayRule new];
        _peopleDisplayRule.icon = [UIImage imageNamed:@"generic_user"];
        _peopleDisplayRule.iconSize = CGSizeMake( 32, 32 );
        _peopleDisplayRule.visible = YES;
        _peopleDisplayRule.zOn = @(19);     // Dont display too soon; with a large population, we overwhelm GMSMapView and performance becomes miserable.
        _peopleDisplayRule.zOff = @(24);
        _peopleDisplayRule.label = @"{{name}}";
        _peopleDisplayRule.showLabel = NO;
        _peopleDisplayRule.name = _poiType;
        _peopleDisplayRule.displayRank = 1000;
    }
    return _peopleDisplayRule;
}

+ (MPLocationDisplayRule*) currentUserDisplayRule {

    if ( _currentUserDisplayRule == nil ) {

        _currentUserDisplayRule = [MPLocationDisplayRule new];
        _currentUserDisplayRule.icon = [UIImage imageNamed:@"current_user"];
        _currentUserDisplayRule.iconSize = CGSizeMake( 32, 32 );
        _currentUserDisplayRule.visible = YES;
        _currentUserDisplayRule.zOn = @(0);
        _currentUserDisplayRule.zOff = @(24);
        _currentUserDisplayRule.label = @"{{name}}";
        _currentUserDisplayRule.showLabel = NO;
        _currentUserDisplayRule.name = _currentUserType;
        _peopleDisplayRule.displayRank = 9999;
    }
    return _currentUserDisplayRule;
}

- (MPLocation*) createPersonNamed:(NSString*)name type:(NSString*)poiType building:(MPBuilding *)building floor:(NSNumber *)floor {

    //MPLocation* loc = [MPLocation new];
    CLLocationCoordinate2D coord = [building.anchor getCoordinate];
    
    MPLocationUpdate* locUpdate = [MPLocationUpdate updateWithId:self.incrementedLocationId fromSource:self];
    
    [locUpdate setPosition:coord];
    [locUpdate addPropertyValue:name forKey:MPLocationFieldName];
    [locUpdate setFloor:floor.integerValue];
    [locUpdate addPropertyValue:[NSString stringWithFormat:@"%@ yada yada yada....", name] forKey:MPLocationFieldDescription];
    [locUpdate setType:poiType];
    [locUpdate addCategory:poiType];
    [locUpdate setIcon:[self randomPersonImage]];
    //Now adding display rules through MPMapControl
    //[locUpdate setDisplayRule: [poiType isEqualToString:_poiType] ? SimulatedPeopleLocationSource.peopleDisplayRule : SimulatedPeopleLocationSource.currentUserDisplayRule];
    
    MPLocation* loc = locUpdate.location;
    dispatch_async(dispatch_get_main_queue(), ^{
        self.locations[loc.locationId] = loc;
    });

    return loc;
}

- (void) generatePeoplePois:(NSUInteger)numPeople onFloor:(NSNumber*)floor inBuilding:(MPBuilding*)building {

    for ( int i=0; i < numPeople; ++i ) {
        [self createPersonNamed:[self randomName] type:_poiType building:building floor:floor];
    }
}


#pragma mark - Animate All the People (tm)

- (void) animateAllThePeople {
    dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    //NSLog( @"simpeeps: Generating updates with population %@", @(self.locations.count) );
    NSArray<MPLocation*>*                           locations = self.locations.allValues;
    NSDictionary<NSString*,MPLocation*>*    updateDict;

    NSMutableArray<MPLocation*>*    updatedLocations = [NSMutableArray array];
    uint32_t                        numMoves = MIN( 100, arc4random_uniform( (uint32_t)locations.count / 4 ) );       // Move at most 25% of the population each update
    
    for ( int i=0; i < numMoves; ++i ) {
        
        int32_t     dLat  = -4 + arc4random_uniform( 9 );
        int32_t     dLong = -4 + arc4random_uniform( 9 );
        uint32_t    ix = arc4random_uniform( (uint32_t)locations.count );
        MPLocation* loc = locations[ ix ];
        
        if ( (dLat || dLong) && ![updatedLocations containsObject:loc] ) {
            
            CLLocationCoordinate2D  newLocation = loc.geometry.getCoordinate;
            newLocation.latitude  += 0.000005 * (double)dLat;
            newLocation.longitude += 0.000010 * (double)dLong;
            
            MPPoint*    newPoint = [[MPPoint alloc] initWithLat:newLocation.latitude lon:newLocation.longitude zValue:loc.floor.doubleValue];
            MPLocationUpdate* update = [MPLocationUpdate updateWithLocation:loc];
            [update setPosition:newPoint.getCoordinate];
            MPLocation* location = update.location;
            [updatedLocations addObject:location];
        }
    }
    
    updateDict = [NSDictionary dictionaryWithObjects:updatedLocations forKeys:[updatedLocations valueForKey:@"locationId"]];
    
    //NSLog( @"simpeeps: Notifying updates %@", @(updatedLocations.count) );
    if ( updatedLocations.count ) {
        [self.locations addEntriesFromDictionary:updateDict];
        [self notifyUpdatedLocations: updatedLocations ];
    }
    });
}

#pragma mark - Notification helpers

- (void) notifyUpdatedLocations:(NSArray<MPLocation*>*)updatedLocations {

    for ( id<MPLocationsObserver> observer in self.observers ) {
        [observer onLocationsUpdate:updatedLocations source:self];
    }
}

- (void) notifyStatusChange {

    for ( id<MPLocationsObserver> observer in self.observers ) {
        [observer onStatusChange:self.status source:self];
    }
}

@end
