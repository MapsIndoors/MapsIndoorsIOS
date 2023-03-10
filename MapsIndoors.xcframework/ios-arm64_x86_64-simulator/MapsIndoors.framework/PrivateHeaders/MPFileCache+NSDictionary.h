//
//  MPFileCache+NSDictionary.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 15/03/2020.
//  Copyright © 2020 MapsPeople A/S. All rights reserved.
//

#import "MPFileCache.h"


NS_ASSUME_NONNULL_BEGIN

@interface MPFileCache (NSDictionary)

- (NSDictionary*) dictionaryFromCachedFileForUrl:(NSString*)item;

@end

NS_ASSUME_NONNULL_END
