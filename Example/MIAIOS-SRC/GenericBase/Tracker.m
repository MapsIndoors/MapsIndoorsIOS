//
//  Tracker.m
//  MIAIOS
//
//  Created by Daniel Nielsen on 19/04/2017.
//  Copyright © 2017-2018 MapsPeople A/S. All rights reserved.
//

#import "Tracker.h"
@import Firebase;



@implementation Tracker

static BOOL _disabled;

+ (void)setup {
    if (Tracker.disabled) return;
    [FIRApp configure];

    // Documented setup method causes unexpected exception
    // Configure tracker from GoogleService-Info.plist.
    //NSError *configureError;
    //[[GGLContext sharedInstance] configureWithError:&configureError];
    //NSAssert(!configureError, @"Error configuring Google services: %@", configureError);
    
    //[[GAI sharedInstance] trackerWithTrackingId:@"UA-63919776-3"];
    
    // Optional: configure GAI options.
    //GAI *gai = [GAI sharedInstance];
    //gai.trackUncaughtExceptions = YES;
}

+ (void)setDisabled:(BOOL)disabled {
    _disabled = disabled;
}

+ (BOOL)disabled {
    return _disabled;
}

+ (void) trackSearch:(MPLocationQuery *)query results:(NSUInteger)count selectedLocation:(NSString*)selectedLocation {
    if (_disabled) return;
    
    NSString* scope = @"Global";
    if (query.categories.count > 0) {
        scope = [query.categories componentsJoinedByString:@"_"];
    }
    
    NSMutableDictionary*    params = [ @{ @"Query": query ?: @""
                                        , @"Scope":scope
                                        , @"Result_Count":[NSNumber numberWithUnsignedInteger:count]
                                        } mutableCopy];
    
    if ( selectedLocation.length ) {
        params[ @"Selected_Location" ] = selectedLocation;
    }
    
    [FIRAnalytics logEventWithName:kMPEventNameSearch parameters:[params copy] ];
}

+ (void) trackDirectionsSearch:(NSString*)queryText results:(NSUInteger)count selectedLocation:(NSString*)selectedLocation isOriginSearch:(BOOL)isOriginSearch {
    
    if (_disabled == NO ) {
        
        NSMutableDictionary*    params = [ @{ @"Query": queryText ?: @""
                                            , @"Result_Count":[NSNumber numberWithUnsignedInteger:count]
                                            } mutableCopy];
        
        if ( selectedLocation.length ) {
            params[ @"Selected_Location" ] = selectedLocation;
        }
        
        NSString*   eventName = isOriginSearch ? kMPEventNameOriginSearch : kMPEventNameDestinationSearch;
        [FIRAnalytics logEventWithName:eventName parameters:[params copy] ];
    }
}

+ (void) trackScreen:(NSString*) screenName {
    if (_disabled) return;

//    id<GAITracker> tracker = [GAI sharedInstance].defaultTracker;
//    [tracker set:kGAIScreenName value:screenName];
//    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

    [FIRAnalytics logEventWithName:kFIREventScreenView parameters:@{kFIRParameterScreenName:screenName}];
}

+ (void)trackEvent:(NSString *)name
            parameters:(NSDictionary<NSString*,id> *)parameters {
    if (_disabled) return;

    
    [FIRAnalytics logEventWithName:name parameters:parameters];
//    [[GAI sharedInstance].defaultTracker send:[[GAIDictionaryBuilder createEventWithCategory:category
//                                                                                      action:action
//                                                                                       label:label
//                                                                                       value:value] build]];
}

@end
