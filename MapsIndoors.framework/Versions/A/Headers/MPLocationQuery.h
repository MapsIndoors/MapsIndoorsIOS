//
//  MPLocationQuery.h
//  MapsIndoors
//
//  Created by Daniel Nielsen on 18/03/14.
//  Copyright (c) 2014 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MPMapExtend.h"
#import "MPPoint.h"

@protocol NSString
@end

@interface MPLocationQuery : NSObject

@property (nonatomic, strong) NSString* query;
@property NSString* venue;
@property NSString* building;
@property NSString* orderBy;
@property NSString* sortOrder;
@property MPPoint* near;
@property NSNumber* radius;
@property NSNumber* zoomLevel;
@property NSNumber* floor;
@property MPMapExtend* mapExtend;
@property NSArray* categories;
@property NSArray* types;
@property NSArray* includeDataFields;
@property NSString* solutionId;  //Now using solutionId as Solution Id
@property NSString* arg;         //Backwards compatibility with using arg as Solution Id
@property int max;

-(void)setQuery:(NSString *)query;
-(NSString *)getQuery;
+(void)setTokens:(NSArray*)buildingTokens withFloorTokens:(NSArray*)floorTokens;
+(NSString *)getPattern:(NSArray *) tokenlist;

@end
