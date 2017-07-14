//
//  MPDataProvider.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 14/07/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^mpDataHandlerBlockType)(NSData* _Nullable data, NSError* _Nullable error, NSHTTPURLResponse* _Nullable response);

@interface MPDataProvider : NSObject

+ (void)dataWithContentsOfURL:(nonnull NSURL *)url
              ifModifiedSince:(NSDate* _Nullable)ifModifiedSinceDate
              comletionHander:(mpDataHandlerBlockType _Nonnull )handler;

@end
