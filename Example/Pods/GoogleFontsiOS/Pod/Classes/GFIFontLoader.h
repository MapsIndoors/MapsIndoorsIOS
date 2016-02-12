//
//  GFIFontLoader.h
//  GoogleFontsiOS
//
//  Created by Okada Yohei on 8/4/15.
//  Copyright (c) 2015 yohei okada. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GFIFontLoader : NSObject
+ (void)loadFontFile:(NSString *)fontFileName
          fromBundle:(NSString *)bundleName
           onceToken:(dispatch_once_t *)onceToken;
@end
