//
//  SwiftPrivate.h
//  MapsIndoors
//
//  Created by Christian Wolf Johannsen on 28/07/2022.
//  Copyright © 2022 MapsPeople A/S. All rights reserved.
//

#ifndef SwiftPrivate_h
#define SwiftPrivate_h

#import <UIKit/UIImage.h>
#import <MapsIndoors/MapsIndoors-Swift.h>

#pragma mark - Forward declarations

@class MPLocation;
@class MPLocationDisplayRule;

@protocol MPSubscriptionClientDelegate;
@protocol MPSubscriptionTopic;

typedef NS_ENUM(NSInteger, MPSubscriptionState);

#pragma mark - Interface extensions

NS_ASSUME_NONNULL_BEGIN

@interface MPDisplayRuleManager ()

@property (nonatomic, weak, class, readonly) MPDisplayRuleManager* sharedInstance;
@property (nonatomic, weak, nullable) MPLocationDisplayRule* defaultDisplayRule;

- (MPLocationDisplayRule*)getDisplayRuleForTypeName:(NSString*)name;
- (MPLocationDisplayRule*)getEffectiveDisplayRuleForLocation:(MPLocation*)location;
- (MPLocationDisplayRule*)resetDisplayRuleForLocation:(MPLocation*)location;
- (MPLocationDisplayRule*)resolveDisplayRuleForLocation:(MPLocation*)location;
- (BOOL)setDisplayRule:(MPLocationDisplayRule*)rule forLocation:(MPLocation*)location;
- (BOOL)setDisplayRule:(MPLocationDisplayRule*)rule forLocationId:(NSString*)name;
- (void)setDisplayRule:(MPLocationDisplayRule*)rule forTypeName:(NSString*)name;
- (nullable UIImage*)model2DImageForURL:(NSString*)model2DURL maxSize:(CGFloat)size completion:(void(^)(UIImage* _Nullable ))image;

@end

@interface MPMQTTSubscriptionClientSwift ()

@property (nonatomic, weak) id<MPSubscriptionClientDelegate> delegate;
@property (nonatomic) MPSubscriptionState state;

- (instancetype)initWithHost:(NSString*)host;
- (void)connect:(BOOL)cleanSessionFlag;
- (void)disconnect;
- (void)subscribe:(id<MPSubscriptionTopic>)topic;
- (void)unsubscribe:(id<MPSubscriptionTopic>)topic;

@end

NS_ASSUME_NONNULL_END

#endif /* SwiftPrivate_h */
