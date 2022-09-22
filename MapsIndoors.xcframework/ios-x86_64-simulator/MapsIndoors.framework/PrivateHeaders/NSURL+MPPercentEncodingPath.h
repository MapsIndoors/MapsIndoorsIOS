//
//  NSURL+MPPercentEncodingPath.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 22/09/2021.
//  Copyright © 2021 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSURL (MPPercentEncodingPath)

+ (NSURL*) URLByPercentEncodingPath:(NSString*)url;

@end

NS_ASSUME_NONNULL_END
