//
//  MPMenuItem.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 08/08/16.
//  Copyright  Daniel Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>
@import JSONModel;


@protocol MPMenuItem
@end

@interface MPMenuItem : JSONModel

@property (nonatomic, strong, nullable) NSString<Optional>* categoryKey;
@property (nonatomic, strong, nullable) NSString<Optional>* menuImageUrl;
@property (nonatomic, strong, nullable) NSString<Optional>* iconUrl;

@end
