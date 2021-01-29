//
//  AppFlowController.h
//  MIAIOS
//
//  Created by Michael Bech Hansen on 08/06/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


@class UISplitViewController;
@class MPPoint;
@class MPMapControl;


NS_ASSUME_NONNULL_BEGIN

@interface AppFlowController : NSObject

@property (nonatomic, weak)           UISplitViewController*  splitViewController;
@property (nonatomic, weak, readonly) MPMapControl*           currentMapControl;
@property (nonatomic)                 BOOL                    mainUiIsReady;
@property (nonatomic, readonly)       BOOL                    isBusy;

+ (instancetype) sharedInstance;

- (void) presentDetailsScreenForLocationWitId:(NSString*)locationId;

- (void) presentRouteFrom:(nullable MPPoint*)from
             fromLocation:(nullable NSString*)fromLocation
                       to:(nullable MPPoint*)to
               toLocation:(nullable NSString*)toLocation
               travelMode:(nullable NSString*)travelMode
                    avoid:(nullable NSArray<NSString*>*)restrictions;


@end

NS_ASSUME_NONNULL_END
