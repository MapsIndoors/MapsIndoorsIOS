//
//  URITemplate.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
/**
 Generates an url based on an URI template. Template string must have format "prefix{param_1}infix{param_N}suffix", e.g.: "http://tiles.url.com/{floor}/{x}/{y}/{zoom}.png"
 */
@interface MPURITemplate : NSObject
/**
 Initialization with template string. Must have format "prefix{param_1}infix{param_N}suffix", e.g.: "http://tiles.url.com/{floor}/{x}/{y}/{zoom}.png"
 */
- (nullable instancetype) initWithTemplateString:(nonnull NSString*)url;

/**
 Template string property. Must have format "prefix{param_1}infix{param_N}suffix", e.g.: "http://tiles.url.com/{floor}/{x}/{y}/{zoom}.png"
 */
@property (nonatomic, strong, nullable) NSString* templateURI;

/**
 Get the resulting url string
 */
@property (nonatomic, strong, nullable, readonly) NSString* resultURI;

/**
 Find the parameter placeholder {name} with given name and replace with given string value
 */
- (void)addParam:(nonnull NSString*)name value:(nonnull NSString*)value;

/**
 Find the parameter placeholder {name} with given name and replace with given int value
 */
- (void)addIntParam:(nonnull NSString*)name value:(int)value;

/**
 Reset the url parameters.
 */
- (void)resetParams;

@end
