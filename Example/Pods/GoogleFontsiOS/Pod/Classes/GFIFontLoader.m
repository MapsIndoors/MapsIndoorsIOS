//
//  GFIFontLoader.m
//  GoogleFontsiOS
//
//  Created by Okada Yohei on 8/4/15.
//  Copyright (c) 2015 yohei okada. All rights reserved.
//

#import "GFIFontLoader.h"

#import <CoreText/CoreText.h>

@interface GFIFontLoader ()
+ (void)loadFontFile:(NSString *)fontFileName fromBundle:(NSString *)bundleName;
@end

@implementation GFIFontLoader
+ (void)loadFontFile:(NSString *)fontFileName fromBundle:(NSString *)bundleName {
    NSURL *bundleURL = [[NSBundle bundleForClass:[self class]] URLForResource:bundleName withExtension:@"bundle"];
    NSBundle *bundle = [NSBundle bundleWithURL:bundleURL];
    
    NSURL *fontURL = [bundle URLForResource:fontFileName withExtension:@"ttf"];
    NSData *fontData = [NSData dataWithContentsOfURL:fontURL];
    
    CGDataProviderRef provider = CGDataProviderCreateWithCFData((CFDataRef)fontData);
    CGFontRef font = CGFontCreateWithDataProvider(provider);
    
    if (font) {
        CFErrorRef error = NULL;
        if (CTFontManagerRegisterGraphicsFont(font, &error) == NO) {
            CFStringRef errorDescription = CFErrorCopyDescription(error);
            @throw [NSException exceptionWithName:NSInternalInconsistencyException reason:(__bridge NSString *)errorDescription userInfo:@{ NSUnderlyingErrorKey: (__bridge NSError *)error }];
        }
        
        CFRelease(font);
    }
    
    CFRelease(provider);
}

+ (void)loadFontFile:(NSString *)fontFileName
          fromBundle:(NSString *)bundleName
           onceToken:(dispatch_once_t *)onceToken {
    dispatch_once(onceToken, ^{
        [self loadFontFile:fontFileName fromBundle:bundleName];
    });
}

@end
