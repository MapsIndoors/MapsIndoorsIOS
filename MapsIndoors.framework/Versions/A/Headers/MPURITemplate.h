//
//  URITemplate.h
//  MapsIndoors SDK for iOS
//
//  Created by Daniel Nielsen on 1/14/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Generates an url based on an URI template. Template string must have format "prefix{param_1}infix{param_N}suffix", e.g.: "http://tiles.url.com/{floor}/{x}/{y}/{zoom}.png"
 */
@interface MPURITemplate : NSObject
/**
 Initialization with template string. Must have format "prefix{param_1}infix{param_N}suffix", e.g.: "http://tiles.url.com/{floor}/{x}/{y}/{zoom}.png"
 */
- (id)initWithTemplateString:(NSString*)url;
/**
 Template string property. Must have format "prefix{param_1}infix{param_N}suffix", e.g.: "http://tiles.url.com/{floor}/{x}/{y}/{zoom}.png"
 */
@property NSString* templateURI;
/**
 Get the resulting url string
 */
@property (readonly) NSString* resultURI;
/**
 Find the parameter placeholder {name} with given name and replace with given string value
 */
- (void)addParam:(NSString*)name value:(NSString*)value;
/**
 Find the parameter placeholder {name} with given name and replace with given int value
 */
- (void)addIntParam:(NSString*)name value:(int)value;
/**
 Reset the url parameters.
 */
- (void)resetParams;
@end
