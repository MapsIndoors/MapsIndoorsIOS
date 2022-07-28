//
//  MPGoogleApiDataProvider.h
//  MapsIndoors
//
//  Created by Michael Bech Hansen on 07/12/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void (^MPGoogleApiDataProviderCompletion)(NSDictionary* _Nullable dict, NSError* _Nullable error, NSHTTPURLResponse* _Nullable response);


@interface MPGoogleApiDataProvider : NSObject

+ (void) dataWithContentsOfURL:(nonnull NSURL *)url completion:(MPGoogleApiDataProviderCompletion _Nonnull)completion;

@end
