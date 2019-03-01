//
//  MPAccessibilityHelper.m
//  MIAIOS
//
//  Created by Michael Bech Hansen on 30/07/2018.
//  Copyright © 2018 MapsPeople A/S. All rights reserved.
//

#import "MPAccessibilityHelper.h"
#import <UIKit/UIAccessibility.h>


#if DEBUG && 1
#   define DEBUGLOG(fMT,...)  NSLog( @"[D] MPAccessibilityHelper.m(%d): "fMT,  __LINE__, __VA_ARGS__ )
#else
#   define DEBUGLOG(fMt,...)  /* Nada! */
#endif


@interface MPAccessibilityHelper ()

@property (nonatomic, readwrite) BOOL                       voiceOverEnabled;
@property (nonatomic, strong) NSMutableArray<NSArray*>*     announcementQueue;

@end


@implementation MPAccessibilityHelper

+ (instancetype) sharedInstance {
    
    static MPAccessibilityHelper*   _sharedInstance;
    static dispatch_once_t          onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedInstance = [MPAccessibilityHelper new];
    });
    
    return _sharedInstance;
}

- (instancetype) init {
    
    self = [super init];
    if (self) {
        _voiceOverEnabled = UIAccessibilityIsVoiceOverRunning();
        
        NSNotificationName  voiceOverNotification;
        
        if (@available(iOS 11.0, *)) {
            voiceOverNotification = UIAccessibilityVoiceOverStatusDidChangeNotification;
        } else {
            voiceOverNotification = UIAccessibilityVoiceOverStatusChanged;
        }
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccessibilityVoiceOverStatusDidChangeNotification:) name:voiceOverNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onAccessibilityAnnouncementDidFinishNotification:) name:UIAccessibilityAnnouncementDidFinishNotification object:nil];

        DEBUGLOG( @"Created %@", self.debugDescription );
    }
    
    return self;
}

- (void) dealloc {

    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setVoiceOverEnabled:(BOOL)voiceOverEnabled {
    
    if ( _voiceOverEnabled != voiceOverEnabled ) {
        
        DEBUGLOG( @"voiceOverEnabled %@ -> %@", @(_voiceOverEnabled), @(voiceOverEnabled) );
        _voiceOverEnabled = voiceOverEnabled;
    }
}
- (NSString *) debugDescription {
    
    return [NSString stringWithFormat:@"<MPAccessibilityHelper %p: voiceOverEnabled=%@>", self, self.voiceOverEnabled ? @"YES" : @"NO"];
}

- (void) onAccessibilityVoiceOverStatusDidChangeNotification:(NSNotification*)nfy {

    self.voiceOverEnabled = UIAccessibilityIsVoiceOverRunning();
}

- (void) announceWithCompletion:(NSString*)announcement completion:(mpAccessibilityAnnouncementComplationBlock)completion {
    
    if ( self.voiceOverEnabled && announcement.length ) {
        
        if ( self.announcementQueue == nil ) {
            self.announcementQueue = [NSMutableArray array];
        }
        
        [self.announcementQueue addObject: @[ announcement, completion?:^{} ]];
        
        if ( self.announcementQueue.count == 1 ) {
            UIAccessibilityPostNotification( UIAccessibilityAnnouncementNotification, announcement );
        }
        
    } else if ( completion ) {
        completion();
    }
}

- (void) onAccessibilityAnnouncementDidFinishNotification:(NSNotification*)nfy {
    
    NSArray*    currentAnnouncement = self.announcementQueue.firstObject;
    NSAssert( !currentAnnouncement || [currentAnnouncement isKindOfClass:[NSArray class]], @"" );
    
    if ( currentAnnouncement ) {
        
        NSString*                                   currentAnnouncementString = currentAnnouncement.firstObject;
        mpAccessibilityAnnouncementComplationBlock  completion = currentAnnouncement.lastObject;
        
        NSString*   announced = nfy.userInfo[UIAccessibilityAnnouncementKeyStringValue];
        
        if ( [announced isEqualToString:currentAnnouncementString] ) {
            
            NSAssert( completion, @"" );
            completion();
            
            DEBUGLOG( @"%@: '%@'", [nfy.userInfo[UIAccessibilityAnnouncementKeyWasSuccessful] boolValue] ? @"Announced" : @"Failed to announce", announced );
            
            [self.announcementQueue removeObjectAtIndex:0];
            
            if ( self.announcementQueue.count ) {
                NSArray*    nextAnnouncementObject = self.announcementQueue.firstObject;
                NSAssert( [nextAnnouncementObject isKindOfClass:[NSArray class]], @"" );
                
                NSString*   nextAnnouncementString = nextAnnouncementObject.firstObject;
                
                UIAccessibilityPostNotification( UIAccessibilityAnnouncementNotification, nextAnnouncementString );
            }
        }
    }
}

- (void) setAccessibilityFocus:(UIView*)view {

    UIAccessibilityPostNotification( UIAccessibilityLayoutChangedNotification, view );
}

- (void) layoutChanged {
    
    [self setAccessibilityFocus:nil];
}

@end
