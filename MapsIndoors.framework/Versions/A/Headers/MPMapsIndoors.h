//
//  MPMapsIndoors.h
//  MapsIndoorsSDK
//
//  Created by Daniel Nielsen on 04/11/2016.
//  Copyright © 2016 Daniel-Nielsen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^mpOfflineDataHandlerBlockType)(NSError* error);

@interface MapsIndoors : NSObject

/**
 * Provides your Solution Id to the MapsIndoors SDK for iOS. This key is generated
 * for your solution.
 *
 * @return YES if the Solution Id was successfully provided
 */
+ (BOOL) provideSolutionId:(NSString*)solutionId;

/**
 * Fetch all neccesary content to be able to run MapsIndoors in offline environments
 * @param language The language for which the content should be fetched. Uses language code ISO 639-1.
 * @param completionHandler Callback function that fires when content has been fetched or if this process resolves in an error. Note: Does not automtically retry fetch.
 */
+ (void)fetchDataForOfflineUse:(NSString*)language completionHandler: (mpOfflineDataHandlerBlockType) completionHandler;

@end
