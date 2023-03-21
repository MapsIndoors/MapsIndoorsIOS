//
//  MPImageProvider.h
//  MapsIndoorsSDK
//
//  Created by Amine on 28/06/2017.
//  Copyright © 2017 MapsPeople A/S. All rights reserved.
//

@import MapsIndoors;

#pragma mark - [INTERNAL - DO NOT USE]

/// > Warning: [INTERNAL - DO NOT USE]
@interface MPImageProvider : NSObject<MPImageProviderProtocol>

+ (void)imageFromUrlString:(NSString * _Nonnull)urlString imageSize:(CGSize)imageSize completionHandler:(void (^ _Nonnull)(UIImage * _Nullable, NSError * _Nullable))completionHandler;

- (void)imageFromUrlString:(NSString * _Nonnull)urlString completionHandler:(void (^ _Nonnull)(UIImage * _Nullable, NSError * _Nullable))completionHandler;

- (void)imageFromUrlString:(NSString * _Nonnull)urlString imageSize:(CGSize)imageSize completionHandler:(void (^ _Nonnull)(UIImage * _Nullable, NSError * _Nullable))completionHandler;

@end
