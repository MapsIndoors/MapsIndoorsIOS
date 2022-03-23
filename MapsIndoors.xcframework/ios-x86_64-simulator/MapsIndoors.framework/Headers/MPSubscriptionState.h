//
//  MPSubscriptionState.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 27/07/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#ifndef MPSubscriptionState_h
#define MPSubscriptionState_h

typedef NS_ENUM(NSInteger, MPSubscriptionState) {
    MPSubscriptionStateClosed,
    MPSubscriptionStateConnecting,
    MPSubscriptionStateConnected,
    MPSubscriptionStateDisconnecting
};

#endif /* MPSubscriptionState_h */
